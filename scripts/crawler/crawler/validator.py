"""
크롤링된 강의 데이터 검증
"""

from typing import Dict, Tuple, List


class CourseValidator:
    """강의 데이터 검증 클래스"""

    # 필수 필드 정의
    REQUIRED_FIELDS = ['courseCode', 'courseName', 'credits', 'openingYear', 'semester']

    @classmethod
    def validate_course(cls, course: Dict) -> Tuple[bool, str]:
        """
        단일 강의 데이터 검증

        Args:
            course: 검증할 강의 데이터

        Returns:
            (is_valid, error_message)
        """
        # 1. 필수 필드 존재 여부 확인
        for field in cls.REQUIRED_FIELDS:
            if field not in course:
                return False, f"Missing required field: {field}"

            value = course[field]
            if value is None or (isinstance(value, str) and not value.strip()):
                return False, f"Empty required field: {field}"

        # 2. 학점 검증
        credits = course['credits']
        if not isinstance(credits, int) or credits <= 0:
            return False, f"Invalid credits: {credits} (must be positive integer)"

        # 3. 년도 검증
        year = course['openingYear']
        if not isinstance(year, int) or year < 2000 or year > 2100:
            return False, f"Invalid year: {year}"

        # 4. 학기 검증
        valid_semesters = ['1학기', '2학기', '여름학기', '겨울학기']
        if course['semester'] not in valid_semesters:
            return False, f"Invalid semester: {course['semester']}"

        return True, "Valid"

    @classmethod
    def validate_courses(cls, courses: List[Dict], verbose: bool = True) -> Tuple[List[Dict], List[Dict]]:
        """
        여러 강의 데이터 일괄 검증

        Args:
            courses: 검증할 강의 목록
            verbose: 검증 결과 출력 여부

        Returns:
            (valid_courses, invalid_courses)
        """
        valid_courses = []
        invalid_courses = []

        for idx, course in enumerate(courses):
            is_valid, message = cls.validate_course(course)

            if is_valid:
                valid_courses.append(course)
            else:
                invalid_courses.append({
                    'index': idx,
                    'course': course,
                    'error': message
                })

                if verbose:
                    print(f"⚠️  Invalid course at index {idx}: {message}")
                    print(f"   Data: {course.get('courseCode', 'N/A')} - {course.get('courseName', 'N/A')}")

        if verbose:
            print(f"\n📊 Validation Summary:")
            print(f"   ✅ Valid: {len(valid_courses)}")
            print(f"   ❌ Invalid: {len(invalid_courses)}")
            print(f"   📈 Success rate: {len(valid_courses) / len(courses) * 100:.1f}%")

        return valid_courses, invalid_courses


# 테스트용
if __name__ == "__main__":
    # 테스트 데이터
    test_courses = [
        {
            "openingYear": 2025,
            "semester": "1학기",
            "targetGrade": "3",
            "courseCode": "CSE1234",
            "courseName": "자료구조",
            "professor": "홍길동",
            "credits": 3,
            "classTime": "월1,수2",
            "classroom": "6-201",
            "courseType": "전공필수",
            "campus": "서울",
            "college": "공과대학",
            "department": "컴퓨터공학과",
            "notes": ""
        },
        {
            "openingYear": 2025,
            "semester": "1학기",
            "targetGrade": "",
            "courseCode": "",  # ❌ 필수 필드 비어있음
            "courseName": "데이터베이스",
            "professor": "김철수",
            "credits": 3,
            "classTime": "화2,목3",
            "classroom": "5-301",
            "courseType": "전공선택",
            "campus": "서울",
            "college": "공과대학",
            "department": "컴퓨터공학과",
            "notes": ""
        },
        {
            "openingYear": 2025,
            "semester": "1학기",
            "targetGrade": "2",
            "courseCode": "ENG2001",
            "courseName": "영어작문",
            "professor": "Jane Doe",
            "credits": -1,  # ❌ 잘못된 학점
            "classTime": "월3,수3",
            "classroom": "2-201",
            "courseType": "교양필수",
            "campus": "서울",
            "college": "문과대학",
            "department": "영어영문학과",
            "notes": ""
        },
    ]

    validator = CourseValidator()
    valid, invalid = validator.validate_courses(test_courses)

    print("\n✅ Valid courses:")
    for course in valid:
        print(f"   - {course['courseCode']}: {course['courseName']}")

    print("\n❌ Invalid courses:")
    for item in invalid:
        print(f"   - Index {item['index']}: {item['error']}")
