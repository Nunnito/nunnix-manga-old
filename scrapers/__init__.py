from os import listdir
import re

scrapers = listdir("scrapers/")
scrapers_list = []


__all__ = re.findall(r"\b(.+)(?<!__)\.py(?!\w)\b", "\n".join(scrapers))
