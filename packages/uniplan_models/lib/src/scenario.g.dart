// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScenarioImpl _$$ScenarioImplFromJson(Map<String, dynamic> json) =>
    _$ScenarioImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      parentScenarioId: (json['parentScenarioId'] as num?)?.toInt(),
      failedCourseIds: json['failedCourseIds'] == null
          ? const <int>{}
          : intSetFromJson(json['failedCourseIds'] as List?),
      orderIndex: (json['orderIndex'] as num?)?.toInt(),
      timetable: Timetable.fromJson(json['timetable'] as Map<String, dynamic>),
      childScenarios:
          (json['childScenarios'] as List<dynamic>?)
              ?.map((e) => Scenario.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Scenario>[],
      createdAt: dateTimeFromJson(json['createdAt']),
      updatedAt: dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ScenarioImplToJson(_$ScenarioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'parentScenarioId': instance.parentScenarioId,
      'failedCourseIds': intSetToJson(instance.failedCourseIds),
      'orderIndex': instance.orderIndex,
      'timetable': instance.timetable,
      'childScenarios': instance.childScenarios,
      'createdAt': dateTimeToJson(instance.createdAt),
      'updatedAt': dateTimeToJson(instance.updatedAt),
    };
