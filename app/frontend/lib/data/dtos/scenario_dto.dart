import 'package:freezed_annotation/freezed_annotation.dart';
import 'timetable_dto.dart';

part 'scenario_dto.freezed.dart';
part 'scenario_dto.g.dart';

@freezed
abstract class ScenarioDto with _$ScenarioDto {
  const factory ScenarioDto({
    required int id,
    required String name,
    String? description,
    int? parentId,
    required int timetableId,
    required TimetableDto timetable,
    @Default([]) List<int> failedCourseIds,
    @Default([]) List<ScenarioDto> children,
  }) = _ScenarioDto;

  factory ScenarioDto.fromJson(Map<String, dynamic> json) => _$ScenarioDtoFromJson(json);
}
