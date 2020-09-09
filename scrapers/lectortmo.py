from requests.exceptions import ConnectionError, ReadTimeout
from tempfile import TemporaryDirectory
from bs4 import BeautifulSoup
from pathlib import Path
from PIL import Image
import threading
import requests
import sys
import os
import re

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)',
    'Referer': "https://lectortmo.com/"}


def get_manga_data(url):
    """Gets all the necessary data from the manga and return a dictionary

    Args:
        url (str): The manga page url.

    Returns:
        dict: Dictionary with all the necessary data from the manga

    Example:
        >>> get_manga_data("https://lectortmo.com/library/manga/23741/Dr-Stone")

    Dictionary content
    ------------------
    manga_data = {
                "title": "",
                "current_state": "",
                "author": "",
                "artist": "",
                "genres": [],
                "description": "",
                "cover": "",
                "total_chapters": "",
                "chapters_data": {
                        "chapter_1": {
                                "name": "Chapter 1",
                                "link": "https://lectortmo.com/view_uploads/237473",
                                "upload_date": "3/1/19"
                                "fansub": "NekoCreme"
                        }
                }
    }
    """

    print("\nLoading page data...")

    while True:
        try:
            src = requests.get(url, headers=headers, timeout=5)  # Get page source
            break
        except(ReadTimeout, ConnectionError):
            pass
    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    # Dictionary where all manga data will be stored
    manga_data = {
        "title": "",
        "current_state": "",
        "author": "",
        "artist": "",
        "genres": [],
        "description": "",
        "cover": "",
        "total_chapters": "",
        "chapters_data": {}
    }

    # Manga title
    manga_data["title"] = page_source.find("h2", {"class": "element-subtitle"}).text.strip().replace("\n", "")
    print("Title obtained!")

    # Manga status
    try:
        manga_data["current_state"] = page_source.find("span", {"class": "book-status publishing"}).text

        if manga_data["current_state"] == "Publicándose":
            manga_data["current_state"] = "En emisión"

    except AttributeError:
        manga_data["current_state"] = "One shot"
    print("Manga status obtained!")

    # Manga author
    try:
        manga_data["author"] = page_source.find(
            "h5", {"class": "card-title text-truncate"}).text.replace(",", "").title().strip()
    except AttributeError:
        manga_data["author"] = "n/a"
    print("Manga author obtained!")

    # Manga artist
    try:
        manga_data["artist"] = page_source.find_all(
            "h5", {"class": "card-title text-truncate"})[1].text.replace(",", "").title().strip()
    except AttributeError:
        manga_data["artist"] = "n/a"
    except IndexError:
        manga_data["artist"] = "n/a"
    print("Manga artist obtained")

    # Manga genres
    genres = page_source.find_all("a", {"class": "badge badge-primary py-2 px-4 mx-1 my-2"})
    manga_data["genres"] = [genre.text for genre in genres]
    print("Manga genres obtained")

    # Manga description
    manga_data["description"] = page_source.find("p", {"class": "element-description"}).text
    print("Manga description obtained!")

    # Manga cover
    manga_data["cover"] = page_source.find("img", {"class": "book-thumbnail"}).get("src")
    print("Manga cover obtained!")

    # Manga total chapters
    try:
        manga_data["total_chapters"] = len(page_source.find(id="chapters").find_all("h4", {"class": "px-2 py-3 m-0"}))
    except AttributeError:
        manga_data["total_chapters"] = 1
    print("Total chapters obtained!")

    # Manga chapters links
    chapters_data = page_source.find_all("li", {"class": "list-group-item p-0 bg-light upload-link"})

    chapters_name = []
    chapters_links = []
    chapters_upload_date = []
    chapters_fansub = []

    if len(chapters_data) == 0:
        chapters_name.append("Capítulo 1")
        chapters_links.append(page_source.find("li", {"class": "list-group-item upload-link"}).find("a").get("href"))
        chapters_upload_date.append(page_source.find("span", {"class": "badge badge-primary p-2"}).text.strip())
        chapters_fansub.append(page_source.find("div", {"class": "col-4 col-md-6 text-truncate"}).text.strip())

    else:
        for chapter_data in chapters_data:
            chapters_name.append(chapter_data.find("div", {"class": "col-10 text-truncate"}).text.strip())
            print("Chapters names obtained!")
            chapters_links.append(chapter_data.find("a", {"class": "btn btn-default btn-sm"}).get("href"))
            print("Chapters links obtained!")
            chapters_upload_date.append(chapter_data.find("span", {"class": "badge badge-primary p-2"}).text.strip())
            print("Chapters uploads date obtained")
            chapters_fansub.append(chapter_data.find_all(
                "div", {"class": "card chapter-list-element"})[0].find("div", {"class": "text-truncate"}).text.strip())
            print("Chapters fansubs obtained")

    # Adds a dictionary to each chapter
    for chapter_number, chapter_link in enumerate(chapters_links[::-1]):
        manga_data["chapters_data"]["chapter_" + str(chapter_number + 1)] = {
            "name": chapters_name[::-1][chapter_number],
            "link": get_chapter_link(chapter_link),
            "upload_date": chapters_upload_date[chapter_number],
            "fansub": chapters_fansub[chapter_number]
        }

    return manga_data


def get_chapter_link(url):
    """Gets the redirected link from the manga chapter

    Args:
        url (str): URL to redirect to manga chapter

    Returns:
        str: URL redirected to manga chapter

    Example:
        >>> get_chapter_link("https://lectortmo.com/view_uploads/501182")
    """

    print("\nDownloading headers...")
    manga_link = requests.head(url, headers=headers)
    print("Headers downloaded!")

    return manga_link.headers["Location"].replace("paginated", "cascade")


def get_chapter_images_links(url):
    """Get all the links from the manga chapter

    Args:
        url (str): URL of the redirected page of the manga chapter

    Returns:
        list: List with all the links of the manga chapter

    Example:
        >>> get_chapter_images_links("https://lectortmo.com/viewer/5e935e2184c6d/cascade")
    """

    manga_images_links = []

    print("\nLoading page data...")
    src = requests.get(url, headers=headers)
    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    images_links = page_source.find_all("div", {"class": "img-container text-center"})
    print("Images links obtained!")
    # Gets all the image links
    manga_images_links = [manga_image_link.find("img").get("data-src") for manga_image_link in images_links]

    return manga_images_links


def download_chapter_images_to_pdf(image_list_url, dir_, name):
    """Downloads all the images from the manga chapter, convert them to a PDF,
    and then delete all the images and keep the PDF.

    Args:
        image_list_url (list): List with all the links of the manga chapter images.
        dir_ (str): Directory where the PDF will be saved.
        name (str): The name of the PDF.

    Example:
        >>> my_list = ["https://sv.lectormanhwa.com/uploads/5e935e2184c6d/a58b147f.jpg"]
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
        >>> my_list = ["https://sv.lectormanhwa.com/uploads/5e935e2184c6d/a58b147f.jpg"]
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


def get_manga_popular(page=1):
    """Get all the manga from the "popular" section

    Args:
        page (int, optional): Number of the page, 1-6

    Returns:
        list: A list containing a dictionary for each manga. 30 items size

    Example:
        >>> get_manga_popular(5)
    """

    page_data = []
    url = "https://lectortmo.com/populars?page={}".format(page)

    print("\nLoading page data...")

    src = requests.get(url, headers=headers)

    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    # Get manga names
    mangas_names = page_source.find_all("div", {"class": "thumbnail-title"})
    print("Mangas names obtained!")
    # Get manga covers
    mangas_covers = page_source.find_all("div", {"class": ["thumbnail", "book"]})
    print("Mangas covers obtained!")
    # Get manga links
    manga_links = page_source.find_all("div", {"class": "element"})
    print("Mangas links obtained!")

    # Append all data to a list
    for data in range(len(mangas_names)):
        page_data.append({
            "manga_name": mangas_names[data].text.strip(),
            "manga_cover": str(mangas_covers[data].find("style")).split("url(")[1].split(")")[0].replace("'", ""),
            "manga_link": manga_links[data].find("a").get("href")})
    print("All data added to a list!")

    return page_data


def search_manga(
        sort_by="likes_count",
        title="",
        type="",
        category="",
        erotic="",
        page="1",
        genres_id=[],
        exclude_genres_id=[],
        order_dir="desc",
        webcomic="",
        yonkoma="",
        amateur=""):
    """Search manga by different parameters.

    Args:
        sort_by (str, optional):
                Sort by different methods. Valid options: "likes_count", "score", "num_chapters".

        title (str, optional): Name of the title to search.

        type (str, optional):
                Type of content. Valid options: "manga", "manhua", "manhwa", "novel", "one_shot", "doujinshi".

        category (str, optional):
                Category type. Valid options: "seinen", "shoujo", "shounen", "josei", "kodomo".

        erotic (str, optional):
                Show only erotic content, or don't show erotic content.
                If not specified, the erotic content will be combined with the others.
                Valid options: "true", "false".

        page (str, optional): The page number.

        genre_id (list, optional): Genre id.

        exclude_genres_id (bool, optional): Excludes genres name.

        order_dir (str, optional): Order ascending or descending. Valid options: "asc", "desc".

        webcomic (str, optional):
                Show only webcomic content, or don't show webcomic content.
                If not specified, the webcomic content will be combined with the others.
                Valid options: "true", "false".

        yonkoma (str, optional):
                Show only yonkoma content, or don't show yonkoma content.
                If not specified, the yonkoma content will be combined with the others.
                Valid options: "true", "false".

        amateur (str, options):
                        Show only amateur content, or don't show amateur content.
                If not specified, the amateur content will be combined with the others.
                Valid options: "true", "false".



    Returns:
        list: Description


    List of ID's by genres
    ----------------------
    1=Acción, 2=Aventura, 3=Comedia, 4=Drama,

    5=Recuentos de la vida, 6=Ecchi, 7=Fantasia, 8=Magia, 9=Sobrenatural,

    10=Horror, 11=Misterio, 12=Psicológico, 13=Romance, 14=Ciencia Ficción,

    15=Thriller,16=Deporte, 17=Girls Love, 18=Boys Love, 19=Harem,

    20=Mecha, 21=Supervivencia, 22=Reencarnación, 23=Gore, 24=Apocalíptico,

    25=Tragedia, 26=Vida Escolar, 27=Historia, 28=Militar, 29=Policiaco,

    30=Crimen, 31=Superpoderes, 32=Vampiros, 33=Artes Marciales, 34=Samurái,

    35=Género Bender, 36=Realidad Virtual, 37=Ciberpunk, 38=Musica, 39=Parodia,

    40=Animación, 41=Demonios, 42=Familia, 43=Extranjero, 44=Niños,

    45=Realidad, 46=Telenovela, 47=Guerra, 48=Oeste

    """

    page_data = []

    url = "https://lectortmo.com/library?_page=1&"  # Base URL
    if genres_id == [] and exclude_genres_id == []:
        # Append to base URL
        url += f"order_item={sort_by}&title={title}&type={type}&demography={category}&erotic={erotic}\
            &page={page}&order_dir={order_dir}&webcomic={webcomic}&yonkoma={yonkoma}&amateur={amateur}"
    else:
        genres = "".join(["&genders[]=" + genre for genre in genres_id])
        ex_genres = "".join(["&exclude_genders[]=" + genre for genre in exclude_genres_id])

        # Append to base URL
        url += f"order_item={sort_by}&title={title}&type={type}&demography={category}&erotic={erotic}\
        &page={page}&order_dir={order_dir}&webcomic={webcomic}&yonkoma={yonkoma}&amateur={amateur}{genres}{ex_genres}"

    print("\nLink created:", url)

    print("\nLoading page data...")
    src = requests.get(url, headers=headers)
    page_source = BeautifulSoup(src.content, "lxml")
    print("Data loaded and processed!")

    # Get manga names
    mangas_names = page_source.find_all("div", {"class": "thumbnail-title"})
    print("Mangas names obtained!")
    # Get manga covers
    mangas_covers = page_source.find_all("div", {"class": ["thumbnail", "book"]})
    print("Mangas covers obtained!")
    # Get manga links
    manga_links = page_source.find_all("div", {"class": "element"})
    print("Mangas links obtained!")

    # Append all data to a list
    for data in range(len(mangas_names)):
        page_data.append({
            "manga_name": mangas_names[data].text.strip(),
            "manga_cover": re.search(r"http.*.jpg", str(mangas_covers[data].find("style"))).group(),
            "manga_link": manga_links[data].find("a").get("href")})

    print("All data added to a list!")

    return page_data


def download_and_save_manga_covers(covers_links, manga_links, max_covers=15, threads=5):
    """Auxiliary function that allows to execute multiple instances of the "download_image_cover" function.

    Args:
        covers_links (list): List of all thumbnails links.
        manga (list): List of all manga links.
        threads (int, optional): Threads to run at the same time.
        max_covers (int, optional): Max number of covers to download.
    """
    max_threads = threads
    for number in range(len(manga_links)):
        manga_link = manga_links[number].replace("/", "").replace(":", "")
        cover_link = covers_links[number]

        # Start threads
        download_thread = threading.Thread(target=download_image_cover, args=[cover_link, manga_link])
        download_thread.start()

        # If "number" equals "max_threads", wait until the current threads have finished
        if number == max_threads:
            download_thread.join()
            max_threads += threads - 1
        print("Image to download:", cover_link)

        if number == max_covers - 1:
            break


def download_image_cover(cover_link, manga_link):
    """Downloads the manga thumbnails and stores them in the cache directory.
    The image will be saved with the manga name.

    Args:
        cover_link (str): The thumbnail link to download.
        manga_link (str): the manga link with which the thumbnail will be saved.
    """

    home = str(Path.home())  # Home directory to storage data.
    manga_link

    if sys.platform == "linux":
        cache_dir = home + "/.cache/nunnix-manga/thumbnails/"
    if sys.platform == "win32":
        cache_dir = home + "\\AppData\\Local\\nunnix-manga\\cache\\"

    # If the image exists in the system, skip it.
    if os.path.exists(cache_dir + manga_link + ".jpg"):
        print("The file exists, omitting...")
    # Otherwise, download it.
    else:
        downloaded_image = requests.get(
            cover_link, timeout=10, headers=headers).content

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
    print(get_chapter_link("https://lectortmo.com/view_uploads/594335"))
