// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Course _$CourseFromJson(Map<String, dynamic> json) => _Course(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  professor: json['professor'] as String,
  credits: (json['credits'] as num).toInt(),
  time: json['time'] as String,
  room: json['room'] as String,
  campus: json['campus'] as String,
  department: json['department'] as String,
  courseType: json['courseType'] as String,
);

Map<String, dynamic> _$CourseToJson(_Course instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'professor': instance.professor,
  'credits': instance.credits,
  'time': instance.time,
  'room': instance.room,
  'campus': instance.campus,
  'department': instance.department,
  'courseType': instance.courseType,
};
