import 'package:freezed_annotation/freezed_annotation.dart';

import 'scenario_dto.dart';

part 'registration_dto.freezed.dart';
part 'registration_dto.g.dart';

enum RegistrationStatusDto {
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled
}

@freezed
abstract class RegistrationDto with _$RegistrationDto {
  const factory RegistrationDto({
    required int id,
    required int userId,
    required ScenarioDto startScenario,
    required ScenarioDto currentScenario,
    required RegistrationStatusDto status,
    @Default([]) List<int> succeededCourses,
    @Default([]) List<int> failedCourses,
    @Default([]) List<int> canceledCourses,
    @Default([]) List<RegistrationStepDto> steps,
  }) = _RegistrationDto;

  factory RegistrationDto.fromJson(Map<String, dynamic> json) => _$RegistrationDtoFromJson(json);
}

@freezed
abstract class RegistrationStepDto with _$RegistrationStepDto {
  const factory RegistrationStepDto({
    required int id,
    required int scenarioId,
    required String scenarioName,
    @Default([]) List<int> succeededCourses,
    @Default([]) List<int> failedCourses,
    @Default([]) List<int> canceledCourses,
    int? nextScenarioId,
    String? nextScenarioName,
    String? notes,
  }) = _RegistrationStepDto;

  factory RegistrationStepDto.fromJson(Map<String, dynamic> json) => _$RegistrationStepDtoFromJson(json);
}
