import '../../domain/entities/scenario.dart';
import '../dtos/scenario_dto.dart';
import 'timetable_mapper.dart';

extension ScenarioDtoMapper on ScenarioDto {
  Scenario toDomain() => Scenario(
        id: id,
        name: name,
        description: description,
        parentId: parentId,
        timetableId: timetableId,
        timetable: timetable.toDomain(),
        failedCourseIds: failedCourseIds,
        children: children.map((c) => c.toDomain()).toList(),
      );
}
