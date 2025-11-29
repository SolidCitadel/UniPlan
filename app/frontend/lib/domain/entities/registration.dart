import 'package:freezed_annotation/freezed_annotation.dart';

import 'scenario.dart';

part 'registration.freezed.dart';
part 'registration.g.dart';

enum RegistrationStatus { inProgress, completed, cancelled }

@freezed
abstract class Registration with _$Registration {
  const factory Registration({
    required int id,
    required int userId,
    required Scenario startScenario,
    required Scenario currentScenario,
    required RegistrationStatus status,
    required List<int> succeededCourses,
    required List<int> failedCourses,
    required List<int> canceledCourses,
    @Default([]) List<RegistrationStep> steps,
  }) = _Registration;

  factory Registration.fromJson(Map<String, dynamic> json) => _$RegistrationFromJson(json);
}

@freezed
abstract class RegistrationStep with _$RegistrationStep {
  const factory RegistrationStep({
    required int id,
    required int scenarioId,
    required String scenarioName,
    @Default([]) List<int> succeededCourses,
    @Default([]) List<int> failedCourses,
    @Default([]) List<int> canceledCourses,
    int? nextScenarioId,
    String? nextScenarioName,
    String? notes,
  }) = _RegistrationStep;

  factory RegistrationStep.fromJson(Map<String, dynamic> json) => _$RegistrationStepFromJson(json);
}
