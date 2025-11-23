import '../../domain/entities/timetable.dart';
import '../dtos/timetable_dto.dart';

extension TimetableDtoMapper on TimetableDto {
  Timetable toDomain() => Timetable(
        id: id,
        name: name,
        openingYear: openingYear,
        semester: semester,
        excludedCourses: excludedCourses.map((c) => c.toDomain()).toList(),
        items: items.map((e) => e.toDomain()).toList(),
      );
}

extension TimetableItemDtoMapper on TimetableItemDto {
  TimetableItem toDomain() => TimetableItem(
        id: id,
        courseId: courseId,
        courseName: courseName,
        professor: professor,
        classroom: classroom,
        classTimes: classTimes.map((e) => e.toDomain()).toList(),
      );
}

extension TimetableClassTimeDtoMapper on ClassTimeDto {
  ClassTime toDomain() => ClassTime(
        day: day,
        startTime: startTime,
        endTime: endTime,
      );
}

extension TimetableCourseDtoMapper on TimetableCourseDto {
  TimetableCourse toDomain() => TimetableCourse(
        courseId: courseId,
        courseName: courseName,
        professor: professor,
        classroom: classroom,
        classTimes: classTimes.map((c) => c.toDomain()).toList(),
      );
}
