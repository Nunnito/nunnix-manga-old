from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QVariant
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine
from requests.exceptions import ConnectionError, ReadTimeout
from PyQt5.QtGui import QGuiApplication
from threading import Thread
from scrapers.tools import tools
from scrapers import *
import scrapers
import json
import os
import re

config_file = json.loads(open("config.json", "r").read())
scale_factor = config_file["system"]["scale_factor"]
current_scraper = config_file["scrapers"]["current"]

thumbnail_dir, cache_save_dir = tools.get_cache_dir()

scraper_data = {}
manga_source = eval(current_scraper)

for scraper in scrapers.__all__:
    scraper_data[eval(scraper).name] = scraper


# Manga searcher.
class Searcher(QObject):
    search_manga_data = pyqtSignal(list, str, arguments=["dataSearch", "error"])
    search_manga_controls = pyqtSignal(str, arguments=["jsonControls"])

    def __init__(self):
        QObject.__init__(self)

    # Allows change source.
    @pyqtSlot(str, str)
    def change_manga_source(self, manga_source_name, alias):
        global manga_source
        manga_source = eval(manga_source_name)  # New manga source.

        # Write the config file.
        config_writer("scrapers", "current", value=manga_source_name)
        config_writer("scrapers", "current_alias", value=alias)

        self.emit_controls()

    # Search manga thread.
    @pyqtSlot(str, int)
    def search_manga(self, parameter_list, page):
        data = Thread(target=self.search_manga_thread, args=[parameter_list, page])
        data.start()

    # Download thumbnail thread.
    @pyqtSlot(str, str)
    def download_thumbnail(self, link, image_name):
        data = Thread(target=tools.download_image, args=[link, thumbnail_dir, image_name])
        data.start()

    # Allows search.
    def search_manga_thread(self, parameter_list, page):
        data = manga_source.search_manga(**json.loads(parameter_list), page=page)

        if type(data) == ConnectionError:
            self.search_manga_data.emit([], "ConnectionError")
        elif type(data) == ReadTimeout:
            self.search_manga_data.emit([], "ReadTimeout")
        elif type(data) == str:
            self.search_manga_data.emit([], data)
        else:
            data = self.check_thumbnail(data)
            self.search_manga_data.emit(data, "")

    # Emit advanced search controls.
    @pyqtSlot()
    def emit_controls(self):
        controls = manga_source.get_search_controls()
        self.search_manga_controls.emit(controls)

    # Check if the thumbnail already exists.
    def check_thumbnail(self, data):
        for thumbnail in data:
            name = re.search(r"[^/]\w+\..{3,4}$", thumbnail["thumbnail"]).group()
            if os.path.exists(thumbnail_dir + name):
                thumbnail["thumbnail"] = thumbnail_dir + name

        return data


# Manga viewer (data)
class Viewer(QObject):
    manga_data = pyqtSignal("QVariant", str, arguments=["mangaData", "error"])

    def __init__(self):
        QObject.__init__(self)

    # Set manga data thread
    @pyqtSlot(str)
    def set_manga_data(self, url):
        data = Thread(target=self.set_manga_data_thread, args=[url])
        data.start()

    # Set manga data
    def set_manga_data_thread(self, url):
        data = manga_source.get_manga_data(url)

        if type(data) == ConnectionError:
            self.manga_data.emit({}, "ConnectionError")
        elif type(data) == ReadTimeout:
            self.manga_data.emit({}, "ReadTimeout")
        elif type(data) == str:
            self.manga_data.emit({}, data)
        else:
            self.manga_data.emit(data, "")


# Manga reader
class Reader(QObject):
    get_images = pyqtSignal(str, arguments=["images"])

    def __init__(self):
        QObject.__init__(self)

    # Set images thread
    @pyqtSlot(str, str, str, bool)
    def set_images(self, url, name, chapter, cached):
        data = Thread(target=self.set_images_thread, args=[url, name, chapter, cached])
        data.start()

    # Set images
    def set_images_thread(self, url, name, chapter, cached):
        # If the image will not be downloaded
        if cached:
            images = manga_source.get_chapters_images(url)
            chapter_dir = cache_save_dir + name + "/" + chapter + "/"

            # If the chapter directory does not exists
            if not os.path.exists(chapter_dir):
                os.makedirs(chapter_dir)

            for i in range(len(images)):
                image_name = str(i) + re.search(r"\..{3,4}$", images[i]).group()
                image_path = chapter_dir + image_name

                image = tools.download_image(images[i], chapter_dir, image_name)
                while not image:
                    image = tools.download_image(images[i], chapter_dir, image_name)

                self.get_images.emit(image_path)


# Writes keys and value to the config file.
def config_writer(*keys, value=""):
    file_read = json.loads(open("config.json", "r").read())
    string_to_exec = "file_read"

    for key in keys:
        string_to_exec += f"['{key}']"
    string_to_exec += f"='{value}'"  # String to execute.

    exec(string_to_exec)  # Creates keys and a value.

    # Writes.
    with open("config.json", "w") as write_config:
        json.dump(file_read, write_config, indent=4)

    # Reads and sends to QML.
    config_file_read = json.loads(open("config.json", "r").read())
    context.setContextProperty("configFile", config_file_read)


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Dense"
os.environ["QT_SCALE_FACTOR"] = str(scale_factor)
application = QGuiApplication([])

manga_searcher = Searcher()
manga_viewer = Viewer()
manga_reader = Reader()
engine = QQmlApplicationEngine()

# Pass variables to QML
context = engine.rootContext()
context.setContextProperty("MangaSearcher", manga_searcher)
context.setContextProperty("MangaViewer", manga_viewer)
context.setContextProperty("MangaReader", manga_reader)
context.setContextProperty("configFile", config_file)
context.setContextProperty("scraperData", scraper_data)
context.setContextProperty("thumbnailDir", thumbnail_dir)

engine.load(__file__.replace("nunnix_manga.py", "gui/nunnix_manga.qml"))
application.exec_()
