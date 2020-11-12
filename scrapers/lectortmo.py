from requests.exceptions import ConnectionError, ReadTimeout
from bs4 import BeautifulSoup
import requests
import re

name = "LectorTMO"
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)',
    'Referer': "https://lectortmo.com/"}


def get_source(url, image_mode=False):
    try:
        if image_mode:
            url = requests.head(url, headers=HEADERS, timeout=30).headers["Location"]
            chapter_id = re.search(r"\w+/\w+/(\w+)", url).groups()[0]
            url = f"https://lectortmo.com/viewer/{chapter_id}/cascade"

        print("\nLoading page data...")
        src = requests.get(url, headers=HEADERS, timeout=30)

        if src.status_code == 200:
            parsed_source = BeautifulSoup(src.content, "lxml")
            print("Data loaded and processed!")
        else:
            error = f"HTTP error {src.status_code}"
            print(error)
            return error

        return parsed_source

    except (ConnectionError, ReadTimeout) as error:
        print(error)
        return error


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
                "author": "",
                "description": "",
                "thumbnail": "",
                "genres": [],
                "total_chapters": "",
                "current_status": "",
                "chapters_data": {
                        "chapter_1": {
                                "name": "Chapter 1",
                                "link": "https://lectortmo.com/view_uploads/73",
                                "upload_date": "3/1/19"
                                "fansub": "NekoCreme"
                        }
                }
    }
    """

    parsed_source = get_source(url)

    if type(parsed_source) != BeautifulSoup:
        return parsed_source

    # Dictionary where all manga data will be stored
    one_shot = False
    data = {
        "title": "",
        "author": "",
        "description": "",
        "thumbnail": "",
        "genres": [],
        "total_chapters": "",
        "current_status": "",
        "chapters": {
        }
    }

    # Manga title
    title = parsed_source.find("h2", {"class": "element-subtitle"})
    title = title.text.strip()
    data["title"] = title

    # Manga description
    description = parsed_source.find("p", {"class": "element-description"})
    description = description.text.strip()
    data["description"] = description

    # Manga thumbnail
    thumbnail = parsed_source.find("img", {"class": "book-thumbnail"})
    thumbnail = thumbnail.get("src")
    data["thumbnail"] = thumbnail

    # Manga genres
    genres = parsed_source.find_all("h6", {"style": "display: inline-block;"})
    genres = [genre.text.strip() for genre in genres]
    data["genres"] = genres

    # Manga total chapters
    total_chapters = parsed_source.find_all("li", {"class": "upload-link"})
    total_chapters = len(total_chapters)
    data["total_chapters"] = total_chapters

    # Manga author
    try:
        author = parsed_source.find("h5", {"class": "card-title text-truncate"})
        author = author.text.replace(",", "").strip().title()
        data["author"] = author
    except AttributeError:
        author = "n/a"
        data["author"] = author

    # Manga current status
    try:
        current_status = parsed_source.find("span", {"class": "book-status"})
        current_status = current_status.text.strip()
        data["current_status"] = current_status
    except AttributeError:
        one_shot = True
        current_status = "One shot"
        data["current_status"] = current_status

    # Manga chapters data
    chapters = parsed_source.find_all("li", {"class": "upload-link"})

    chapters_name = []
    chapters_upload_date = []
    chapters_links = []

    for chapter in chapters:
        # Chapter name
        if one_shot:
            name = "One shot"
        else:
            name = chapter.find("a", {"class": "btn-collapse"}).text.strip()
        chapters_name.append(name)

        # Chapter upload date
        upload_date = chapter.find("span", {"class": "badge"}).text.strip()
        chapters_upload_date.append(upload_date)

        # Chapter link
        link = chapter.find("a", {"class": "btn"}).get("href")
        chapters_links.append(link)

    # Adds a dictionary to each chapter
    for chapter_number, chapter_link in enumerate(chapters_links):
        data["chapters"]["chapter_" + str(chapter_number)] = {
            "name": chapters_name[chapter_number],
            "upload_date": chapters_upload_date[chapter_number],
            "link": chapters_links[chapter_number]
        }

    return data


def get_chapters_images(url):
    """Get all the links from the manga chapter

    Args:
        url (str): URL of the redirected page of the manga chapter

    Returns:
        list: List with all the links of the manga chapter

    Example:
        >>> get_chapter_images_links("https://lectortmo.com/viewer/c6d/cascade")
    """

    parsed_source = get_source(url, True)

    if type(parsed_source) != BeautifulSoup:
        return parsed_source

    links = parsed_source.find_all("div", {"class": "img-container"})
    links = [link.find("img").get("data-src") for link in links]

    return links


def search_manga(
    title="",
    filter_by="",
    sort_by="likes_count",
    order_dir="desc",
    _type="",
    demography="",
    webcomic="",
    yonkoma="",
    amateur="",
    erotic="",
    genres=[],
    exclude_genres=[],
    page=1
):
    """Search manga by different parameters.

    Args:
        title (str, optional): Name of the title to search.

        filter_by (str, optional):
                Search by different methods. Valid options:
                "title", "author", "company".

        sort_by (str, optional):
                Sort by different methods. Valid options: "likes_count", "score",
                "num_chapters", "alphabetically", "creation", "release_date".

        order_dir (str, optional):
                Order ascending or descending. Valid options:
                "asc", "desc".

        _type (str, optional):
                Type of content. Valid options: "manga", "manhua", "manhwa",
                "novel", "one_shot", "doujinshi", "oel".

        demography (str, optional):
                Category type. Valid options: "seinen", "shoujo", "shounen",
                "josei", "kodomo".

        webcomic (bool, optional):
                Show only webcomic content, or don't show webcomic content.
                If not specified, the webcomic content will be combined with the others.
                Valid options: "True", "False".

        yonkoma (bool, optional):
                Show only yonkoma content, or don't show yonkoma content.
                If not specified, the yonkoma content will be combined with the others.
                Valid options: "True", "False".

        amateur (bool, options):
                Show only amateur content, or don't show amateur content.
                If not specified, the amateur content will be combined with the others.
                Valid options: "True", "False".

        erotic (bool, optional):
                Show only erotic content, or don't show erotic content.
                If not specified, the erotic content will be combined with the others.
                Valid options: "True", "False".

        genres (list, optional): Genres id.

        exclude_genres (list, optional): Excludes genres id.

        page (int, optional): The page number.


    Returns:
        list: Manga data


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

    search_data = []

    url = "https://lectortmo.com/library?_page=1&"  # Base URL

    if genres == [] and exclude_genres == []:
        # Append to base URL
        url += f"order_item={sort_by}&title={title}&filter_by={filter_by}"
        url += f"&type={_type}&demography={demography}&erotic={erotic}"
        url += f"&page={page}&order_dir={order_dir}&webcomic={webcomic}"
        url += f"&yonkoma={yonkoma}&amateur={amateur}"
    else:
        genres = [f"&genders[]={genre}" for genre in genres]
        exclude_genres = [f"&exclude_genders[]={exclude}" for exclude in exclude_genres]
        genres = "".join(genres)
        exclude_genres = "".join(exclude_genres)

        # Append to base URL
        url += f"order_item={sort_by}&title={title}&filter_by={filter_by}"
        url += f"&type={_type}&demography={demography}&erotic={erotic}"
        url += f"&page={page}&order_dir={order_dir}&webcomic={webcomic}"
        url += f"&yonkoma={yonkoma}&amateur={amateur}"
        url += f"{genres}{exclude_genres}"

    print("\nLink created:", url)

    parsed_source = get_source(url)
    if type(parsed_source) != BeautifulSoup:
        return parsed_source

    # Manga title
    titles = parsed_source.find_all("div", {"class": "thumbnail-title"})

    # Manga thumbnail
    thumbnails = parsed_source.find_all("div", {"class": "thumbnail"})
    thumbnails_regex = re.compile(r"https?.*\.(png|jpg|jpeg|webp)")

    # Manga link
    links = parsed_source.find_all("div", {"class": "element"})

    for data in range(len(titles)):
        search_data.append(
            {
                "title": titles[data].text.strip(),
                "link": links[data].find("a").get("href"),
                "thumbnail": re.search(thumbnails_regex, str(thumbnails[data])).group()
            }
        )

    if search_data == []:
        error = "HTTP error 404"
        return error
    else:
        return search_data


def get_search_controls():
    with open(__file__.replace(".py", ".json")) as controls:
        read_controls = controls.read()

    return read_controls
