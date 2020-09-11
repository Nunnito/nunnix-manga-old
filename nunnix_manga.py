from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QTranslator
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtGui import QGuiApplication
from pathlib import Path
from scrapers import *
import threading
import json
import sys
import os

config_file = open("config.json", "r").read()


class NunnixManga_TMO(QObject):
    manga_source = mangakatana
    manga_slider_size = json.loads(config_file)["explorer"]["slider_size"]

    slider_data = pyqtSignal(list, str, int, arguments=["manga_data", "manga_type", "slider_int"])

    def __init__(self):
        QObject.__init__(self)
        self.thumbnail_dir, self.manga_save_dir = self.get_cache_dir()

    @pyqtSlot(str)
    def change_manga_source(self, manga_source):
        exec("self.manga_source = {}".format(manga_source))

    @pyqtSlot(str, int)
    def get_manga_slider_covers(self, manga_type, slider_int):
        slider_data = threading.Thread(target=self.get_manga_slider_covers_thread, args=[manga_type, slider_int])
        slider_data.start()

    def get_manga_slider_covers_thread(self, manga_type, slider_int):

        if manga_type == "popular":
            manga_data_slider = self.manga_source.get_manga_popular()
        if manga_type == "seinen":
            manga_data_slider = self.manga_source.search_manga(category="seinen")
        if manga_type == "shounen":
            manga_data_slider = self.manga_source.search_manga(category="shounen")
        if manga_type == "josei":
            manga_data_slider = self.manga_source.search_manga(category="josei")
        if manga_type == "shoujo":
            manga_data_slider = self.manga_source.search_manga(category="shoujo")

        manga_links_covers = ([cover["manga_cover"] for cover in manga_data_slider])
        manga_links = ([link["manga_link"] for link in manga_data_slider])

        covers = []
        manga_names = []

        self.manga_source.download_and_save_manga_covers(manga_links_covers, manga_links, self.manga_slider_size)

        for manga_link in manga_links:
            covers.append(self.thumbnail_dir + manga_link.replace("/", "").replace(":", "") + ".jpg")

        for manga_name in manga_data_slider:
            manga_names.append(manga_name["manga_name"].strip())

        data_slider = [covers[0:self.manga_slider_size], manga_names[0:self.manga_slider_size],
                       manga_links[0:self.manga_slider_size]]
        self.slider_data.emit(data_slider, manga_type, slider_int)

    def get_cache_dir(self):
        home = str(Path.home())
        if sys.platform == "linux":
            return home + "/.cache/nunnix-manga/thumbnails/", home + "/.cache/nunnix-manga/manga-cache/"
        if sys.platform == "win32":
            return "file:///" + home + "\\AppData\\Local\\nunnix-manga\\cache\\",
            "file:///" + home + "\\AppData\\Local\\nunnix-manga\\manga-cache\\"


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Normal"
application = QGuiApplication([])


nunnix_manga_tmo = NunnixManga_TMO()
engine = QQmlApplicationEngine()

translator = QTranslator()
translator.load("base-gui/translating-qml_es.qm")
application.installTranslator(translator)

context = engine.rootContext()
context.setContextProperty("NunnixManga", nunnix_manga_tmo)
context.setContextProperty("config_file", config_file)

engine.load(__file__.replace("nunnix_manga.py", "base-gui/nunnix_manga.qml"))
application.exec_()
