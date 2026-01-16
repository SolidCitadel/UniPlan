"""
경희대학교 수강신청 시스템 설정
Kyung Hee University course registration system configuration.
"""

# University info (must match catalog-service database)
UNIVERSITY_ID = 1
UNIVERSITY_CODE = "KHU"
UNIVERSITY_NAME = "경희대학교"

# API URLs
BASE_URL = "https://sugang.khu.ac.kr/core"
DATA_JS_URL = "https://sugang.khu.ac.kr/resources/data/data_{year}.js"

# Required referer (without this, requests return 404)
LOGIN_REFERER = "https://sugang.khu.ac.kr/login?attribute=loginMain&lang=ko&loginYn=N&schedule_cd=hakbu"

# Semester code mappings
# API parameter (p_term)
SEMESTER_CODES = {
    1: "10",      # 1학기
    2: "20",      # 2학기
    "summer": "15",
    "winter": "25",
}

# data.js variable suffix (e.g., major_202510 for 2025년 1학기)
DATA_JS_SEMESTER_CODES = {
    1: "10",
    2: "20",
    "summer": "15",
    "winter": "25",
}


def get_semester_code_full(year: int, semester: int) -> str:
    """
    Convert year and semester to YYYYMM code for data.js variable names.
    Example: 2025, 1 -> "202510"
    """
    semester_suffix = DATA_JS_SEMESTER_CODES.get(semester, "10")
    return f"{year}{semester_suffix}"


# Campus codes
CAMPUS_CODES = {
    "서울": "1",
    "국제": "2",
}

# HTTP headers
DEFAULT_HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
    'X-Requested-With': 'XMLHttpRequest',
}

# Request settings
REQUEST_TIMEOUT = 30
MAX_RETRIES = 3
RETRY_DELAY = 2
