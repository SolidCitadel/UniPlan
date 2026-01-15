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
        Normalize semester to a plain numeric string (e.g., 1 -> "1").
        """
        try:
            return str(int(semester))
        except (TypeError, ValueError):
            return str(semester)

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
    def parse_course(cls, raw_course: Dict, year: int, semester: int, metadata: Dict, university_id: int = None) -> Dict:
        """
        경희대 API 응답 → catalog-service 형식 변환

        Args:
            raw_course: 경희대 API의 단일 강의 데이터
            year: 개설년도
            semester: 학기 (1 또는 2)
            metadata: 메타데이터 (colleges, departments, courseTypes)
            university_id: 대학 ID (catalog-service의 University 테이블 ID)

        Returns:
            catalog-service Course 엔티티 형식의 딕셔너리
        """
        # 학점 파싱 (문자열 "  3.0" → 정수 3)
        unit_str = raw_course.get('unit_num', '0')
        try:
            credits = int(float(unit_str.strip()))
        except (ValueError, AttributeError):
            credits = 0

        # 분반 정보 분리 (lecture_cd_disp: "CSE302-01" → courseCode: "CSE302", section: "01")
        lecture_cd_disp = raw_course.get('lecture_cd_disp', '')
        if lecture_cd_disp and '-' in lecture_cd_disp:
            parts = lecture_cd_disp.rsplit('-', 1)  # 오른쪽에서 1번만 분리
            course_code = parts[0]
            section = parts[1]
        else:
            # lecture_cd_disp가 없거나 '-'가 없으면 subjt_cd 사용
            course_code = raw_course.get('subjt_cd', '')
            section = ''

        result = {
            "openingYear": year,
            "semester": cls.normalize_semester(semester),
            "targetGrade": cls.extract_target_grade(raw_course),
            "courseCode": course_code,
            "section": section,
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

        # university_id가 제공된 경우 추가
        if university_id is not None:
            result["universityId"] = university_id

        return result

    @classmethod
    def parse_courses(cls, raw_courses: List[Dict], year: int, semester: int, metadata: Dict, university_id: int = None) -> List[Dict]:
        """
        여러 강의 데이터를 일괄 변환 (중복 제거 및 학과 목록 병합)

        Args:
            raw_courses: 경희대 API 응답의 강의 목록
            year: 개설년도
            semester: 학기 (1 또는 2)
            metadata: 메타데이터 (colleges, departments, courseTypes)
            university_id: 대학 ID (catalog-service의 University 테이블 ID)

        Returns:
            변환된 강의 목록 (학과 중복 제거 및 병합)
        """
        # Step 1: 모든 강의를 파싱
        parsed_courses = []
        for raw in raw_courses:
            try:
                parsed = cls.parse_course(raw, year, semester, metadata, university_id)
                parsed_courses.append(parsed)
            except Exception as e:
                print(f"Failed to parse course: {e}")
                print(f"   Raw data: {raw}")

        # Step 2: 같은 강의를 그룹핑 (courseCode + section + professor + year + semester)
        # 학과 정보는 리스트로 병합
        course_groups = {}

        for course in parsed_courses:
            # 강의 고유 식별자 (학과 제외)
            key = (
                course['courseCode'],
                course['section'],
                course['professor'],
                course['openingYear'],
                course['semester'],
                # classTime과 classroom도 포함하여 동일 강의 판별
                str(course.get('classTime', [])),
                course.get('classroom', '')
            )

            if key in course_groups:
                # 기존 과목명과 비교하여 더 짧은 것 선택 (괄호 없는 버전 우선)
                existing_name = course_groups[key]['courseName']
                new_name = course['courseName']
                if len(new_name) < len(existing_name):
                    course_groups[key]['courseName'] = new_name

                # 기존 강의에 학과 추가
                dept_code = course.get('departmentCode')
                if dept_code and dept_code not in course_groups[key]['departmentCodes']:
                    course_groups[key]['departmentCodes'].append(dept_code)
            else:
                # 새로운 강의 추가 (departmentCode → departmentCodes로 변환)
                dept_code = course.pop('departmentCode', None)
                course['departmentCodes'] = [dept_code] if dept_code else []
                course_groups[key] = course

        # Step 3: 그룹핑된 강의 목록 반환
        result = list(course_groups.values())

        print(f"  Grouped {len(parsed_courses)} raw courses into {len(result)} unique courses")

        return result


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
