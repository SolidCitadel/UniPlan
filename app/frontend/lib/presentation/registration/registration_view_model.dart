import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/registration.dart';
import '../../data/repositories/registration_repository_impl.dart';

final registrationViewModelProvider =
    AsyncNotifierProvider<RegistrationViewModel, Registration?>(RegistrationViewModel.new);

class RegistrationViewModel extends AsyncNotifier<Registration?> {
  @override
  Future<Registration?> build() async {
    return null;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(registrationRepositoryProvider).getCurrent());
  }

  Future<Registration?> start(int scenarioId) async {
    try {
      final created = await ref.read(registrationRepositoryProvider).start(scenarioId);
      state = AsyncValue.data(created);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Registration?> addStep({
    required List<int> succeeded,
    required List<int> failed,
    required List<int> canceled,
  }) async {
    final current = state.value;
    if (current == null) return null;
    try {
      final updated = await ref.read(registrationRepositoryProvider).addStep(
            registrationId: current.id,
            succeeded: succeeded,
            failed: failed,
            canceled: canceled,
          );
      state = AsyncValue.data(updated);
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> loadById(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(registrationRepositoryProvider).getById(id));
  }

  void clear() {
    state = const AsyncValue.data(null);
  }

  Future<Registration?> complete() async {
    final current = state.value;
    if (current == null) return null;
    final updated = await ref.read(registrationRepositoryProvider).complete(current.id);
    state = AsyncValue.data(updated);
    return updated;
  }

  Future<Registration?> cancel() async {
    final current = state.value;
    if (current == null) return null;
    final updated = await ref.read(registrationRepositoryProvider).cancel(current.id);
    state = AsyncValue.data(updated);
    return updated;
  }

  Future<void> delete() async {
    final current = state.value;
    if (current == null) return;
    await ref.read(registrationRepositoryProvider).delete(current.id);
    state = const AsyncValue.data(null);
  }
}
