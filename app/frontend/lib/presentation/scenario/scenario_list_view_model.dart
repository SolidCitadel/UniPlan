import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scenario.dart';
import '../../data/repositories/scenario_repository_impl.dart';

final scenarioListViewModelProvider = AsyncNotifierProvider<ScenarioListViewModel, List<Scenario>>(
  ScenarioListViewModel.new,
);

class ScenarioListViewModel extends AsyncNotifier<List<Scenario>> {
  @override
  Future<List<Scenario>> build() async {
    return _fetch();
  }

  Future<List<Scenario>> _fetch() async {
    return ref.read(scenarioRepositoryProvider).getScenarios();
  }

  Future<Scenario?> create({
    required String name,
    String? description,
    required int timetableId,
  }) async {
    try {
      final created = await ref
          .read(scenarioRepositoryProvider)
          .createScenario(name: name, description: description, timetableId: timetableId);
      state = await AsyncValue.guard(_fetch);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }
}
