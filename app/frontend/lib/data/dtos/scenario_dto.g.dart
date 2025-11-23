// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScenarioDto _$ScenarioDtoFromJson(Map<String, dynamic> json) => _ScenarioDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  parentId: (json['parentId'] as num?)?.toInt(),
  timetableId: (json['timetableId'] as num).toInt(),
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ScenarioDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ScenarioDtoToJson(_ScenarioDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'parentId': instance.parentId,
      'timetableId': instance.timetableId,
      'children': instance.children,
    };
