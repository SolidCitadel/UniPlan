import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'timetable.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

@freezed
class Scenario with _$Scenario {
  const factory Scenario({
    required int id,
    int? userId,
    required String name,
    String? description,
    @JsonKey(name: 'parentScenarioId') int? parentScenarioId,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson) @Default(<int>{}) Set<int> failedCourseIds,
    int? orderIndex,
    required Timetable timetable,
    @Default(<Scenario>[]) List<Scenario> childScenarios,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? updatedAt,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);
}
