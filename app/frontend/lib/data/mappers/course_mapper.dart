import '../../domain/entities/course.dart';
import '../dtos/course_dto.dart';
import '../dtos/page_dto.dart';
import '../../domain/entities/page.dart';

extension CourseDtoMapper on CourseDto {
  Course toDomain() => Course(
        id: id,
        openingYear: openingYear,
        semester: semester,
        courseCode: courseCode,
        section: section,
        courseName: courseName,
        professor: professor,
        credits: credits,
        classroom: classroom,
        campus: campus,
        departmentCode: departmentCode,
        departmentName: departmentName,
        collegeCode: collegeCode,
        collegeName: collegeName,
        classTimes: classTimes.map((e) => e.toDomain()).toList(),
      );
}

extension ClassTimeDtoMapper on ClassTimeDto {
  ClassTime toDomain() => ClassTime(
        day: day,
        startTime: startTime,
        endTime: endTime,
      );
}

extension PageCourseDtoMapper on PageDto<CourseDto> {
  PageEnvelope<Course> toDomain() => PageEnvelope<Course>(
        content: content.map((e) => e.toDomain()).toList(),
        totalElements: totalElements,
        totalPages: totalPages,
        size: size,
        number: number,
      );
}
