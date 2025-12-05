// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationStepImpl _$$RegistrationStepImplFromJson(
  Map<String, dynamic> json,
) => _$RegistrationStepImpl(
  id: (json['id'] as num).toInt(),
  scenarioId: (json['scenarioId'] as num).toInt(),
  scenarioName: json['scenarioName'] as String,
  succeededCourses:
      (json['succeededCourses'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  failedCourses:
      (json['failedCourses'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  canceledCourses:
      (json['canceledCourses'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  nextScenarioId: (json['nextScenarioId'] as num?)?.toInt(),
  nextScenarioName: json['nextScenarioName'] as String?,
  notes: json['notes'] as String?,
  timestamp: dateTimeFromJson(json['timestamp']),
);

Map<String, dynamic> _$$RegistrationStepImplToJson(
  _$RegistrationStepImpl instance,
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
  'timestamp': dateTimeToJson(instance.timestamp),
};

_$RegistrationImpl _$$RegistrationImplFromJson(Map<String, dynamic> json) =>
    _$RegistrationImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      startScenario: Scenario.fromJson(
        json['startScenario'] as Map<String, dynamic>,
      ),
      currentScenario: Scenario.fromJson(
        json['currentScenario'] as Map<String, dynamic>,
      ),
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      startedAt: dateTimeFromJson(json['startedAt']),
      completedAt: dateTimeFromJson(json['completedAt']),
      succeededCourses:
          (json['succeededCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      failedCourses:
          (json['failedCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      canceledCourses:
          (json['canceledCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => RegistrationStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RegistrationStep>[],
    );

Map<String, dynamic> _$$RegistrationImplToJson(_$RegistrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startScenario': instance.startScenario,
      'currentScenario': instance.currentScenario,
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'startedAt': dateTimeToJson(instance.startedAt),
      'completedAt': dateTimeToJson(instance.completedAt),
      'succeededCourses': instance.succeededCourses,
      'failedCourses': instance.failedCourses,
      'canceledCourses': instance.canceledCourses,
      'steps': instance.steps,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.inProgress: 'IN_PROGRESS',
  RegistrationStatus.completed: 'COMPLETED',
  RegistrationStatus.cancelled: 'CANCELLED',
};
