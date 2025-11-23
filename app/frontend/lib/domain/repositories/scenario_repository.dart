import '../entities/scenario.dart';

abstract class ScenarioRepository {
  Future<List<Scenario>> getScenarios();
  Future<Scenario> createScenario({
    required String name,
    String? description,
    required int timetableId,
  });
  Future<Scenario> createAlternative({
    required int parentScenarioId,
    required String name,
    String? description,
    required int timetableId,
    required List<int> excludedCourseIds,
  });
  Future<Scenario> getScenario(int id);
}
