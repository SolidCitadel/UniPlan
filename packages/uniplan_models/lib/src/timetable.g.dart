// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClassTimeImpl _$$ClassTimeImplFromJson(Map<String, dynamic> json) =>
    _$ClassTimeImpl(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$$ClassTimeImplToJson(_$ClassTimeImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

_$TimetableItemImpl _$$TimetableItemImplFromJson(Map<String, dynamic> json) =>
    _$TimetableItemImpl(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseCode: json['courseCode'] as String?,
      courseName: json['courseName'] as String?,
      professor: json['professor'] as String?,
      credits: (json['credits'] as num?)?.toInt(),
      classroom: json['classroom'] as String?,
      campus: json['campus'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map((e) => ClassTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ClassTime>[],
      addedAt: dateTimeFromJson(json['addedAt']),
    );

Map<String, dynamic> _$$TimetableItemImplToJson(_$TimetableItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'credits': instance.credits,
      'classroom': instance.classroom,
      'campus': instance.campus,
      'classTimes': instance.classTimes,
      'addedAt': dateTimeToJson(instance.addedAt),
    };

_$TimetableCourseImpl _$$TimetableCourseImplFromJson(
  Map<String, dynamic> json,
) => _$TimetableCourseImpl(
  courseId: (json['courseId'] as num).toInt(),
  courseCode: json['courseCode'] as String?,
  courseName: json['courseName'] as String?,
  professor: json['professor'] as String?,
  credits: (json['credits'] as num?)?.toInt(),
  classroom: json['classroom'] as String?,
  campus: json['campus'] as String?,
  classTimes:
      (json['classTimes'] as List<dynamic>?)
          ?.map((e) => ClassTime.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ClassTime>[],
);

Map<String, dynamic> _$$TimetableCourseImplToJson(
  _$TimetableCourseImpl instance,
) => <String, dynamic>{
  'courseId': instance.courseId,
  'courseCode': instance.courseCode,
  'courseName': instance.courseName,
  'professor': instance.professor,
  'credits': instance.credits,
  'classroom': instance.classroom,
  'campus': instance.campus,
  'classTimes': instance.classTimes,
};

_$TimetableImpl _$$TimetableImplFromJson(Map<String, dynamic> json) =>
    _$TimetableImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String,
      openingYear: (json['openingYear'] as num).toInt(),
      semester: json['semester'] as String,
      createdAt: dateTimeFromJson(json['createdAt']),
      updatedAt: dateTimeFromJson(json['updatedAt']),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => TimetableItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TimetableItem>[],
      excludedCourses:
          (json['excludedCourses'] as List<dynamic>?)
              ?.map((e) => TimetableCourse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TimetableCourse>[],
    );

Map<String, dynamic> _$$TimetableImplToJson(_$TimetableImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'openingYear': instance.openingYear,
      'semester': instance.semester,
      'createdAt': dateTimeToJson(instance.createdAt),
      'updatedAt': dateTimeToJson(instance.updatedAt),
      'items': instance.items,
      'excludedCourses': instance.excludedCourses,
    };
