from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QVariant
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine
from requests.exceptions import ConnectionError, ReadTimeout
from PyQt5.QtGui import QGuiApplication
from threading import Thread
from scrapers.tools import tools
from scrapers import *
import json
import os
import re

config_file = open("config.json", "r").read()
scale_factor = json.loads(config_file)["system"]["scale_factor"]
manga_source = mangakatana


class Searcher(QObject):
    global manga_source

    temp = True
    search_manga_data = pyqtSignal(list, str, arguments=["dataSearch", "error"])
    search_manga_controls = pyqtSignal(str, arguments=["jsonControls"])

    def __init__(self):
        QObject.__init__(self)
        self.manga_source = manga_source
        self.thumbnail_dir, self.manga_save_dir = tools.get_cache_dir()

    @pyqtSlot(str)
    def change_manga_source(self, manga_source):
        exec("self.manga_source = {}".format(manga_source))

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

        controls = self.manga_source.get_search_controls()
        if self.temp:
            self.search_manga_controls.emit(controls)
            self.temp = False


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
context.setContextProperty("config_file", config_file)

engine.load(__file__.replace("nunnix_manga.py", "gui/nunnix_manga.qml"))
application.exec_()
