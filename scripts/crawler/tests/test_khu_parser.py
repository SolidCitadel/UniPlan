"""
KHU Parser Unit Tests

Tests for parsing KHU raw data into catalog-service format.
"""
import pytest
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from universities.khu.parser import KHUParser


class TestParseClassTime:
    """Tests for parse_class_time method."""

    def test_single_time_slot(self):
        """Single day and time slot."""
        result = KHUParser.parse_class_time("화 15:00-16:15 (전211-1)")
        assert result == [{"day": "화", "startTime": "15:00", "endTime": "16:15"}]

    def test_multiple_time_slots(self):
        """Multiple days with <BR> separator."""
        result = KHUParser.parse_class_time("화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)")
        assert len(result) == 2
        assert result[0] == {"day": "화", "startTime": "15:00", "endTime": "16:15"}
        assert result[1] == {"day": "목", "startTime": "15:00", "endTime": "16:15"}

    def test_empty_timetable(self):
        """Empty or None input."""
        assert KHUParser.parse_class_time("") == []
        assert KHUParser.parse_class_time(None) == []

    def test_different_time_slots(self):
        """Different times on different days."""
        result = KHUParser.parse_class_time("월 09:00-10:30 (공A101)<BR>수 14:00-15:30 (공A102)")
        assert result[0]["day"] == "월"
        assert result[0]["startTime"] == "09:00"
        assert result[1]["day"] == "수"
        assert result[1]["startTime"] == "14:00"


class TestExtractClassroom:
    """Tests for extract_classroom method."""

    def test_extract_from_parentheses(self):
        """Extract classroom from parentheses."""
        result = KHUParser.extract_classroom("화 15:00-16:15 (전211-1)")
        assert result == "전211-1"

    def test_empty_input(self):
        """Empty or None input."""
        assert KHUParser.extract_classroom("") == ""
        assert KHUParser.extract_classroom(None) == ""

    def test_no_classroom(self):
        """Time slot without classroom."""
        result = KHUParser.extract_classroom("화 15:00-16:15")
        assert result == ""


class TestParseCourse:
    """Tests for parse_course method."""

    @pytest.fixture
    def sample_raw_course(self):
        """Sample raw course data from KHU API."""
        return {
            "subjt_cd": "CSE302",
            "subjt_name": "컴퓨터네트워크",
            "lecture_cd_disp": "CSE302-01",
            "teach_na": "홍길동",
            "unit_num": "3",
            "lect_grade": "3",
            "timetable": "화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)",
            "field_gb": "04",
            "class_cd": "A10627",
            "campus_nm": "국제",
            "bigo": "영어강의",
        }

    def test_basic_fields(self, sample_raw_course):
        """Test basic field transformation."""
        result = KHUParser.parse_course(sample_raw_course, 2026, 1, university_id=1)

        assert result["universityId"] == 1
        assert result["openingYear"] == 2026
        assert result["semester"] == "1"
        assert result["courseName"] == "컴퓨터네트워크"
        assert result["professor"] == "홍길동"
        assert result["credits"] == 3
        assert result["courseTypeCode"] == "04"
        assert result["campus"] == "국제"
        assert result["notes"] == "영어강의"

    def test_course_code_section_split(self, sample_raw_course):
        """Test course code and section splitting."""
        result = KHUParser.parse_course(sample_raw_course, 2026, 1)

        assert result["courseCode"] == "CSE302"
        assert result["section"] == "01"

    def test_class_time_parsing(self, sample_raw_course):
        """Test class time extraction."""
        result = KHUParser.parse_course(sample_raw_course, 2026, 1)

        assert len(result["classTime"]) == 2
        assert result["classTime"][0]["day"] == "화"
        assert result["classroom"] == "전211-1"

    def test_empty_credits(self):
        """Test handling of empty credits."""
        raw = {"unit_num": "", "subjt_cd": "TEST", "subjt_name": "Test"}
        result = KHUParser.parse_course(raw, 2026, 1)
        assert result["credits"] == 0

    def test_course_code_without_section(self):
        """Test course without section in lecture_cd_disp."""
        raw = {"subjt_cd": "TEST001", "subjt_name": "Test", "lecture_cd_disp": "TEST001"}
        result = KHUParser.parse_course(raw, 2026, 1)
        assert result["courseCode"] == "TEST001"
        assert result["section"] == ""


class TestParseColleges:
    """Tests for parse_colleges method."""

    @pytest.fixture
    def sample_js_content(self):
        """Sample data.js content."""
        return '''
var daehak_202610 = {"rows":[
{"id":1,"enm":"College of Humanities","nm":"문과대학","cd":"A01008","gb":"H"},
{"id":2,"enm":"College of Engineering","nm":"공과대학","cd":"A04754","gb":"H"}
]}

var major_202610 = {"rows":[]}
'''

    def test_parse_colleges(self, sample_js_content):
        """Test college parsing."""
        result = KHUParser.parse_colleges(sample_js_content, 2026, 1)

        assert len(result) == 2
        assert "A01008" in result
        assert result["A01008"]["code"] == "A01008"
        assert result["A01008"]["name"] == "문과대학"


class TestParseDepartments:
    """Tests for parse_departments method."""

    @pytest.fixture
    def sample_js_content(self):
        """Sample data.js content with departments."""
        return '''
var daehak_202610 = {"rows":[]}

var major_202610 = {"rows":[
{"id":1,"nm":"정경대학 경제학과 경제학","cd":"A00430","dh":"A00422"},
{"id":2,"nm":"공과대학 컴퓨터공학과","cd":"A10627","dh":"A04754"}
]}
'''

    def test_parse_departments(self, sample_js_content):
        """Test department parsing with correct college code (dh field)."""
        result = KHUParser.parse_departments(sample_js_content, 2026, 1)

        assert len(result) == 2
        assert "A00430" in result
        assert result["A00430"]["code"] == "A00430"
        assert result["A00430"]["name"] == "정경대학 경제학과 경제학"
        assert result["A00430"]["collegeCode"] == "A00422"  # dh field, not cd

    def test_college_code_is_dh_not_cd(self, sample_js_content):
        """Verify collegeCode comes from dh field, not cd."""
        result = KHUParser.parse_departments(sample_js_content, 2026, 1)

        # A00430's college should be A00422 (dh), not A00430 (cd)
        assert result["A00430"]["collegeCode"] != result["A00430"]["code"]


class TestParseCourseTypes:
    """Tests for parse_course_types method."""

    @pytest.fixture
    def sample_js_content(self):
        """Sample data.js content with course types."""
        return '''
var gradIsuCd_2026 = {"rows":[
{"id":1,"nmk":"전공필수","cd":"04","nme":"Essential Major Studies"},
{"id":2,"nmk":"전공선택","cd":"05","nme":"Elective Major Studies"}
]}
'''

    def test_parse_course_types(self, sample_js_content):
        """Test course type parsing."""
        result = KHUParser.parse_course_types(sample_js_content, 2026)

        assert "04" in result
        assert result["04"]["code"] == "04"
        assert result["04"]["nameKr"] == "전공필수"


class TestParseCourses:
    """Tests for parse_courses method (batch with deduplication)."""

    def test_deduplication_by_key(self):
        """Test that duplicate courses are merged."""
        raw_courses = [
            {
                "subjt_cd": "CSE302",
                "subjt_name": "컴퓨터네트워크",
                "lecture_cd_disp": "CSE302-01",
                "teach_na": "홍길동",
                "unit_num": "3",
                "timetable": "화 15:00-16:15",
                "class_cd": "A10627",
            },
            {
                "subjt_cd": "CSE302",
                "subjt_name": "컴퓨터네트워크",
                "lecture_cd_disp": "CSE302-01",
                "teach_na": "홍길동",
                "unit_num": "3",
                "timetable": "화 15:00-16:15",
                "class_cd": "A10628",  # Different department, same course
            },
        ]

        result = KHUParser.parse_courses(raw_courses, 2026, 1)

        # Should be deduplicated to 1 course with 2 department codes
        assert len(result) == 1
        assert len(result[0]["departmentCodes"]) == 2
        assert "A10627" in result[0]["departmentCodes"]
        assert "A10628" in result[0]["departmentCodes"]
