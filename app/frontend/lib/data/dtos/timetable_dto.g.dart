// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimetableDto _$TimetableDtoFromJson(Map<String, dynamic> json) =>
    _TimetableDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      openingYear: (json['openingYear'] as num).toInt(),
      semester: json['semester'] as String,
      excludedCourses:
          (json['excludedCourses'] as List<dynamic>?)
              ?.map(
                (e) => TimetableCourseDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => TimetableItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableDtoToJson(_TimetableDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'openingYear': instance.openingYear,
      'semester': instance.semester,
      'excludedCourses': instance.excludedCourses,
      'items': instance.items,
    };

_TimetableItemDto _$TimetableItemDtoFromJson(Map<String, dynamic> json) =>
    _TimetableItemDto(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      professor: json['professor'] as String,
      classroom: json['classroom'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map((e) => ClassTimeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableItemDtoToJson(_TimetableItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'classroom': instance.classroom,
      'classTimes': instance.classTimes,
    };

_ClassTimeDto _$ClassTimeDtoFromJson(Map<String, dynamic> json) =>
    _ClassTimeDto(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$ClassTimeDtoToJson(_ClassTimeDto instance) =>
    <String, dynamic>{
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

_TimetableCourseDto _$TimetableCourseDtoFromJson(Map<String, dynamic> json) =>
    _TimetableCourseDto(
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      professor: json['professor'] as String,
      classroom: json['classroom'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map((e) => ClassTimeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableCourseDtoToJson(_TimetableCourseDto instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'classroom': instance.classroom,
      'classTimes': instance.classTimes,
    };
