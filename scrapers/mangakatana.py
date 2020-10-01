from requests.exceptions import ConnectionError, ReadTimeout
from bs4 import BeautifulSoup
import requests
import re

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64)',
    'Referer': "http://mangakatana.com/"}


def get_source(url):
    try:
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
        >>> get_manga_data("http://mangakatana.com/manga/solo-leveling.21708")

    Dictionary content
    ------------------
    manga_data = {
                "title": "",
                "author": "",
                "description": "",
                "thumbnail": "",
                "genres": [],
                "total_chapters": "",
                "current_state": "",
                "chapters_data": {
                        "chapter_1": {
                                "name": "Chapter 1",
                                "link": "http://mangakatana.com/manga/leveling/1",
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
    data = {
        "title": "",
        "author": "",
        "description": "",
        "thumbnail": "",
        "genres": [],
        "total_chapters": "",
        "current_state": "",
        "chapters": {
        }
    }

    # Manga title
    title = parsed_source.find("h1", {"class": "heading"})
    title = title.text.strip()
    data["title"] = title

    # Manga author
    author = parsed_source.find("a", {"class": "author"})
    author = author.text.strip()
    data["author"] = author

    # Manga description
    description = parsed_source.find("div", {"class": "summary"})
    description = description.text.strip()
    data["description"] = description

    # Manga thumbnail
    thumbnail = parsed_source.find("img", {"alt": "[Cover]"})
    thumbnail = thumbnail.get("src")
    data["thumbnail"] = thumbnail

    # Manga genres
    genres = parsed_source.find("div", {"class": "genres"}).find_all("a")
    genres = [genre.text.strip() for genre in genres]
    data["genres"] = genres

    # Manga total chapters
    total_chapters = parsed_source.find("div", {"class": "uk-width-medium-1-4"})
    total_chapters = re.search(r"\d+", total_chapters.text).group()
    data["total_chapters"] = total_chapters

    # Manga current state
    current_state = parsed_source.find("div", {"class": "status"})
    current_state = current_state.text.strip()
    data["current_state"] = current_state

    # Manga chapters data
    chapters = parsed_source.find("div", {"class": "chapters"}).find_all("tr")

    chapters_name = []
    chapters_upload_date = []
    chapters_links = []

    for chapter in chapters:
        # Chapter name
        name = chapter.find("div", {"class": "chapter"}).text.strip()
        chapters_name.append(name)

        # Chapter upload date
        upload_date = chapter.find("div", {"class": "update_time"}).text.strip()
        chapters_upload_date.append(upload_date)

        # Chapter link
        link = chapter.find("div", {"class": "chapter"}).find("a").get("href")
        chapters_links.append(link)

    # Adds a dictionary to each chapter
    for chapter_number, chapter_link in enumerate(chapters_links[::-1]):
        data["chapters"]["chapter_" + str(chapter_number + 1)] = {
            "name": chapters_name[::-1][chapter_number],
            "upload_date": chapters_upload_date[::-1][chapter_number],
            "link": chapters_links[::-1][chapter_number]
        }

    return data


def get_chapters_images(url):
    """Get all the links from the manga chapter

    Args:
        url (str): URL of the redirected page of the manga chapter

    Returns:
        list: List with all the links of the manga chapter

    Example:
        >>> get_chapter_images_links("http://mangakatana.com/manga/leveling/1")
    """

    parsed_source = get_source(url)

    if type(parsed_source) != BeautifulSoup:
        return parsed_source

    links = re.findall(r"var ytaw=\[('.+'),\]", str(parsed_source))[0]
    links = links.replace("'", "").split(",")

    return links


def search_manga(
    title="",
    sort_by="latest",
    include_mode="and",
    status="",
    chapters=1,
    genres=[],
    exclude_genres=[],
    page=1
):
    """Search manga by different parameters.

    Args:
        title (str, optional):
                Name of the title to search.
                To work, it must be the only parameter.

        sort_by (str, optional):
                Sort by different methods. Valid options:
                "az", "numc", "new", "latest".

        include_mode (str, optional):
                Valid options: "and" (all selected genres)
                and "or" (any selected genre).

        status (str, optional):
                Current manga status. Valid options:
                "0" (cancelled), "1" (ongoing), "2" (completed).

        chapters (string, optional): Minimum chapters numbers.

        genres (list, optional): Genres name.

        exclude_genres (list, optional): Excludes genres name.

        page (int, optional): The page number.


    Returns:
        list: Manga data


    List of valid genres
    ----------------------
    "4-koma", "action", "adult", "adventure", "artbook", "award-winning", "yuri"
    "comedy", "cooking", "smut", "drama", "ecchi", "yaoi", "shota", "fantasy"
    "gender-bender", "gore", "harem", "historical", "horror", "isekai", "josei",
    "loli", "manhua", "manhwa", "martial-arts", "mecha", "medical", "webtoon",
    "doujinshi", "one-shot", "overpowered-mc", "psychological", "reincarnation",
    "romance", "school-life", "sci-fi", "seinen", "sexual-violence", "tragedy",
    "shoujo", "shoujo-ai", "shounen", "shounen-ai", "slice-of-life", "mystery",
    "sports", "super-power", "supernatural", "survival", "time-travel", "music".
    """

    search_data = []

    if title != "":
        # Search only the title.
        url = "https://mangakatana.com/page/{}?search={}".format(page, title)
    else:
        url = "https://mangakatana.com/manga/page/{}?".format(page)  # Base URL

    genres = "include=" + "_".join(genres)
    exclude_genres = "exclude=" + "_".join(exclude_genres)

    # Append to base URL
    if title == "":
        url += f"filter=1&order={sort_by}&include_mode={include_mode}"
        url += f"&chapters={chapters}&status={status}&{genres}&{exclude_genres}"

    print("\nLink created:", url)

    parsed_source = get_source(url)
    if type(parsed_source) != BeautifulSoup:
        return parsed_source

    # If there is only a single result
    if not parsed_source.find(id="book_list"):
        # Manga title
        title = parsed_source.find("h1", {"class": "heading"})
        title = title.text.strip()

        # Manga thumbnail
        thumbnail = parsed_source.find("img", {"alt": "[Cover]"})
        thumbnail = thumbnail.get("src")

        # Manga link
        link = parsed_source.find("meta", {"property": "og:url"})
        link = link.get("content")

        search_data.append(
            {
                "title": title,
                "link": link,
                "thumbnail": thumbnail
            }
        )

        return search_data

    parsed_source = parsed_source.find(id="book_list")

    # Manga title
    titles = parsed_source.find_all("h3", {"class": "title"})

    # Manga thumbnail
    thumbnails = parsed_source.find_all("img", {"alt": "[Cover]"})

    # Manga link
    links = parsed_source.find_all("h3", {"class": "title"})

    for data in range(len(titles)):
        search_data.append(
            {
                "title": titles[data].find("a").text.strip(),
                "link": links[data].find("a").get("href"),
                "thumbnail": thumbnails[data].get("src")
            }
        )

    if search_data == []:
        error = "HTTP error 404"
        return error
    else:
        return search_data


def get_search_controls():
    controls = open(__file__.replace(".py", ".json"), "r")
    read_controls = controls.read()
    controls.close()

    return read_controls
