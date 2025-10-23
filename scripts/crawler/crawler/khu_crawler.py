"""
경희대학교 수강신청 시스템 크롤러
API 기반 (Selenium 불필요)
"""

import time
import requests
from typing import List, Dict, Optional
import sys
import os

# 상위 디렉토리를 path에 추가
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.khu_config import (
    BASE_URL,
    DATA_JS_URL,
    LOGIN_REFERER,
    DEFAULT_HEADERS,
    SEMESTER_CODES,
    REQUEST_TIMEOUT,
    MAX_RETRIES,
    RETRY_DELAY
)


class KHUCrawler:
    """경희대 수강신청 시스템 크롤러"""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update(DEFAULT_HEADERS)

    def _generate_timestamp(self) -> str:
        """캐시 방지용 타임스탬프 생성"""
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
        """
        API 요청 파라미터 생성

        Args:
            year: 년도 (예: 2025)
            semester: 학기 (1=1학기, 2=2학기)
            major_code: 학과 코드 (선택, 없으면 전체)
            professor: 교수명 필터 (선택)
            subject: 과목명 필터 (선택)
            day: 요일 필터 (선택)
            time_slot: 시간 필터 (선택)
        """
        semester_code = SEMESTER_CODES.get(semester, "20")

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
            'p_major': major_code or '',  # 빈 문자열 = 전체 학과
            'p_lang': '',
            'p_year': str(year),
            'p_term': semester_code,
            'lecture_cd': '',
            'initYn': 'Y',
            '_search': 'false',
            'nd': self._generate_timestamp(),
            'rows': '-1',  # -1 = 전체 데이터
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
        강의 데이터 가져오기

        Args:
            year: 년도
            semester: 학기
            **filters: 추가 필터 (major_code, professor, subject 등)

        Returns:
            JSON 응답 데이터 또는 None (실패 시)
        """
        params = self._build_params(year, semester, **filters)

        # ⭐ 중요: Referer 헤더 추가 (이게 없으면 404 에러)
        headers = {
            'Referer': LOGIN_REFERER + f"&fake={self._generate_timestamp()}"
        }

        for attempt in range(MAX_RETRIES):
            try:
                print(f"Fetching courses... (Attempt {attempt + 1}/{MAX_RETRIES})")

                response = self.session.get(
                    BASE_URL,
                    params=params,
                    headers=headers,
                    timeout=REQUEST_TIMEOUT
                )

                response.raise_for_status()  # HTTP 에러 체크

                data = response.json()

                # 응답 구조 확인
                if 'rows' in data:
                    print(f"Success! Fetched {len(data['rows'])} courses")
                    return data
                else:
                    print(f"Unexpected response structure: {data.keys()}")
                    return data

            except requests.exceptions.Timeout:
                print(f"Timeout on attempt {attempt + 1}")
                if attempt < MAX_RETRIES - 1:
                    time.sleep(RETRY_DELAY)

            except requests.exceptions.HTTPError as e:
                print(f"HTTP Error: {e.response.status_code}")
                print(f"Response: {e.response.text[:200]}")
                return None

            except requests.exceptions.RequestException as e:
                print(f"Request failed: {str(e)}")
                if attempt < MAX_RETRIES - 1:
                    time.sleep(RETRY_DELAY)

            except ValueError as e:
                print(f"JSON parsing failed: {str(e)}")
                print(f"Response text: {response.text[:200]}")
                return None

        print(f"Failed after {MAX_RETRIES} attempts")
        return None

    def fetch_department_list(self, year: int, semester: int) -> Dict[str, str]:
        """
        data_YYYY.js에서 학과 코드 목록 가져오기

        Args:
            year: 년도
            semester: 학기 (1, 2)

        Returns:
            {학과코드: 학과명} 딕셔너리
        """
        from crawler.data_js_parser import DataJsParser

        print(f"Fetching department list for {year} year, semester {semester}...")
        metadata = DataJsParser.parse_metadata(year, semester)

        if metadata['departments']:
            print(f"Found {len(metadata['departments'])} departments")
            return metadata['departments']
        else:
            print("No departments found in data.js")
            return {}

    def fetch_all_departments(self, year: int, semester: int, department_codes: Dict[str, str] = None) -> List[Dict]:
        """
        모든 학과의 강의 데이터 가져오기
        학과별로 순차 크롤링

        Args:
            year: 년도
            semester: 학기
            department_codes: 학과 코드 딕셔너리 (없으면 자동 로드)

        Returns:
            전체 강의 목록
        """
        print(f"Fetching all courses for {year} year, semester {semester}...")
        print("=" * 60)

        # 학과 목록 로드
        if department_codes is None:
            department_codes = self.fetch_department_list(year, semester)

        if not department_codes:
            print("No department codes available")
            return []

        print(f"Will crawl {len(department_codes)} departments")
        print("=" * 60)
        print()

        all_courses = []
        success_count = 0
        fail_count = 0

        for idx, (dept_code, dept_name) in enumerate(department_codes.items(), 1):
            print(f"[{idx}/{len(department_codes)}] {dept_code}")

            try:
                data = self.fetch_courses(year, semester, major_code=dept_code)

                if data and 'rows' in data:
                    courses = data['rows']
                    all_courses.extend(courses)
                    success_count += 1
                    print(f"   -> {len(courses)} courses")
                else:
                    fail_count += 1
                    print(f"   -> No data")

            except Exception as e:
                fail_count += 1
                print(f"   -> Error: {str(e)}")

            # Rate limiting (서버 부하 방지)
            if idx < len(department_codes):
                time.sleep(0.5)  # 0.5초 대기

            print()

        print("=" * 60)
        print(f"Crawling complete!")
        print(f"   Success: {success_count} departments")
        print(f"   Failed: {fail_count} departments")
        print(f"   Total courses: {len(all_courses)}")
        print("=" * 60)

        return all_courses

    def close(self):
        """세션 종료"""
        self.session.close()


# 테스트용 코드
if __name__ == "__main__":
    import json

    print("Testing KHU Crawler...")
    print("-" * 50)

    crawler = KHUCrawler()

    try:
        test_year = 2025
        test_semester = 1

        print(f"\n1. Testing department list fetch for {test_year} year, semester {test_semester}...")
        print("-" * 50)
        departments = crawler.fetch_department_list(test_year, test_semester)

        if departments:
            print(f"\nFound {len(departments)} departments")
            print("\nSample departments (first 5):")
            for code, name in list(departments.items())[:5]:
                print(f"   {code}: {name}")
        else:
            print("\nNo departments found")

        print("\n" + "=" * 60)
        print("\n2. Testing single department fetch...")
        print("-" * 50)

        # 첫 번째 학과로 테스트
        if departments:
            test_dept_code = list(departments.keys())[0]
            test_dept_name = departments[test_dept_code]
            print(f"\nTesting with: ({test_dept_code})")

            result = crawler.fetch_courses(year=test_year, semester=test_semester, major_code=test_dept_code)

            if result:
                print("\nAPI Response Structure:")
                print(f"Keys: {result.keys()}")

                if 'rows' in result and len(result['rows']) > 0:
                    print(f"\nFetched {len(result['rows'])} courses")
                    print("\nFirst course sample:")

                    first_course = result['rows'][0]
                    print(json.dumps(first_course, indent=2, ensure_ascii=False))
                else:
                    print("\nNo courses found")
                    print(f"Full response: {result}")
            else:
                print("\nFailed to fetch data")
        else:
            print("\nSkipping (no departments to test)")

    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
    except Exception as e:
        print(f"\nError: {str(e)}")
        import traceback
        traceback.print_exc()
    finally:
        crawler.close()
        print("\nTest complete!")
