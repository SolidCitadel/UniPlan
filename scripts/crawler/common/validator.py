"""
Common validation for crawled course data.
"""
from typing import Dict, Tuple, List


class CourseValidator:
    """Course data validator."""

    REQUIRED_FIELDS = ['courseCode', 'courseName', 'credits', 'openingYear', 'semester', 'universityId']

    @classmethod
    def validate_course(cls, course: Dict) -> Tuple[bool, str]:
        """
        Validate a single course.

        Args:
            course: Course data to validate

        Returns:
            (is_valid, error_message)
        """
        # 1. Check required fields
        for field in cls.REQUIRED_FIELDS:
            if field not in course:
                return False, f"Missing required field: {field}"

            value = course[field]
            if value is None or (isinstance(value, str) and not value.strip()):
                return False, f"Empty required field: {field}"

        # 2. Validate credits
        credits = course['credits']
        if not isinstance(credits, int) or credits <= 0:
            return False, f"Invalid credits: {credits} (must be positive integer)"

        # 3. Validate year
        year = course['openingYear']
        if not isinstance(year, int) or year < 2000 or year > 2100:
            return False, f"Invalid year: {year}"

        # 4. Validate universityId
        university_id = course['universityId']
        if not isinstance(university_id, int) or university_id <= 0:
            return False, f"Invalid universityId: {university_id}"

        return True, "Valid"

    @classmethod
    def validate_courses(cls, courses: List[Dict], verbose: bool = True) -> Tuple[List[Dict], List[Dict]]:
        """
        Validate multiple courses.

        Args:
            courses: List of courses to validate
            verbose: Print validation results

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
                    print(f"Invalid course at index {idx}: {message}")
                    print(f"   Data: {course.get('courseCode', 'N/A')} - {course.get('courseName', 'N/A')}")

        if verbose:
            print(f"\nValidation Summary:")
            print(f"   Valid: {len(valid_courses)}")
            print(f"   Invalid: {len(invalid_courses)}")
            if courses:
                print(f"   Success rate: {len(valid_courses) / len(courses) * 100:.1f}%")

        return valid_courses, invalid_courses
