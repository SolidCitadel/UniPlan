// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timetable _$TimetableFromJson(Map<String, dynamic> json) => _Timetable(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  name: json['name'] as String,
  openingYear: (json['openingYear'] as num).toInt(),
  semester: json['semester'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => TimetableItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  excludedCourseIds:
      (json['excludedCourseIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$TimetableToJson(_Timetable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'openingYear': instance.openingYear,
      'semester': instance.semester,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'items': instance.items,
      'excludedCourseIds': instance.excludedCourseIds,
    };

_TimetableItem _$TimetableItemFromJson(Map<String, dynamic> json) =>
    _TimetableItem(
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
          const [],
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$TimetableItemToJson(_TimetableItem instance) =>
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
      'addedAt': instance.addedAt?.toIso8601String(),
    };
