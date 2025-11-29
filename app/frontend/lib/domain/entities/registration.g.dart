// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Registration _$RegistrationFromJson(Map<String, dynamic> json) =>
    _Registration(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      startScenario: Scenario.fromJson(
        json['startScenario'] as Map<String, dynamic>,
      ),
      currentScenario: Scenario.fromJson(
        json['currentScenario'] as Map<String, dynamic>,
      ),
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      succeededCourses: (json['succeededCourses'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      failedCourses: (json['failedCourses'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      canceledCourses: (json['canceledCourses'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => RegistrationStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RegistrationToJson(_Registration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startScenario': instance.startScenario,
      'currentScenario': instance.currentScenario,
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'succeededCourses': instance.succeededCourses,
      'failedCourses': instance.failedCourses,
      'canceledCourses': instance.canceledCourses,
      'steps': instance.steps,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.inProgress: 'inProgress',
  RegistrationStatus.completed: 'completed',
  RegistrationStatus.cancelled: 'cancelled',
};

_RegistrationStep _$RegistrationStepFromJson(Map<String, dynamic> json) =>
    _RegistrationStep(
      id: (json['id'] as num).toInt(),
      scenarioId: (json['scenarioId'] as num).toInt(),
      scenarioName: json['scenarioName'] as String,
      succeededCourses:
          (json['succeededCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      failedCourses:
          (json['failedCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      canceledCourses:
          (json['canceledCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      nextScenarioId: (json['nextScenarioId'] as num?)?.toInt(),
      nextScenarioName: json['nextScenarioName'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RegistrationStepToJson(_RegistrationStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scenarioId': instance.scenarioId,
      'scenarioName': instance.scenarioName,
      'succeededCourses': instance.succeededCourses,
      'failedCourses': instance.failedCourses,
      'canceledCourses': instance.canceledCourses,
      'nextScenarioId': instance.nextScenarioId,
      'nextScenarioName': instance.nextScenarioName,
      'notes': instance.notes,
    };
