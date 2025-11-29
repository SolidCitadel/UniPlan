import 'package:freezed_annotation/freezed_annotation.dart';

import 'timetable.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

@freezed
abstract class Scenario with _$Scenario {
  const factory Scenario({
    required int id,
    required String name,
    String? description,
    int? parentId,
    required int timetableId,
    required Timetable timetable,
    @Default([]) List<int> failedCourseIds,
    @Default([]) List<Scenario> children,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);
}
