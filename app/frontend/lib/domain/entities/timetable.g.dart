// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timetable _$TimetableFromJson(Map<String, dynamic> json) => _Timetable(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  openingYear: (json['openingYear'] as num).toInt(),
  semester: json['semester'] as String,
  excludedCourses:
      (json['excludedCourses'] as List<dynamic>?)
          ?.map((e) => TimetableCourse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => TimetableItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TimetableToJson(_Timetable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'openingYear': instance.openingYear,
      'semester': instance.semester,
      'excludedCourses': instance.excludedCourses,
      'items': instance.items,
    };

_TimetableItem _$TimetableItemFromJson(Map<String, dynamic> json) =>
    _TimetableItem(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      professor: json['professor'] as String,
      classroom: json['classroom'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map((e) => ClassTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableItemToJson(_TimetableItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'classroom': instance.classroom,
      'classTimes': instance.classTimes,
    };

_ClassTime _$ClassTimeFromJson(Map<String, dynamic> json) => _ClassTime(
  day: json['day'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$ClassTimeToJson(_ClassTime instance) =>
    <String, dynamic>{
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

_TimetableCourse _$TimetableCourseFromJson(Map<String, dynamic> json) =>
    _TimetableCourse(
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      professor: json['professor'] as String,
      classroom: json['classroom'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map((e) => ClassTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableCourseToJson(_TimetableCourse instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'classroom': instance.classroom,
      'classTimes': instance.classTimes,
    };
