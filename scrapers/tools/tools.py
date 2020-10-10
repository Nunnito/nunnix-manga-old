from requests.exceptions import ConnectionError, ReadTimeout
from pathlib import Path
import requests
import os
import sys

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)'}


def download_image(link, directory, image_name):
    if os.path.exists(directory + image_name):
        return True

    try:
        print("Downloading image...")
        image = requests.get(link, headers=HEADERS, timeout=60)

        if image.status_code == 200:
            print("Image downloaded!")
            with open(directory + image_name, "wb") as save_image:
                save_image.write(image.content)
            return True
        else:
            error = f"HTTP error {src.status_code}"
            print(error)
            return False

    except (ConnectionError, ReadTimeout) as error:
        print(error)
        return False


# Creates two cache directories
def get_cache_dir():
    home = str(Path.home())
    if sys.platform == "linux":
        thumbnails = home + "/.cache/nunnix-manga/thumbnails/"
        cache = home + "/.cache/nunnix-manga/manga-cache/"
        downloads = home + "/.nunnix-manga/manga/"

    if sys.platform == "win32":
        thumbnails = home + "/AppData/Local/nunnix-manga/thumbnails/"
        cache = home + "/AppData/Local/nunnix-manga/manga-cache/"
        downloads = home + "/AppData/Local/nunnix-manga/manga-downloads/"

    if not os.path.exists(thumbnails):
        os.makedirs(thumbnails)
    if not os.path.exists(cache):
        os.makedirs(cache)
    if not os.path.exists(downloads):
        os.makedirs(downloads)

    return thumbnails, cache, downloads
