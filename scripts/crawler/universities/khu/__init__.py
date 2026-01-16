"""
경희대학교 (Kyung Hee University) crawler.
"""
from .config import UNIVERSITY_ID, UNIVERSITY_CODE, UNIVERSITY_NAME
from .crawler import KHUCrawler
from .parser import KHUParser

__all__ = ['UNIVERSITY_ID', 'UNIVERSITY_CODE', 'UNIVERSITY_NAME', 'KHUCrawler', 'KHUParser']
