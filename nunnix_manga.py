from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QVariant
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine
from requests.exceptions import ConnectionError, ReadTimeout
from PyQt5.QtGui import QGuiApplication
from scrapers.tools import tools
from threading import Thread
from pathlib import Path
from scrapers import *
import scrapers
import json
import sys
import os
import re


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
        tools.config_writer("scrapers", "current", value=manga_source_name)
        tools.config_writer("scrapers", "current_alias", value=alias)

        # Reads and sends to QML.
        config_file_read = tools.config_file()
        context.setContextProperty("configFile", config_file_read)

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
            if Path(thumbnail_dir + name).exists():
                thumbnail["thumbnail"] = Path(thumbnail_dir + name).as_uri()

        return data


# Manga viewer (data)
class Viewer(QObject):
    manga_data = pyqtSignal("QVariant", "QVariant", str, str, bool, arguments=["mangaData", "source", "error", "saved"])

    def __init__(self):
        QObject.__init__(self)

    # Set manga data thread
    @pyqtSlot(str, str, str, bool)
    def set_manga_data(self, url, source, name, forced):
        data = Thread(target=self.set_manga_data_thread, args=[url, source, name, forced])
        data.start()

    @pyqtSlot(str, str, str)
    def save_manga(self, data, source, name):
        name = re.sub(windows_expr, "", name)  # Windows folders support.
        source_config_dir = Path(manga_config_dir, source, name)

        # If the manga config does not exists
        if not Path(source_config_dir).exists():
            os.makedirs(Path(source_config_dir).absolute())

        with open(str(Path(source_config_dir, name)) + ".json", "w") as config:
            json.dump(json.loads(data), config, indent=4, ensure_ascii=False)

    # Set manga data
    def set_manga_data_thread(self, url, source, name, forced):
        config_manga_file = str(Path(manga_config_dir, source, name, name)) + ".json"
        data_saved = {}

        if Path(config_manga_file).exists():
            with open(config_manga_file) as f:
                data = json.load(f)
                saved = True

            if forced:
                data_saved = data
                data = manga_source.get_manga_data(url)
                saved = False
        else:
            data = manga_source.get_manga_data(url)
            saved = False

        if type(data) == ConnectionError:
            self.manga_data.emit({}, {}, "", "ConnectionError", False)
        elif type(data) == ReadTimeout:
            self.manga_data.emit({}, {}, "", "ReadTimeout", False)
        elif type(data) == str:
            self.manga_data.emit({}, {}, "", data, False)
        else:
            self.manga_data.emit(data, data_saved, manga_source.name, "", saved)

    @pyqtSlot(str, str, str)
    def delete_manga(self, source, name, chapter):
        # Windows folders support.
        chapter = re.sub(windows_expr, "", chapter)
        name = re.sub(windows_expr, "", name)

        chapter_dir = downloads_dir + source + "/" + name + "/" + chapter + "/"

        for image in os.walk(chapter_dir):
            images_name = image[2]

            for image_name in images_name:
                image_path = image[0] + image_name
                os.remove(image_path)


# Manga reader
class Reader(QObject):
    def __init__(self):
        QObject.__init__(self)


class Downloader(QObject):
    get_images = pyqtSignal(str, int, int, str, int, int, arguments=[
        "images", "imgWidth", "imgHeight" "buttonLink", "imagesCount", "downloadCount"])
    downloaded = pyqtSignal(str, arguments="buttonLink")

    def __init__(self):
        QObject.__init__(self)

    # Set images thread
    @pyqtSlot(str, str, str, str, bool, str, bool)
    def set_images(self, url, source, name, chapter, cached, index, downloaded):
        data = Thread(target=self.set_images_thread, args=[url, source, name, chapter, cached, index, downloaded])
        data.start()

    # Set images
    def set_images_thread(self, url, source, name, chapter, cached, link, downloaded):
        if cached or not downloaded:
            images = manga_source.get_chapters_images(url)

        # Windows folders support.
        name = re.sub(windows_expr, "", name)
        chapter = re.sub(windows_expr, "", chapter)

        images_size = {}
        images_config_path = Path(manga_config_dir, source, name, chapter)

        # If the image will not be saved
        if cached:
            chapter_dir = cache_save_dir + source + "/" + name + "/" + chapter + "/"
            link = None
        # If the image will be saved
        else:
            chapter_dir = downloads_dir + source + "/" + name + "/" + chapter + "/"
            if downloaded:
                images = [image for image in os.walk(chapter_dir)][0][2]

        # If the chapter directory does not exists
        if not Path(chapter_dir).exists():
            os.makedirs(Path(chapter_dir).absolute())

        for i in range(len(images)):
            image_name = str(i) + re.search(r"\..{3,4}$", images[i]).group()
            image_path = chapter_dir + image_name

            if cached or not downloaded:
                image = tools.download_image(images[i], chapter_dir, image_name)
                while not image:
                    image = tools.download_image(images[i], chapter_dir, image_name)

            if os.path.exists(str(images_config_path) + ".json") and images_size == {}:
                with open(str(images_config_path) + ".json") as f:
                    sizes = json.load(f)
                    width = sizes[image_name][0]
                    height = sizes[image_name][1]
            else:
                width, height = tools.get_image_size(image_path)
                images_size[image_name] = [width, height]
                with open(str(images_config_path) + ".json", "w") as image_config:
                    json.dump(images_size, image_config, indent=4)

            self.get_images.emit(Path(image_path).as_uri(), width, height, link, len(images), i + 1)

        self.downloaded.emit(link)


config_file = tools.config_file()
scale_factor = config_file["system"]["scale_factor"]
current_scraper = config_file["scrapers"]["current"]

thumbnail_dir, cache_save_dir, downloads_dir, config_dir, manga_config_dir = tools.get_cache_dir()

scraper_data = {}
manga_source = eval(current_scraper)

for scraper in scrapers.__all__:
    scraper_data[eval(scraper).name] = scraper

windows_expr = re.compile(r"[\\/:*?\"<>|]")


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Dense"
os.environ["QT_SCALE_FACTOR"] = str(scale_factor)
application = QGuiApplication(sys.argv)

manga_searcher = Searcher()
manga_viewer = Viewer()
manga_reader = Reader()
manga_downloader = Downloader()
engine = QQmlApplicationEngine()

# Pass variables to QML
context = engine.rootContext()
context.setContextProperty("MangaSearcher", manga_searcher)
context.setContextProperty("MangaViewer", manga_viewer)
context.setContextProperty("MangaReader", manga_reader)
context.setContextProperty("MangaDownloader", manga_downloader)
context.setContextProperty("configFile", config_file)
context.setContextProperty("scraperData", scraper_data)
context.setContextProperty("thumbnailDir", thumbnail_dir)
context.setContextProperty("os", sys.platform)

engine.load("gui/nunnix_manga.qml")
sys.exit(application.exec_())
