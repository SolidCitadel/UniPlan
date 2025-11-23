import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scenario.dart';
import '../../domain/repositories/scenario_repository.dart';
import '../datasources/scenario_remote_data_source.dart';
import '../mappers/scenario_mapper.dart';

final scenarioRepositoryProvider = Provider<ScenarioRepository>((ref) {
  return ScenarioRepositoryImpl(ref.watch(scenarioRemoteDataSourceProvider));
});

class ScenarioRepositoryImpl implements ScenarioRepository {
  ScenarioRepositoryImpl(this._remote);

  final ScenarioRemoteDataSource _remote;

  @override
  Future<List<Scenario>> getScenarios() async {
    final dtos = await _remote.getScenarios();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Scenario> createScenario({
    required String name,
    String? description,
    required int timetableId,
  }) async {
    final dto = await _remote.createScenario(name: name, description: description, timetableId: timetableId);
    return dto.toDomain();
  }

  @override
  Future<Scenario> createAlternative({
    required int parentScenarioId,
    required String name,
    String? description,
    required int timetableId,
    required List<int> excludedCourseIds,
  }) async {
    final dto = await _remote.createAlternative(
      parentScenarioId: parentScenarioId,
      name: name,
      description: description,
      timetableId: timetableId,
      excludedCourseIds: excludedCourseIds,
    );
    return dto.toDomain();
  }

  @override
  Future<Scenario> getScenario(int id) async {
    final dto = await _remote.getScenario(id);
    return dto.toDomain();
  }
}
