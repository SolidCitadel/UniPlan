import '../../domain/entities/scenario.dart';
import '../dtos/scenario_dto.dart';

extension ScenarioDtoMapper on ScenarioDto {
  Scenario toDomain() => Scenario(
        id: id,
        name: name,
        description: description,
        parentId: parentId,
        timetableId: timetableId,
        failedCourseIds: failedCourseIds,
        children: children.map((c) => c.toDomain()).toList(),
      );
}
