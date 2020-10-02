from pathlib import Path
import requests
import os
import sys

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)',
    'Referer': "https://lectortmo.com/"}


def download_image(link, directory, image_name):
    image = requests.get(link, headers=HEADERS)

    if image.status_code == 200:
        with open(directory + image_name, "wb") as save_image:
            save_image.write(image.content)
        return True
    else:
        error = f"HTTP error {src.status_code}"
        print(error)
        return error


def get_cache_dir():
    home = str(Path.home())
    if sys.platform == "linux":
        thumbnails = home + "/.cache/nunnix-manga/thumbnails/"
        manga_cache = home + "/.cache/nunnix-manga/manga-cache/"

    if sys.platform == "win32":
        thumbnails = "file:///" + home + "\\AppData\\Local\\nunnix-manga\\thumbnails\\"
        manga_cache = "file:///" + home + "\\AppData\\Local\\nunnix-manga\\manga-cache\\"

    if not os.path.exists(thumbnails):
        os.makedirs(thumbnails)
    if not os.path.exists(manga_cache):
        os.makedirs(manga_cache)

    return thumbnails, manga_cache
