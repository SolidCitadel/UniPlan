import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'scenario.dart';

part 'registration.freezed.dart';
part 'registration.g.dart';

@JsonEnum()
enum RegistrationStatus {
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

@freezed
class RegistrationStep with _$RegistrationStep {
  const factory RegistrationStep({
    required int id,
    required int scenarioId,
    required String scenarioName,
    @Default(<int>[]) List<int> succeededCourses,
    @Default(<int>[]) List<int> failedCourses,
    @Default(<int>[]) List<int> canceledCourses,
    int? nextScenarioId,
    String? nextScenarioName,
    String? notes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? timestamp,
  }) = _RegistrationStep;

  factory RegistrationStep.fromJson(Map<String, dynamic> json) => _$RegistrationStepFromJson(json);
}

@freezed
class Registration with _$Registration {
  const factory Registration({
    required int id,
    required int userId,
    required Scenario startScenario,
    required Scenario currentScenario,
    required RegistrationStatus status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? startedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? completedAt,
    @Default(<int>[]) List<int> succeededCourses,
    @Default(<int>[]) List<int> failedCourses,
    @Default(<int>[]) List<int> canceledCourses,
    @Default(<RegistrationStep>[]) List<RegistrationStep> steps,
  }) = _Registration;

  factory Registration.fromJson(Map<String, dynamic> json) => _$RegistrationFromJson(json);
}
