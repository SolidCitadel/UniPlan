import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'timetable.dart';

part 'requests.freezed.dart';
part 'requests.g.dart';

@freezed
class CreateTimetableRequest with _$CreateTimetableRequest {
  const factory CreateTimetableRequest({
    required String name,
    required int openingYear,
    required String semester,
  }) = _CreateTimetableRequest;

  factory CreateTimetableRequest.fromJson(Map<String, dynamic> json) => _$CreateTimetableRequestFromJson(json);
}

@freezed
class CreateAlternativeTimetableRequest with _$CreateAlternativeTimetableRequest {
  const factory CreateAlternativeTimetableRequest({
    required String name,
    @Default(<int>{}) @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson) Set<int> excludedCourseIds,
  }) = _CreateAlternativeTimetableRequest;

  factory CreateAlternativeTimetableRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAlternativeTimetableRequestFromJson(json);
}

@freezed
class CreateScenarioRequest with _$CreateScenarioRequest {
  const factory CreateScenarioRequest({
    required String name,
    String? description,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
  }) = _CreateScenarioRequest;

  factory CreateScenarioRequest.fromJson(Map<String, dynamic> json) => _$CreateScenarioRequestFromJson(json);
}

@freezed
class CreateAlternativeScenarioRequest with _$CreateAlternativeScenarioRequest {
  const factory CreateAlternativeScenarioRequest({
    required String name,
    String? description,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson) @Default(<int>{}) Set<int> failedCourseIds,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
    int? orderIndex,
  }) = _CreateAlternativeScenarioRequest;

  factory CreateAlternativeScenarioRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAlternativeScenarioRequestFromJson(json);
}

@freezed
class StartRegistrationRequest with _$StartRegistrationRequest {
  const factory StartRegistrationRequest({
    required int scenarioId,
  }) = _StartRegistrationRequest;

  factory StartRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$StartRegistrationRequestFromJson(json);
}
