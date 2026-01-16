"""
경희대학교 수강신청 시스템 크롤러
KHU Course Registration System Crawler
"""
import time
import requests
from typing import Dict, List, Optional

from .config import (
    BASE_URL,
    DATA_JS_URL,
    LOGIN_REFERER,
    DEFAULT_HEADERS,
    SEMESTER_CODES,
    REQUEST_TIMEOUT,
    MAX_RETRIES,
    RETRY_DELAY,
    get_semester_code_full,
)


class KHUCrawler:
    """경희대 수강신청 시스템 크롤러"""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update(DEFAULT_HEADERS)

    def _generate_timestamp(self) -> str:
        """Generate timestamp for cache busting."""
        return str(int(time.time() * 1000))

    def _build_params(
        self,
        year: int,
        semester: int,
        major_code: Optional[str] = None,
        professor: Optional[str] = None,
        subject: Optional[str] = None,
        day: Optional[str] = None,
        time_slot: Optional[str] = None
    ) -> Dict:
        """Build API request parameters."""
        semester_code = SEMESTER_CODES.get(semester, "10")

        params = {
            'attribute': 'lectListJson',
            'lang': 'ko',
            'loginYn': 'N',
            'fake': self._generate_timestamp(),
            'menu': '1',
            'search_div': 'E',
            'p_day': day or '',
            'p_time': time_slot or '',
            'p_teach': professor or '',
            'p_subjt': subject or '',
            'p_major': major_code or '',
            'p_lang': '',
            'p_year': str(year),
            'p_term': semester_code,
            'lecture_cd': '',
            'initYn': 'Y',
            '_search': 'false',
            'nd': self._generate_timestamp(),
            'rows': '-1',  # -1 = all data
            'page': '1',
            'sidx': '',
            'sord': 'asc'
        }

        return params

    def fetch_courses(
        self,
        year: int,
        semester: int,
        **filters
    ) -> Optional[Dict]:
        """
        Fetch course data from API.

        Args:
            year: Year (e.g., 2025)
            semester: Semester (1 or 2)
            **filters: Additional filters (major_code, professor, subject, etc.)

        Returns:
            JSON response or None on failure
        """
        params = self._build_params(year, semester, **filters)

        headers = {
            'Referer': LOGIN_REFERER + f"&fake={self._generate_timestamp()}"
        }

        for attempt in range(MAX_RETRIES):
            try:
                response = self.session.get(
                    BASE_URL,
                    params=params,
                    headers=headers,
                    timeout=REQUEST_TIMEOUT
                )
                response.raise_for_status()

                data = response.json()

                if 'rows' in data:
                    return data
                else:
                    return data

            except requests.exceptions.Timeout:
                if attempt < MAX_RETRIES - 1:
                    time.sleep(RETRY_DELAY)

            except requests.exceptions.HTTPError as e:
                print(f"HTTP Error: {e.response.status_code}")
                return None

            except requests.exceptions.RequestException as e:
                if attempt < MAX_RETRIES - 1:
                    time.sleep(RETRY_DELAY)

            except ValueError:
                return None

        return None

    def fetch_data_js(self, year: int) -> Optional[str]:
        """
        Fetch data_YYYY.js metadata file.

        Args:
            year: Year (e.g., 2025)

        Returns:
            JavaScript file content or None
        """
        url = DATA_JS_URL.format(year=year)

        try:
            response = requests.get(url, timeout=REQUEST_TIMEOUT)
            response.raise_for_status()
            return response.text
        except requests.exceptions.RequestException as e:
            print(f"Failed to fetch data.js: {str(e)}")
            return None

    def close(self):
        """Close the session."""
        self.session.close()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
