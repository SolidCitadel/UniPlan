// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Scenario _$ScenarioFromJson(Map<String, dynamic> json) => _Scenario(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  parentId: (json['parentId'] as num?)?.toInt(),
  timetableId: (json['timetableId'] as num).toInt(),
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ScenarioToJson(_Scenario instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'parentId': instance.parentId,
  'timetableId': instance.timetableId,
  'children': instance.children,
};
