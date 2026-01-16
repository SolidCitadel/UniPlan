"""
Output schema for course data.
This schema must match catalog-service's CourseImportRequest DTO.
"""
from dataclasses import dataclass, field, asdict
from typing import List, Optional


@dataclass
class ClassTimeSchema:
    """Class time slot."""
    day: str          # 월, 화, 수, 목, 금, 토, 일
    startTime: str    # HH:MM format
    endTime: str      # HH:MM format

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class CourseSchema:
    """
    Course data schema.
    Must match catalog-service's CourseImportRequest DTO.
    """
    # Required fields
    universityId: int
    openingYear: int
    semester: str           # "1", "2", etc.
    courseCode: str
    courseName: str
    credits: int
    courseTypeCode: str     # e.g., "04" for 전공필수

    # Optional fields
    section: str = ""
    targetGrade: Optional[str] = None
    professor: str = ""
    classroom: str = ""
    campus: str = ""
    notes: str = ""
    departmentCodes: List[str] = field(default_factory=list)
    classTime: List[ClassTimeSchema] = field(default_factory=list)

    def to_dict(self) -> dict:
        """Convert to dictionary for JSON serialization."""
        result = {
            'universityId': self.universityId,
            'openingYear': self.openingYear,
            'semester': self.semester,
            'courseCode': self.courseCode,
            'courseName': self.courseName,
            'credits': self.credits,
            'courseTypeCode': self.courseTypeCode,
            'section': self.section,
            'professor': self.professor,
            'classroom': self.classroom,
            'campus': self.campus,
            'notes': self.notes,
            'departmentCodes': self.departmentCodes,
            'classTime': [ct.to_dict() if isinstance(ct, ClassTimeSchema) else ct for ct in self.classTime],
        }
        if self.targetGrade is not None:
            result['targetGrade'] = self.targetGrade
        return result


@dataclass
class MetadataSchema:
    """
    Metadata schema for colleges, departments, and course types.
    """
    year: int
    semester: int
    colleges: dict      # code -> {name: str}
    departments: dict   # code -> {name: str, collegeCode: str}
    courseTypes: dict   # code -> {nameKr: str, nameEn: str}
