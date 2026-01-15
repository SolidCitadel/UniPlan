"""
경희대 수강신청 시스템 설정
"""

# 대학 정보
UNIVERSITY_ID = 1  # catalog-service의 University 테이블 ID
UNIVERSITY_CODE = "KHU"
UNIVERSITY_NAME = "경희대학교"

# API 기본 URL
BASE_URL = "https://sugang.khu.ac.kr/core"
DATA_JS_URL = "https://sugang.khu.ac.kr/resources/data/data_{year}.js"

# Referer URL (필수! 이게 없으면 404 에러)
LOGIN_REFERER = "https://sugang.khu.ac.kr/login?attribute=loginMain&lang=ko&loginYn=N&schedule_cd=hakbu"

# 학기 코드 매핑
# 주의: API 파라미터(p_term)와 data.js 변수명의 코드가 다릅니다!

# API 파라미터 (p_term)용
SEMESTER_CODES = {
    1: "10",  # 1학기 → p_term="10"
    2: "20",  # 2학기 → p_term="20"
    "summer": "15",  # 여름학기 → p_term="15"
    "winter": "25",  # 겨울학기 → p_term="25"
}

# data.js 변수명 (major_YYYYMM)용
# 202510 = 2025년 1학기, 202520 = 2025년 2학기
DATA_JS_SEMESTER_CODES = {
    1: "10",  # 1학기 → major_202510
    2: "20",  # 2학기 → major_202520
    "summer": "15",  # 여름학기 → major_202515
    "winter": "25",  # 겨울학기 → major_202525
}

# 학기 코드를 YYYYMM 형식으로 변환하는 함수 (data.js 변수명용)
def get_semester_code_full(year: int, semester: int) -> str:
    """
    년도와 학기 → YYYYMM 코드 (data.js 변수명용)
    예: 2025, 1 → "202510"
    """
    semester_suffix = DATA_JS_SEMESTER_CODES.get(semester, "10")
    return f"{year}{semester_suffix}"

# 캠퍼스 코드 (필요시 추가)
CAMPUS_CODES = {
    "서울": "1",
    "국제": "2",
}

# 단과대학 코드 예시 (실제 사이트에서 확인 필요)
# p_major 값으로 사용
COLLEGE_CODES = {
    "A10627": "특정 학과",  # 예시로 확인한 코드
    # 추가 학과 코드는 사이트에서 확인 후 추가
}

# HTTP 요청 헤더 (정상적인 브라우저처럼 보이도록)
# Note: Referer는 동적으로 설정됨 (LOGIN_REFERER 사용)
DEFAULT_HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
    'X-Requested-With': 'XMLHttpRequest',
}

# 타임아웃 설정 (초)
REQUEST_TIMEOUT = 30

# 재시도 설정
MAX_RETRIES = 3
RETRY_DELAY = 2  # 초