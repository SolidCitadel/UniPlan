// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTimetableRequestImpl _$$CreateTimetableRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateTimetableRequestImpl(
  name: json['name'] as String,
  openingYear: (json['openingYear'] as num).toInt(),
  semester: json['semester'] as String,
);

Map<String, dynamic> _$$CreateTimetableRequestImplToJson(
  _$CreateTimetableRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'openingYear': instance.openingYear,
  'semester': instance.semester,
};

_$CreateAlternativeTimetableRequestImpl
_$$CreateAlternativeTimetableRequestImplFromJson(Map<String, dynamic> json) =>
    _$CreateAlternativeTimetableRequestImpl(
      name: json['name'] as String,
      excludedCourseIds: json['excludedCourseIds'] == null
          ? const <int>{}
          : intSetFromJson(json['excludedCourseIds'] as List?),
    );

Map<String, dynamic> _$$CreateAlternativeTimetableRequestImplToJson(
  _$CreateAlternativeTimetableRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'excludedCourseIds': intSetToJson(instance.excludedCourseIds),
};

_$CreateScenarioRequestImpl _$$CreateScenarioRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateScenarioRequestImpl(
  name: json['name'] as String,
  description: json['description'] as String?,
  timetableRequest: json['timetableRequest'] == null
      ? null
      : CreateTimetableRequest.fromJson(
          json['timetableRequest'] as Map<String, dynamic>,
        ),
  existingTimetableId: (json['existingTimetableId'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CreateScenarioRequestImplToJson(
  _$CreateScenarioRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'timetableRequest': instance.timetableRequest,
  'existingTimetableId': instance.existingTimetableId,
};

_$CreateAlternativeScenarioRequestImpl
_$$CreateAlternativeScenarioRequestImplFromJson(Map<String, dynamic> json) =>
    _$CreateAlternativeScenarioRequestImpl(
      name: json['name'] as String,
      description: json['description'] as String?,
      failedCourseIds: json['failedCourseIds'] == null
          ? const <int>{}
          : intSetFromJson(json['failedCourseIds'] as List?),
      timetableRequest: json['timetableRequest'] == null
          ? null
          : CreateTimetableRequest.fromJson(
              json['timetableRequest'] as Map<String, dynamic>,
            ),
      existingTimetableId: (json['existingTimetableId'] as num?)?.toInt(),
      orderIndex: (json['orderIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CreateAlternativeScenarioRequestImplToJson(
  _$CreateAlternativeScenarioRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'failedCourseIds': intSetToJson(instance.failedCourseIds),
  'timetableRequest': instance.timetableRequest,
  'existingTimetableId': instance.existingTimetableId,
  'orderIndex': instance.orderIndex,
};

_$StartRegistrationRequestImpl _$$StartRegistrationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$StartRegistrationRequestImpl(
  scenarioId: (json['scenarioId'] as num).toInt(),
);

Map<String, dynamic> _$$StartRegistrationRequestImplToJson(
  _$StartRegistrationRequestImpl instance,
) => <String, dynamic>{'scenarioId': instance.scenarioId};
