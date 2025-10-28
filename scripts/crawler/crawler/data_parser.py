"""
경희대 API 응답 → UniPlan catalog-service 형식 변환
"""

from typing import Dict, List, Optional
import re


class KHUDataParser:
    """경희대 강의 데이터 파서"""

    @staticmethod
    def normalize_semester(semester: int) -> str:
        """
        학기 숫자 → 표준 형식
        예: 1 → "1학기", 2 → "2학기"
        """
        semester_map = {
            1: "1학기",
            2: "2학기",
        }
        return semester_map.get(semester, f"{semester}학기")

    @staticmethod
    def normalize_course_type(field_gb: str, course_types: dict) -> str:
        """
        경희대 이수구분 코드 → 표준 형식

        metadata의 courseTypes를 사용하여 동적으로 변환
        """
        if not course_types or field_gb not in course_types:
            return f"기타({field_gb})"

        return course_types[field_gb].get('nameKr', f"기타({field_gb})")

    @staticmethod
    def parse_class_time(timetable: str) -> list:
        """
        경희대 강의시간 형식 파싱

        실제 형식: "화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"

        변환: [
            {"day": "화", "startTime": "15:00", "endTime": "16:15"},
            {"day": "목", "startTime": "15:00", "endTime": "16:15"}
        ]
        """
        if not timetable:
            return []

        # <BR> 태그로 분리
        time_slots = timetable.split('<BR>')
        parsed_times = []

        for slot in time_slots:
            # 강의실 정보 제거 (괄호 안)
            slot = re.sub(r'\s*\([^)]+\)', '', slot).strip()

            if not slot:
                continue

            # 패턴: "화 15:00-16:15"
            match = re.match(r'([가-힣]+)\s*(\d{2}:\d{2})-(\d{2}:\d{2})', slot)
            if match:
                day, start_time, end_time = match.groups()
                parsed_times.append({
                    "day": day,
                    "startTime": start_time,
                    "endTime": end_time
                })

        return parsed_times

    @staticmethod
    def extract_target_grade(raw_course: Dict) -> str:
        """
        대상학년 추출

        실제 필드: lect_grade (int)
        예: 2 → "2"
        """
        grade = raw_course.get('lect_grade')
        if grade:
            return str(grade)
        return ""

    @staticmethod
    def extract_campus(raw_course: Dict) -> str:
        """
        캠퍼스 정보 추출

        실제 필드: campus_nm
        예: "국제", "서울"
        """
        campus = raw_course.get('campus_nm', '')
        return campus.strip() if campus else ""

    @staticmethod
    def safe_int(value, default=0) -> int:
        """안전한 정수 변환"""
        try:
            if isinstance(value, int):
                return value
            if isinstance(value, str):
                # 숫자 아닌 문자 제거 후 변환
                num_str = re.sub(r'[^\d]', '', value)
                return int(num_str) if num_str else default
            return default
        except (ValueError, TypeError):
            return default

    @staticmethod
    def extract_classroom(timetable: str) -> str:
        """
        강의실 정보 추출

        실제 형식: "화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
        추출: "전211-1" (첫 번째 강의실)
        """
        if not timetable:
            return ""

        # 괄호 안의 강의실 정보 추출
        match = re.search(r'\(([^)]+)\)', timetable)
        if match:
            return match.group(1).strip()

        return ""

    @classmethod
    def parse_course(cls, raw_course: Dict, year: int, semester: int, metadata: Dict) -> Dict:
        """
        경희대 API 응답 → catalog-service 형식 변환

        Args:
            raw_course: 경희대 API의 단일 강의 데이터
            year: 개설년도
            semester: 학기 (1 또는 2)
            metadata: 메타데이터 (colleges, departments, courseTypes)

        Returns:
            catalog-service Course 엔티티 형식의 딕셔너리
        """
        # 학점 파싱 (문자열 "  3.0" → 정수 3)
        unit_str = raw_course.get('unit_num', '0')
        try:
            credits = int(float(unit_str.strip()))
        except (ValueError, AttributeError):
            credits = 0

        return {
            "openingYear": year,
            "semester": cls.normalize_semester(semester),
            "targetGrade": cls.extract_target_grade(raw_course),
            "courseCode": raw_course.get('subjt_cd', ''),
            "courseName": raw_course.get('subjt_name', ''),
            "professor": raw_course.get('teach_na', ''),
            "credits": credits,
            "classTime": cls.parse_class_time(raw_course.get('timetable', '')),
            "classroom": cls.extract_classroom(raw_course.get('timetable', '')),
            "courseTypeCode": raw_course.get('field_gb', ''),
            "campus": cls.extract_campus(raw_course),
            "departmentCode": raw_course.get('class_cd', ''),
            "notes": raw_course.get('bigo', '').strip()
        }

    @classmethod
    def parse_courses(cls, raw_courses: List[Dict], year: int, semester: int, metadata: Dict) -> List[Dict]:
        """
        여러 강의 데이터를 일괄 변환

        Args:
            raw_courses: 경희대 API 응답의 강의 목록
            year: 개설년도
            semester: 학기 (1 또는 2)
            metadata: 메타데이터 (colleges, departments, courseTypes)

        Returns:
            변환된 강의 목록
        """
        parsed_courses = []

        for raw in raw_courses:
            try:
                parsed = cls.parse_course(raw, year, semester, metadata)
                parsed_courses.append(parsed)
            except Exception as e:
                print(f"Failed to parse course: {e}")
                print(f"   Raw data: {raw}")

        return parsed_courses


# 테스트용
if __name__ == "__main__":
    # 실제 API 응답 샘플
    sample_raw_course = {
        'subjt_cd': 'CSE302',
        'subjt_name': '컴퓨터네트워크',
        'teach_na': '이성원',
        'unit_num': '  3.0',
        'timetable': '월 15:00-16:15 (B01)<BR>수 15:00-16:15 (B01)',
        'campus_nm': '국제',
        'lect_grade': 3,
        'field_gb': '04',
        'class_cd': 'A10627',
        'bigo': ' ',
    }

    parser = KHUDataParser()
    result = parser.parse_course(sample_raw_course, year=2025, semester_code="20")

    print("📝 Parsed Course:")
    import json
    print(json.dumps(result, indent=2, ensure_ascii=False))