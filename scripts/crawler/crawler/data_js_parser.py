"""
data_YYYY.js 파일 파싱
학과 코드, 캠퍼스 코드 등 메타데이터 추출
"""

import re
import requests
from typing import Dict, List, Optional
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.khu_config import DATA_JS_URL, REQUEST_TIMEOUT, get_semester_code_full


class DataJsParser:
    """data_YYYY.js 파일 파서"""

    @staticmethod
    def fetch_data_js(year: int) -> Optional[str]:
        """
        data_YYYY.js 파일 다운로드

        Args:
            year: 년도 (예: 2025)

        Returns:
            JavaScript 파일 내용 또는 None
        """
        url = DATA_JS_URL.format(year=year)
        print(f"Fetching metadata from: {url}")

        try:
            response = requests.get(url, timeout=REQUEST_TIMEOUT)
            response.raise_for_status()
            print(f"Successfully fetched data.js ({len(response.text)} bytes)")
            return response.text

        except requests.exceptions.RequestException as e:
            print(f"Failed to fetch data.js: {str(e)}")
            return None

    @staticmethod
    def parse_department_codes(js_content: str, year: int, semester: int) -> Dict[str, str]:
        """
        JavaScript 파일에서 학과 코드 추출

        실제 형식:
        var major_202510 = {  // 2025년 1학기
            "rows": [
                { "id": 1, "cd": "A10627", "nm": "컴퓨터공학과", ... },
                ...
            ]
        }
        var major_202520 = { ... }  // 2025년 2학기

        Args:
            js_content: JavaScript 파일 내용
            year: 년도
            semester: 학기 (1, 2)

        Returns:
            {학과코드: 학과명} 딕셔너리
        """
        dept_map = {}

        # 학기별 변수명 생성: major_202510, major_202520 등
        semester_code = get_semester_code_full(year, semester)
        var_name = f"major_{semester_code}"

        print(f"   Looking for variable: {var_name}")

        # 단순화: var major_202510부터 다음 var까지 전체 텍스트 추출
        # 그 안에서 cd, nm 찾기
        start_pattern = rf'var\s+{var_name}\s*='
        start_match = re.search(start_pattern, js_content)

        if not start_match:
            print(f"   Variable {var_name} not found in data.js")
            return dept_map

        start_idx = start_match.end()

        # 다음 var 찾기 (또는 파일 끝)
        next_var_match = re.search(r'\nvar\s+\w+', js_content[start_idx:])
        if next_var_match:
            end_idx = start_idx + next_var_match.start()
        else:
            end_idx = len(js_content)

        rows_section = js_content[start_idx:end_idx]

        # cd, nm 추출 (주의: 실제 데이터에서는 nm이 cd보다 먼저 나옴!)
        pattern_obj = r'"nm"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"'
        matches = re.findall(pattern_obj, rows_section)

        if matches:
            # matches는 (nm, cd) 순서이므로 바꿔서 저장
            for name, code in matches:
                dept_map[code] = name
            print(f"   Found {len(dept_map)} departments for {var_name}")
        else:
            print(f"   Variable {var_name} not found in data.js")

        return dept_map

    @staticmethod
    def parse_campus_codes(js_content: str) -> Dict[str, str]:
        """
        캠퍼스 코드 추출

        Returns:
            {캠퍼스코드: 캠퍼스명} 딕셔너리
        """
        campus_map = {}

        # 예: var campus = {"1": "서울", "2": "국제"}
        pattern = r'campus[^{]*\{([^}]+)\}'
        match = re.search(pattern, js_content, re.IGNORECASE)

        if match:
            content = match.group(1)
            pairs = re.findall(r'["\'](\d+)["\']\s*:\s*["\']([^"\']+)["\']', content)
            for code, name in pairs:
                campus_map[code] = name

        return campus_map

    @classmethod
    def parse_metadata(cls, year: int, semester: int) -> Dict:
        """
        년도와 학기에 해당하는 메타데이터 전체 파싱

        Args:
            year: 년도
            semester: 학기 (1, 2)

        Returns:
            {
                'departments': {학과코드: 학과명},
                'campuses': {캠퍼스코드: 캠퍼스명},
                'year': 년도,
                'semester': 학기
            }
        """
        js_content = cls.fetch_data_js(year)

        if not js_content:
            return {
                'departments': {},
                'campuses': {},
                'year': year,
                'semester': semester
            }

        print("Parsing metadata...")

        departments = cls.parse_department_codes(js_content, year, semester)
        campuses = cls.parse_campus_codes(js_content)

        print(f"Found {len(departments)} departments")
        print(f"Found {len(campuses)} campuses")

        return {
            'departments': departments,
            'campuses': campuses,
            'year': year,
            'semester': semester
        }


# 테스트용
if __name__ == "__main__":
    parser = DataJsParser()

    print("=" * 60)
    print("Testing DataJsParser")
    print("=" * 60)
    print()

    # 2025년 1학기 메타데이터 파싱
    metadata = parser.parse_metadata(2025, 1)

    print("\n" + "=" * 60)
    print("📊 Parsed Metadata")
    print("=" * 60)

    print(f"\n🎓 Departments ({len(metadata['departments'])} total):")
    for code, name in list(metadata['departments'].items())[:10]:
        print(f"   {code}: {name}")
    if len(metadata['departments']) > 10:
        print(f"   ... and {len(metadata['departments']) - 10} more")

    print(f"\n🏫 Campuses ({len(metadata['campuses'])} total):")
    for code, name in metadata['campuses'].items():
        print(f"   {code}: {name}")

    print()