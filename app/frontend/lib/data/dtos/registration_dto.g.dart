// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegistrationDto _$RegistrationDtoFromJson(Map<String, dynamic> json) =>
    _RegistrationDto(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      startScenario: ScenarioDto.fromJson(
        json['startScenario'] as Map<String, dynamic>,
      ),
      currentScenario: ScenarioDto.fromJson(
        json['currentScenario'] as Map<String, dynamic>,
      ),
      status: $enumDecode(_$RegistrationStatusDtoEnumMap, json['status']),
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
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map(
                (e) => RegistrationStepDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RegistrationDtoToJson(_RegistrationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startScenario': instance.startScenario,
      'currentScenario': instance.currentScenario,
      'status': _$RegistrationStatusDtoEnumMap[instance.status]!,
      'succeededCourses': instance.succeededCourses,
      'failedCourses': instance.failedCourses,
      'canceledCourses': instance.canceledCourses,
      'steps': instance.steps,
    };

const _$RegistrationStatusDtoEnumMap = {
  RegistrationStatusDto.inProgress: 'IN_PROGRESS',
  RegistrationStatusDto.completed: 'COMPLETED',
  RegistrationStatusDto.cancelled: 'CANCELLED',
};

_RegistrationStepDto _$RegistrationStepDtoFromJson(Map<String, dynamic> json) =>
    _RegistrationStepDto(
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

Map<String, dynamic> _$RegistrationStepDtoToJson(
  _RegistrationStepDto instance,
) => <String, dynamic>{
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
