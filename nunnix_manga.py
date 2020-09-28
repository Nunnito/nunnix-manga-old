from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine
from requests.exceptions import ConnectionError, ReadTimeout
from PyQt5.QtGui import QGuiApplication
from threading import Thread
from pathlib import Path
from scrapers import *
import json
import sys
import os
import re

config_file = open("config.json", "r").read()
scale_factor = json.loads(config_file)["system"]["scale_factor"]


class NunnixManga_TMO(QObject):
    manga_source = lectortmo
    search_manga_data = pyqtSignal(list, str, arguments=["dataSearch", "error"])
    search_manga_controls = pyqtSignal(str, arguments=["jsonControls"])

    def __init__(self):
        QObject.__init__(self)
        self.thumbnail_dir, self.manga_save_dir = self.get_cache_dir()

    @pyqtSlot(str)
    def change_manga_source(self, manga_source):
        exec("self.manga_source = {}".format(manga_source))

    @pyqtSlot(list, int)
    def search_manga(self, parameter_list, page):
        data = Thread(target=self.search_manga_thread, args=[parameter_list, page])
        data.start()

    def search_manga_thread(self, parameter_list, page):
        data = self.manga_source.search_manga(*parameter_list, page=str(page))

        if type(data) == ConnectionError:
            self.search_manga_data.emit([], "ConnectionError")
        elif type(data) == ReadTimeout:
            self.search_manga_data.emit([], "ReadTimeout")
        elif type(data) == str:
            if data == "HTTP error 404":
                self.search_manga_data.emit([], "end")
            else:
                self.search_manga_data.emit([], data)
        else:
            self.search_manga_data.emit(data, "")

        controls = self.manga_source.get_search_controls()
        self.search_manga_controls.emit(controls)
        # print(self.manga_source.search_manga.__code__.co_varnames[:self.manga_source.search_manga.__code__.co_argcount])
        # print(self.manga_source.search_manga.__defaults__)

    def get_cache_dir(self):
        home = str(Path.home())
        if sys.platform == "linux":
            return home + "/.cache/nunnix-manga/thumbnails/", home + "/.cache/nunnix-manga/manga-cache/"
        if sys.platform == "win32":
            return "file:///" + home + "\\AppData\\Local\\nunnix-manga\\cache\\",
            "file:///" + home + "\\AppData\\Local\\nunnix-manga\\manga-cache\\"


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Dense"
os.environ["QT_SCALE_FACTOR"] = str(scale_factor)
application = QGuiApplication([])

nunnix_manga_tmo = NunnixManga_TMO()
engine = QQmlApplicationEngine()

context = engine.rootContext()
context.setContextProperty("NunnixManga", nunnix_manga_tmo)
context.setContextProperty("config_file", config_file)

engine.load(__file__.replace("nunnix_manga.py", "gui/nunnix_manga.qml"))
application.exec_()
