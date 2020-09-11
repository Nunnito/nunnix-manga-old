from requests.exceptions import ConnectionError, ReadTimeout
from concurrent.futures import ThreadPoolExecutor
from tempfile import TemporaryDirectory
from bs4 import BeautifulSoup
from pathlib import Path
from PIL import Image
import requests
import sys
import os
import re

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)',
    'Referer': "http://mangakatana.com/"}


def get_manga_data(url):
    """Gets all the necessary data from the manga and return a dictionary

    Args:
        url (str): The manga page url.

    Returns:
        dict: Dictionary with all the necessary data from the manga

    Example:
        >>> get_manga_data("http://mangakatana.com/manga/attack-on-titan.842")

    Dictionary content
    ------------------
    manga_data = {
                "title": "",
                "current_state": "",
                "author": "",
                "genres": [],
                "description": "",
                "cover": "",
                "total_chapters": "",
                "chapters_data": {
                        "chapter_1": {
                                "name": "Chapter 1",
                                "link": "https://mangakatana.com/manga/attack-on-titan.842/c130",
                                "upload_date": "3/1/19"
                                "fansub": "NekoCreme"
                        }
                }
    }
    """

    print("\nLoading page data...")
    src = requests.get(url, headers=headers)  # Get page source
    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    # Dictionary where all manga data will be stored
    manga_data = {
        "title": "",
        "current_state": "",
        "author": "",
        "genres": [],
        "description": "",
        "cover": "",
        "total_chapters": "",
        "chapters_data": {}
    }

    # Manga title
    manga_data["title"] = page_source.find("h1", {"class": "heading"}).text.strip()
    print("Title obtained!")

    # Manga status
    manga_data["current_state"] = page_source.find("div", {"class": "status"}).text
    print("Manga status obtained!")

    # Manga author
    try:
        manga_data["author"] = page_source.find("a", {"class": "author"}).text.strip()
    except AttributeError:
        manga_data["author"] = "n/a"
    print("Manga author obtained!")

    # Manga genres
    genres = page_source.find("div", {"class": "genres"}).find_all("a")
    manga_data["genres"] = [genre.text for genre in genres]
    print("Manga genres obtained")

    # Manga description
    manga_data["description"] = page_source.find("div", {"class": "summary"}).find("p").text
    print("Manga description obtained!")

    # Manga cover
    manga_data["cover"] = page_source.find("div", {"class": "cover"}).find("img").get("src")
    print("Manga cover obtained!")

    # Manga total chapters
    manga_data["total_chapters"] = int(page_source.find("div", {"class": "uk-width-medium-1-4"}).text.split()[0])
    print("Total chapters obtained!")

    # Manga chapters links
    chapters_data = page_source.find("div", {"class": "chapters"})

    chapters_name = []
    chapters_links = []
    chapters_upload_date = []

    for chapter_data in chapters_data:
        chapters_name = [name.text.strip() for name in chapter_data.find_all("div", {"class": "chapter"})]
        print("Chapters names obtained!")
        chapters_links = [link.find("a").get("href") for link in chapter_data.find_all("div", {"class": "chapter"})]
        print("Chapters links obtained!")
        chapters_upload_date = [date.text.strip() for date in chapter_data.find_all("div", {"class": "update_time"})]
        print("Chapters uploads date obtained")

    # Adds a dictionary to each chapter
    for chapter_number, chapter_link in enumerate(chapters_links[::-1]):
        manga_data["chapters_data"]["chapter_" + str(chapter_number + 1)] = {
            "name": chapters_name[::-1][chapter_number],
            "link": chapter_link,
            "upload_date": chapters_upload_date[chapter_number]
        }

    return manga_data


def get_chapter_images_links(url):
    """Get all the links from the manga chapter

    Args:
        url (str): URL of manga chapter

    Returns:
        list: List with all the links of the manga chapter

    Example:
        >>> get_chapter_images_links("https://mangakatana.com/manga/attack-on-titan.842/c130")
    """

    print("\nLoading page data...")
    src = requests.get(url, headers=headers)
    print("Data loaded and processed!")

    # Location of the source where the links are stored
    manga_images_links = re.findall(r"var ytaw=\[('.+'),\]", src.text)[0].replace("'", "").split(",")
    print("Images links obtained!")

    return manga_images_links


def download_chapter_images_to_pdf(image_list_url, dir_, name):
    """Downloads all the images from the manga chapter, convert them to a PDF,
    and then delete all the images and keep the PDF.

    Args:
        image_list_url (list): List with all the links of the manga chapter images.
        dir_ (str): Directory where the PDF will be saved.
        name (str): The name of the PDF.

    Example:
        >>> my_list = ["https://i3.mangakatana.com/3Aro%3AosEyYHt%3An6ipA_/1.jpg"]
        >>> download_chapter_images_to_pdf(myList, "/home/nunnito/", "Dr.Stone")

    """

    images_path = []
    os.makedirs(dir_, exist_ok=True)

    # Creates a temporary directory to store the images
    with TemporaryDirectory() as temp_dir:
        for download_image in range(len(image_list_url)):
            image_page = image_list_url[download_image]

            print("Image to download:", image_page)
            downloaded_image = requests.get(image_page, headers=headers).content
            print("Image downloaded!")

            # Path where the images will be saved
            image_path = temp_dir + "/image_" + str(download_image) + "." + \
                image_list_url[download_image].split(".")[-1]

            with open(image_path, "wb") as image:
                image.write(downloaded_image)
                print("Image saved!")

            # Adds the path of the image to the list "images_path" to be later processed by PIL
            images_path.append(image_path)

        # Creates a PDF of the first page of the manga chapter
        image_0 = Image.open(images_path[0]).convert("RGB")
        image_0.save(dir_ + name + ".pdf", save_all_true=True)
        image_0.close()

        print("Creating PDF...")
        # Creates a PDF of the first page of the manga chapter
        for name_image, image in enumerate(images_path):
            if name_image == 0:
                pass
            else:
                name_image = Image.open(image).convert("RGB")
                name_image.save(dir_ + name + ".pdf", savel_all=True, append=True)
                name_image.close()
        print("PDF created at:", dir_ + name + ".pdf")
    print("Temporary directory removed!")


def download_chapter_images(image_list_url, dir_, image_number=""):
    """Downloads all images and save them in a directory

    Args:
        image_list_url (list): List with all the links of the manga chapter images.
        dir_ (str): Directory where the images will be saved
        image_number (int, optional): Custom Image Number (Used for Nunnix Manga)

    Example:
        >>> my_list = ["https://i3.mangakatana.com/3Aro%3AosEyYHt%3An6ipA_/1.jpg"]
        >>> download_chapter_images(myList, "/home/nunnita")
    """

    os.makedirs(dir_, exist_ok=True)

    for download_image in range(len(image_list_url)):
        image_page = image_list_url[download_image]
        print("Image to download:", image_page)

        # Path where the images will be saved
        if image_number == "":
            # Set the image path and add the extension to it.
            image_path = dir_ + "image_" + str(download_image) + "." + image_list_url[download_image].split(".")[-1]
            if os.path.exists(image_path):
                print("The file exists, omitting...")
                break
        else:
            # Set the image path and add the extension to it.
            image_path = dir_ + "image_" + str(image_number) + "." + image_list_url[download_image].split(".")[-1]
            if os.path.exists(image_path):
                print("The file exists, omitting...")
                break

        downloaded_image = requests.get(image_page, headers=headers).content
        print("Image downloaded!")

        with open(image_path, "wb") as image:
            image.write(downloaded_image)
            print("Image saved!")


def get_manga_popular():
    """Get all the manga from the "popular" section

    Returns:
        list: A list containing a dictionary for each manga. 30 items size

    Example:
        >>> get_manga_populars(5)
    """

    page_data = []
    url = "https://mangakatana.com/"

    print("\nLoading page data...")

    src = requests.get(url, headers=headers)

    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    # Popular Slider
    popular_slider = page_source.find("div", id="hot_book")

    # Get manga names
    mangas_names = popular_slider.find_all("h3", {"class": "title"})
    print("Mangas names obtained!")
    # Get manga covers
    mangas_covers = popular_slider.find_all("div", {"class": "wrap_img"})
    print("Mangas covers obtained!")

    # Get manga links
    mangas_links = popular_slider.find_all("h3", {"class": "title"})
    print("Mangas links obtained!")

    # Append all data to a list
    for data in range(len(mangas_names)):
        page_data.append({
            "manga_name": mangas_names[data].text.strip(),
            "manga_cover": mangas_covers[data].find("img").get("data-src"),
            "manga_link": mangas_links[data].find("a").get("href")})
    print("All data added to a list!")

    return page_data


def search_manga(
        sort_by="latest",
        title="",
        category="",
        page="1",
        genres=[],
        exclude_genres=[],
        include_mode="and",
        chapters="1",
        status=""):
    """Search manga by different parameters.

    Args:
        sort_by (str, optional):
            Sort by different methods. Valid options: "az", "numc", "new", "latest".

        title (str, optional): Name of the title to search.
        For it to work, the only parameter set must be itself.

        category (str, optional):
            Category type. Valid options: "seinen", "shoujo", "shounen", "josei".

        page (str, optional): The page number.

        genres (list, optional): Genres name.

        exclude_genres (list, optional): Excludes genres name.

        include_mode (str, optional): Valid options: "and"
        (all selected genres) and "or" (any selected genre).

        chapters (string, optional): Minimum chapters numbers.


        statuts (str, optional): Current manga status.
        Valid options: "0" (cancelled), "1" (ongoing), "2" (completed).


    Returns:
        list: Description


    List of valid genres
    ----------------------
    "4-koma", "action", "adult", "adventure", "artbook", "award-winning", "comedy", "cooking", "doujinshi", "drama",
    "ecchi", "fantasy", "gender-bender", "gore", "harem", "historical", "horror", "isekai", "josei", "loli", "manhua",
    "manhwa", "martial-arts", "mecha", "medical", "music", "mystery", "one-shot", "overpowered-mc", "psychological",
    "reincarnation", "romance", "school-life", "sci-fi", "seinen", "sexual-violence", "shota", "shoujo", "shoujo-ai",
    "shounen", "shounen-ai", "slice-of-life", "smut", "sports", "super-power", "supernatural", "survival",
    "time-travel", "tragedy", "webtoon", "yaoi", "yuri".

    """

    page_data = []

    if title != "":
        url = "https://mangakatana.com/page/{}?search={}".format(page, title)  # Search only the title.
    else:
        url = "https://mangakatana.com/manga/page/{}?".format(page)  # Base URL

    genres = "include=" + "_".join(genres)
    exclude_genres = "exclude=" + "_".join(exclude_genres)

    if category != "" and title == "":
        # Append to base URL
        url += f"filter=1&include={category}&include_mode=and&chapters=1&order=latest"
    if category == "" and title == "":
        # Append to base URL
        url += f"filter=1&order={sort_by}&include_mode={include_mode}\
            &chapters={chapters}&status={status}&{genres}&{exclude_genres}"

    print("\nLink created:", url)

    print("\nLoading page data...")
    src = requests.get(url, headers=headers)
    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    page_manga = page_source.find(id="book_list")

    # Get manga names
    mangas_names = page_manga.find_all("h3", {"class": "title"})
    print("Mangas names obtained!")
    # Get manga covers
    mangas_covers = page_manga.find_all("div", {"class": "wrap_img"})
    print("Mangas covers obtained!")
    # Get manga links
    manga_links = page_manga.find_all("h3", {"class": "title"})
    print("Mangas links obtained!")

    # Append all data to a list
    for data in range(len(mangas_names)):
        page_data.append({
            "manga_name": mangas_names[data].find("a").text.strip(),
            "manga_cover": mangas_covers[data].find("img").get("src"),
            "manga_link": manga_links[data].find("a").get("href")})

    print("All data added to a list!")

    return page_data


def download_and_save_manga_covers(covers_links, manga_links, max_covers=15):
    """Auxiliary function that allows to execute multiple instances of the "download_image_cover" function.

    Args:
        covers_links (list): List of all thumbnails links.
        manga_links (list): List of all manga links.
        max_covers (int, optional): Max number of covers to download.
    """
    pool = ThreadPoolExecutor()
    for number in range(max_covers):
        manga_link = manga_links[number].replace("/", "").replace(":", "")
        cover_link = covers_links[number]

        # Start threads
        pool.submit(download_image_cover, cover_link, manga_link)
        print("Image to download:", cover_link)

    # Wait until all threads are finished.
    pool.shutdown(wait=True)


def download_image_cover(cover_link, manga_link):
    """Downloads the manga thumbnails and stores them in the cache directory.
    The image will be saved with the manga name.

    Args:
        cover_link (str): The thumbnail link to download.
        manga_link (str): the manga link with which the thumbnail will be saved.
    """

    home = str(Path.home())  # Home directory to storage data.

    if sys.platform == "linux":
        cache_dir = home + "/.cache/nunnix-manga/thumbnails/"
    if sys.platform == "win32":
        cache_dir = home + "\\AppData\\Local\\nunnix-manga\\cache\\"

    # If the images exists in the system, skip it.
    if os.path.exists(cache_dir + manga_link + ".jpg"):
        print("The file exists, omitting...")
    # Otherwise, download it.
    else:
        downloaded_image = requests.get(cover_link, timeout=10, headers=headers).content  # Image to write.

        # If the OS is Linux
        if sys.platform == "linux":
            if not os.path.exists(home + "/.cache/nunnix-manga"):
                os.mkdir(home + "/.cache/nunnix-manga")
                os.mkdir(home + "/.cache/nunnix-manga/thumbnails")

        # If the OS is Windows
        if sys.platform == "win32":
            if not os.path.exists(home + "\\AppData\\Local\\nunnix-manga\\cache"):
                os.system("mkdir {}".format(home + "\\AppData\\Local\\nunnix-manga\\"))
                os.system("mkdir {}".format(home + "\\AppData\\Local\\nunnix-manga\\cache\\"))

        # Try to download the image
        with open(cache_dir + manga_link + ".jpg", "wb") as save_image:
            save_image.write(downloaded_image)
            print("Image saved:", cover_link)


if __name__ == "__main__":
    print(search_manga(title="re:zero"))
