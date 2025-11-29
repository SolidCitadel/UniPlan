import '../../domain/entities/registration.dart';
import '../dtos/registration_dto.dart';
import 'scenario_mapper.dart';

extension RegistrationDtoMapper on RegistrationDto {
  Registration toDomain() => Registration(
        id: id,
        userId: userId,
        startScenario: startScenario.toDomain(),
        currentScenario: currentScenario.toDomain(),
        status: status.toDomain(),
        succeededCourses: succeededCourses,
        failedCourses: failedCourses,
        canceledCourses: canceledCourses,
        steps: steps.map((s) => s.toDomain()).toList(),
      );
}

extension RegistrationStepDtoMapper on RegistrationStepDto {
  RegistrationStep toDomain() => RegistrationStep(
        id: id,
        scenarioId: scenarioId,
        scenarioName: scenarioName,
        succeededCourses: succeededCourses,
        failedCourses: failedCourses,
        canceledCourses: canceledCourses,
        nextScenarioId: nextScenarioId,
        nextScenarioName: nextScenarioName,
        notes: notes,
      );
}

extension RegistrationStatusDtoMapper on RegistrationStatusDto {
  RegistrationStatus toDomain() {
    switch (this) {
      case RegistrationStatusDto.inProgress:
        return RegistrationStatus.inProgress;
      case RegistrationStatusDto.completed:
        return RegistrationStatus.completed;
      case RegistrationStatusDto.cancelled:
        return RegistrationStatus.cancelled;
    }
  }
}
