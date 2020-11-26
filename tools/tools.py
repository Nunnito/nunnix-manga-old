from requests.exceptions import ConnectionError, ReadTimeout
from pathlib import Path
from PIL import Image
import requests
import json
import os
import sys

HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)'}


def download_image(link, directory, image_name):
    """
    Download an image.

    Args:
        link (str): Image link to download.
        directory (str): Directory where the image will be stored.
        image_name (str): Image name.

    Returns:
        bool: If the image is downloaded, returns True, else returns False.
    """

    # If the image already exists on the system, return True.
    if Path(directory, image_name).exists():
        return True

    try:
        print("Downloading image...")
        image = requests.get(link, headers=HEADERS, timeout=60)

        if image.status_code == 200:
            print("Image downloaded!")

            # Save the image.
            with open(Path(directory, image_name), "wb") as save_image:
                save_image.write(image.content)
            return True
        else:
            error = f"HTTP error {src.status_code}"
            print(error)
            return False

    # If there is an error, returns False.
    except (ConnectionError, ReadTimeout) as error:
        print(error)
        return False


def get_dirs():
    """ Returns the directories used. """

    home = str(Path.home())
    if sys.platform == "linux":
        thumbnails = home + "/.cache/nunnix-manga/thumbnails/"
        cache = home + "/.cache/nunnix-manga/manga-cache/"
        downloads = home + "/.local/share/nunnix-manga/manga/"
        config = home + "/.config/nunnix-manga/config/"
        manga_config = home + "/.config/nunnix-manga/config/manga"

    if sys.platform == "win32":
        thumbnails = home + "/AppData/Local/nunnix-manga/thumbnails/"
        cache = home + "/AppData/Local/nunnix-manga/manga-cache/"
        downloads = home + "/AppData/Local/nunnix-manga/manga-downloads/"
        config = home + "/AppData/Local/nunnix-manga/config"
        manga_config = home + "/AppData/Local/nunnix-manga/config/manga"

    if not Path(thumbnails).exists():
        os.makedirs(thumbnails)
    if not Path(cache).exists():
        os.makedirs(cache)
    if not Path(downloads).exists():
        os.makedirs(downloads)
    if not Path(config).exists():
        os.makedirs(config)
    if not Path(manga_config).exists():
        os.makedirs(manga_config)

    return thumbnails, cache, downloads, config, manga_config


def config_writer(*keys, value=""):
    """
    Writes a key. At the end, writes the value in the final key.
    All keys, except the last one, must exists.

    Args:
        keys (str): One or more keys.
        value (str, optional): Value to append in the final key.
    """

    config_path = get_dirs()[3]
    file_read = config_file()
    string_to_exec = "file_read"  # Makes a whole string to execute

    for key in keys:
        string_to_exec += f"['{key}']"
    string_to_exec += f"='{value}'"  # String to execute.

    # Creates keys and a value.
    # Looks like this:
    #   dict[key1][key2][key3][key4] = value
    exec(string_to_exec)

    # Writes.
    with open(Path(config_path, "config.json"), "w") as write_config:
        json.dump(file_read, write_config, indent=4)


def config_file():
    """ Returns a config file, if it doesn't exists, creates it. """

    # Default configuration.
    default_config = {
        "system": {
            "scale_factor": 1
        },
        "scrapers": {
            "current": "mangakatana",
            "current_alias": "Mangakatana"
        }
    }

    config_path = Path(get_dirs()[3], "config.json")

    # If the configuration file doesn't exists
    # create it with the default configuration file
    if not config_path.exists():
        with open(config_path, "w") as config_file:
            json.dump(default_config, config_file, indent=4)

    # Load the configuration file and read it.
    with open(config_path) as f:
        config_file = json.load(f)

    return config_file  # Returns the configuration file.


def get_image_size(image_path):
    """
    Returns the size of an image

    Args:
        image_path (str): The image path.

    Returns:
        tuple (int): Width and height.
    """

    image = Image.open(image_path)
    size = image.size
    image.close()

    return size


# Taken from: https://gist.github.com/TheMatt2/faf5ca760c61a267412c46bb977718fa
def walklevel(path, depth=1):
    """It works just like os.walk, but you can pass it a level parameter
       that indicates how deep the recursion will go.
       If depth is 1, the current directory is listed.
       If depth is 0, nothing is returned.
       If depth is -1 (or less than 0), the full depth is walked.
    """

    # If depth is negative, just walk
    # Not using yield from for python2 compat
    # and copy dirs to keep consistant behavior for depth = -1 and depth = inf
    if depth < 0:
        for root, dirs, files in os.walk(path):
            yield root, dirs[:], files
        return
    elif depth == 0:
        return

    # path.count(os.path.sep) is safe because
    # - On Windows "\\" is never allowed in the name of a file or directory
    # - On UNIX "/" is never allowed in the name of a file or directory
    # - On MacOS a literal "/" is quitely translated to a ":" so it is still
    #   safe to count "/".
    base_depth = path.rstrip(os.path.sep).count(os.path.sep)
    for root, dirs, files in os.walk(path):
        yield root, dirs[:], files
        cur_depth = root.count(os.path.sep)
        if base_depth + depth <= cur_depth:
            del dirs[:]
