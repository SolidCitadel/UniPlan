import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scenario.dart';
import '../../data/repositories/scenario_repository_impl.dart';

final scenarioDetailViewModelProvider =
    AsyncNotifierProvider.family<ScenarioDetailViewModel, Scenario?, int>(ScenarioDetailViewModel.new);

class ScenarioDetailViewModel extends AsyncNotifier<Scenario?> {
  final int scenarioId;

  ScenarioDetailViewModel(this.scenarioId);

  @override
  Future<Scenario?> build() async {
    return _fetch();
  }

  Future<Scenario?> _fetch() async {
    return ref.read(scenarioRepositoryProvider).getScenario(scenarioId);
  }

  Future<Scenario?> createAlternative({
    required String name,
    String? description,
    required int timetableId,
    required List<int> excludedCourseIds,
  }) async {
    final created = await ref.read(scenarioRepositoryProvider).createAlternative(
          parentScenarioId: scenarioId,
          name: name,
          description: description,
          timetableId: timetableId,
          excludedCourseIds: excludedCourseIds,
        );
    state = await AsyncValue.guard(_fetch);
    return created;
  }
}
