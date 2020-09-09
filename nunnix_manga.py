from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtGui import QGuiApplication
from pathlib import Path
from scrapers import *
import threading
import os
import sys

ui_scaling_factor = 1
manga_slider_size = 15


class NunnixManga_TMO(QObject):
	manga_source = lectortmo

	popular_mangas = pyqtSignal(list, str, arguments=["popular_data", "manga_type"])

	if sys.platform == "linux":
		thumbnail_dir = str(Path.home()) + "/.cache/nunnix-manga/thumbnails/"
		manga_save_dir = str(Path.home()) + "/.cache/nunnix-manga/manga-cache/"
	if sys.platform == "wdownload_and_save_manga_coversdownload_and_save_manga_coversin32":
		thumbnail_dir = "file:///" + str(Path.home()) + "\\AppData\\Local\\nunnix-manga\\cache\\"
		manga_save_dir = "file:///" + str(Path.home()) + "\\AppData\\Local\\nunnix-manga\\manga-cache\\"

	def __init__(self):
		QObject.__init__(self)

	@pyqtSlot(str)
	def change_manga_source(self, manga_source):
		exec("self.manga_source = {}".format(manga_source))

	@pyqtSlot(str)
	def get_manga_popular_covers(self, demography):
		popular = threading.Thread(target=self.get_manga_popular_covers_thread, args=[demography])
		popular.start()

	def get_manga_popular_covers_thread(self, demography):

		if demography == "popular":
			manga_data_slider = self.manga_source.get_manga_popular()
		if demography == "seinen":
			manga_data_slider = self.manga_source.search_manga(category="seinen")

		manga_links_covers = ([cover["manga_cover"] for cover in manga_data_slider])
		manga_links = ([link["manga_link"] for link in manga_data_slider])

		covers = []
		manga_names = []

		self.manga_source.download_and_save_manga_covers(manga_links_covers, manga_links, manga_slider_size)

		for manga_link in manga_links:
			covers.append(self.thumbnail_dir + manga_link.replace("/", "").replace(":", "") + ".jpg")

		for manga_name in manga_data_slider:
			manga_names.append(manga_name["manga_name"].strip())

		popular_mangas = [covers[0:manga_slider_size], manga_names[0:manga_slider_size], manga_links[0:manga_slider_size]]
		self.popular_mangas.emit(popular_mangas, demography)


os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Normal"
application = QGuiApplication([])


nunnix_manga_tmo = NunnixManga_TMO()
engine = QQmlApplicationEngine()

context = engine.rootContext()
context.setContextProperty("NunnixManga", nunnix_manga_tmo)
context.setContextProperty("scaling_factor", ui_scaling_factor)
context.setContextProperty("manga_slider_size", manga_slider_size)
engine.load(__file__.replace("nunnix_manga.py", "base-gui/nunnix_manga.qml"))
application.exec_()
