from requests.exceptions import ConnectionError, ReadTimeout
from pathlib import Path
import requests
import json
import os
import sys

HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)'}


def download_image(link, directory, image_name):
    if Path(directory + image_name).exists():
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

    if not Path(thumbnails).exists():
        os.makedirs(thumbnails)
    if not Path(cache).exists():
        os.makedirs(cache)
    if not Path(downloads).exists():
        os.makedirs(downloads)

    return thumbnails, cache, downloads


# Writes keys and value to the config file.
def config_writer(*keys, value=""):
    file_read = config_file()
    string_to_exec = "file_read"

    for key in keys:
        string_to_exec += f"['{key}']"
    string_to_exec += f"='{value}'"  # String to execute.

    exec(string_to_exec)  # Creates keys and a value.

    # Writes.
    with open("config.json", "w") as write_config:
        json.dump(file_read, write_config, indent=4)


# Returns a config file, if it doesn't exists, creates it.
def config_file():
    default_config = {
        "system": {
            "scale_factor": 1
        },
        "scrapers": {
            "current": "mangakatana",
            "current_alias": "Mangakatana"
        }
    }

    config_path = "config.json"
    if not Path(config_path).exists():
        with open(config_path, "w") as config_file:
            json.dump(default_config, config_file, indent=4)

    config_file = json.loads(open(config_path, "r").read())
    return config_file


def manga_writer():
    pass
