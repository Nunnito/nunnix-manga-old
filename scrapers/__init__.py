from os import listdir
import re

scrapers = listdir(re.sub(r"__init__.py.?$", "", __file__))
scrapers_list = []


__all__ = re.findall(r"\b(.+)(?<!__)\.py(?!\w)\b", "\n".join(scrapers))
