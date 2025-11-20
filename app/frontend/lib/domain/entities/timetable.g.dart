// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timetable _$TimetableFromJson(Map<String, dynamic> json) => _Timetable(
  id: json['id'] as String,
  name: json['name'] as String,
  courses: (json['courses'] as List<dynamic>)
      .map((e) => Course.fromJson(e as Map<String, dynamic>))
      .toList(),
  parentId: json['parentId'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$TimetableToJson(_Timetable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'courses': instance.courses,
      'parentId': instance.parentId,
      'childIds': instance.childIds,
    };
