"""
경희대학교 데이터 파서
KHU Data Parser - transforms raw API responses to catalog-service format.

Raw data 필드 명세는 README.md를 참조하세요.
"""
import re
from typing import Dict, List, Optional

from .config import UNIVERSITY_ID, get_semester_code_full


class KHUParser:
    """경희대 강의 데이터 파서"""

    # ========== Metadata Parsing (from data.js) ==========

    @staticmethod
    def parse_colleges(js_content: str, year: int, semester: int) -> Dict[str, Dict]:
        """
        Parse college codes from data.js.

        Variable format: var daehak_YYYYMM = { "rows": [...] }
        """
        colleges = {}
        semester_code = get_semester_code_full(year, semester)
        var_name = f"daehak_{semester_code}"

        start_pattern = rf'var\s+{var_name}\s*='
        start_match = re.search(start_pattern, js_content)

        if not start_match:
            return colleges

        start_idx = start_match.end()
        next_var_match = re.search(r'\nvar\s+\w+', js_content[start_idx:])
        end_idx = start_idx + next_var_match.start() if next_var_match else len(js_content)

        rows_section = js_content[start_idx:end_idx]

        # Pattern: "nm": "...", "cd": "..."
        pattern = r'"nm"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"'
        matches = re.findall(pattern, rows_section)

        for name, code in matches:
            colleges[code] = {"code": code, "name": name}

        return colleges

    @staticmethod
    def parse_departments(js_content: str, year: int, semester: int) -> Dict[str, Dict]:
        """
        Parse department codes from data.js.

        Variable format: var major_YYYYMM = { "rows": [...] }
        """
        departments = {}
        semester_code = get_semester_code_full(year, semester)
        var_name = f"major_{semester_code}"

        start_pattern = rf'var\s+{var_name}\s*='
        start_match = re.search(start_pattern, js_content)

        if not start_match:
            return departments

        start_idx = start_match.end()
        next_var_match = re.search(r'\nvar\s+\w+', js_content[start_idx:])
        end_idx = start_idx + next_var_match.start() if next_var_match else len(js_content)

        rows_section = js_content[start_idx:end_idx]

        # Pattern includes college code (dh field)
        pattern = r'"nm"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"[^}]*"dh"\s*:\s*"([^"]+)"'
        matches = re.findall(pattern, rows_section)

        for name, code, college_code in matches:
            departments[code] = {"code": code, "name": name, "collegeCode": college_code}

        # If pattern didn't work, try simpler pattern
        if not departments:
            pattern = r'"nm"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"'
            matches = re.findall(pattern, rows_section)
            for name, code in matches:
                departments[code] = {"code": code, "name": name, "collegeCode": code}

        return departments

    @staticmethod
    def parse_course_types(js_content: str, year: int) -> Dict[str, Dict]:
        """
        Parse course type codes from data.js.

        Variable format: var gradIsuCd_YYYY = { "rows": [...] }
        """
        course_types = {}
        var_name = f"gradIsuCd_{year}"

        start_pattern = rf'var\s+{var_name}\s*='
        start_match = re.search(start_pattern, js_content)

        if not start_match:
            return course_types

        start_idx = start_match.end()
        next_var_match = re.search(r'\nvar\s+\w+', js_content[start_idx:])
        end_idx = start_idx + next_var_match.start() if next_var_match else len(js_content)

        rows_section = js_content[start_idx:end_idx]

        # Pattern: "nmk" for Korean name in course types (not "nm")
        pattern = r'"nmk"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"'
        matches = re.findall(pattern, rows_section)

        for name, code in matches:
            course_types[code] = {"code": code, "nameKr": name, "nameEn": name}

        # KHU-specific course types (교양)
        khu_types = {
            "14": {"code": "14", "nameKr": "후마니타스", "nameEn": "Humanitas"},
            "15": {"code": "15", "nameKr": "자유이수과목", "nameEn": "Free Elective"},
            "16": {"code": "16", "nameKr": "기초교양", "nameEn": "Basic Liberal Arts"},
            "17": {"code": "17", "nameKr": "자율이수", "nameEn": "Autonomous"},
        }
        for code, info in khu_types.items():
            if code not in course_types:
                course_types[code] = info

        return course_types

    @classmethod
    def parse_metadata(cls, js_content: str, year: int, semester: int) -> Dict:
        """
        Parse all metadata from data.js content.

        Returns:
            {
                'year': int,
                'semester': int,
                'colleges': {code: {name}},
                'departments': {code: {name, collegeCode}},
                'courseTypes': {code: {nameKr, nameEn}}
            }
        """
        return {
            'year': year,
            'semester': semester,
            'colleges': cls.parse_colleges(js_content, year, semester),
            'departments': cls.parse_departments(js_content, year, semester),
            'courseTypes': cls.parse_course_types(js_content, year),
        }

    # ========== Course Parsing ==========

    @staticmethod
    def parse_class_time(timetable: str) -> List[Dict]:
        """
        Parse class time from KHU format.

        Input: "화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
        Output: [{"day": "화", "startTime": "15:00", "endTime": "16:15"}, ...]
        """
        if not timetable:
            return []

        time_slots = timetable.split('<BR>')
        parsed_times = []

        for slot in time_slots:
            # Remove classroom info in parentheses
            slot = re.sub(r'\s*\([^)]+\)', '', slot).strip()
            if not slot:
                continue

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
    def extract_classroom(timetable: str) -> str:
        """Extract classroom from timetable string."""
        if not timetable:
            return ""

        match = re.search(r'\(([^)]+)\)', timetable)
        return match.group(1).strip() if match else ""

    @classmethod
    def parse_course(cls, raw_course: Dict, year: int, semester: int, university_id: int = UNIVERSITY_ID) -> Dict:
        """
        Transform single course from KHU API format to catalog-service format.

        Args:
            raw_course: Raw course data from KHU API
            year: Year
            semester: Semester (1 or 2)
            university_id: University ID for catalog-service

        Returns:
            Course dict matching catalog-service CourseImportRequest DTO
        """
        # Parse credits
        unit_str = raw_course.get('unit_num', '0')
        try:
            credits = int(float(str(unit_str).strip()))
        except (ValueError, AttributeError):
            credits = 0

        # Parse course code and section
        lecture_cd_disp = raw_course.get('lecture_cd_disp', '')
        if lecture_cd_disp and '-' in lecture_cd_disp:
            parts = lecture_cd_disp.rsplit('-', 1)
            course_code = parts[0]
            section = parts[1]
        else:
            course_code = raw_course.get('subjt_cd', '')
            section = ''

        timetable = raw_course.get('timetable', '')

        return {
            "universityId": university_id,
            "openingYear": year,
            "semester": str(semester),
            "targetGrade": str(raw_course.get('lect_grade', '')) or None,
            "courseCode": course_code,
            "section": section,
            "courseName": raw_course.get('subjt_name', ''),
            "professor": raw_course.get('teach_na', ''),
            "credits": credits,
            "classTime": cls.parse_class_time(timetable),
            "classroom": cls.extract_classroom(timetable),
            "courseTypeCode": raw_course.get('field_gb', ''),
            "campus": raw_course.get('campus_nm', '').strip(),
            # Use _queried_dept (injected during crawl) instead of class_cd (unreliable)
            "departmentCode": raw_course.get('_queried_dept', '') or raw_course.get('class_cd', ''),
            "notes": raw_course.get('bigo', '').strip(),
        }

    @classmethod
    def parse_courses(cls, raw_courses: List[Dict], year: int, semester: int, university_id: int = UNIVERSITY_ID) -> List[Dict]:
        """
        Transform multiple courses with deduplication and department merging.

        Args:
            raw_courses: List of raw courses from KHU API
            year: Year
            semester: Semester
            university_id: University ID

        Returns:
            List of unique courses with merged department lists
        """
        parsed_courses = []
        for raw in raw_courses:
            try:
                parsed = cls.parse_course(raw, year, semester, university_id)
                parsed_courses.append(parsed)
            except Exception as e:
                print(f"Failed to parse course: {e}")

        # Group by unique course identifier
        course_groups = {}
        for course in parsed_courses:
            key = (
                course['courseCode'],
                course['section'],
                course['professor'],
                course['openingYear'],
                course['semester'],
                str(course.get('classTime', [])),
                course.get('classroom', '')
            )

            if key in course_groups:
                # Prefer shorter course name (without department suffix)
                existing_name = course_groups[key]['courseName']
                new_name = course['courseName']
                if len(new_name) < len(existing_name):
                    course_groups[key]['courseName'] = new_name

                # Add department to list
                dept_code = course.get('departmentCode')
                if dept_code and dept_code not in course_groups[key]['departmentCodes']:
                    course_groups[key]['departmentCodes'].append(dept_code)
            else:
                dept_code = course.pop('departmentCode', None)
                course['departmentCodes'] = [dept_code] if dept_code else []
                course_groups[key] = course

        return list(course_groups.values())
