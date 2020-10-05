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

scraper_data = {}
manga_source = eval(current_scraper)

for scraper in scrapers.__all__:
    scraper_data[eval(scraper).name] = scraper


class Searcher(QObject):
    global manga_source

    search_manga_data = pyqtSignal(list, str, arguments=["dataSearch", "error"])
    search_manga_controls = pyqtSignal(str, arguments=["jsonControls"])

    def __init__(self):
        QObject.__init__(self)
        self.manga_source = manga_source
        self.thumbnail_dir, self.manga_save_dir = tools.get_cache_dir()

    @pyqtSlot(str, str)
    def change_manga_source(self, manga_source, alias):
        self.manga_source = eval(manga_source)

        config_writer("scrapers", "current", value=manga_source)
        config_writer("scrapers", "current_alias", value=alias)

        config_file_read = json.loads(open("config.json", "r").read())
        context.setContextProperty("configFile", config_file_read)

        self.emit_controls()

    @pyqtSlot(str, int)
    def search_manga(self, parameter_list, page):
        data = Thread(target=self.search_manga_thread, args=[parameter_list, page])
        data.start()

    def search_manga_thread(self, parameter_list, page):
        data = self.manga_source.search_manga(**json.loads(parameter_list), page=page)

        if type(data) == ConnectionError:
            self.search_manga_data.emit([], "ConnectionError")
        elif type(data) == ReadTimeout:
            self.search_manga_data.emit([], "ReadTimeout")
        elif type(data) == str:
            self.search_manga_data.emit([], data)
        else:
            self.search_manga_data.emit(data, "")

    @pyqtSlot()
    def emit_controls(self):
        controls = self.manga_source.get_search_controls()
        self.search_manga_controls.emit(controls)


class Viewer(QObject):
    global manga_source

    manga_data = pyqtSignal("QVariant", str, arguments=["mangaData", "error"])

    def __init__(self):
        QObject.__init__(self)
        self.manga_source = manga_source

    @pyqtSlot(str)
    def set_manga_data(self, url):
        data = Thread(target=self.set_manga_data_thread, args=[url])
        data.start()

    def set_manga_data_thread(self, url):
        data = self.manga_source.get_manga_data(url)

        if type(data) == ConnectionError:
            self.manga_data.emit({}, "ConnectionError")
        elif type(data) == ReadTimeout:
            self.manga_data.emit({}, "ReadTimeout")
        elif type(data) == str:
            self.manga_data.emit({}, data)
        else:
            self.manga_data.emit(data, "")


def config_writer(*keys, value=""):
    file_read = json.loads(open("config.json", "r").read())
    string_to_exec = "file_read"

    for key in keys:
        string_to_exec += f"['{key}']"
    string_to_exec += f"='{value}'"

    exec(string_to_exec)

    with open("config.json", "w") as write_config:
        json.dump(file_read, write_config, indent=4)


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Dense"
os.environ["QT_SCALE_FACTOR"] = str(scale_factor)
application = QGuiApplication([])

manga_searcher = Searcher()
manga_viewer = Viewer()
engine = QQmlApplicationEngine()

context = engine.rootContext()
context.setContextProperty("MangaSearcher", manga_searcher)
context.setContextProperty("MangaViewer", manga_viewer)
context.setContextProperty("configFile", config_file)
context.setContextProperty("scraperData", scraper_data)

engine.load(__file__.replace("nunnix_manga.py", "gui/nunnix_manga.qml"))
application.exec_()
