import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/registration.dart';
import '../../data/repositories/registration_repository_impl.dart';

final registrationListViewModelProvider =
    AsyncNotifierProvider<RegistrationListViewModel, List<Registration>>(RegistrationListViewModel.new);

class RegistrationListViewModel extends AsyncNotifier<List<Registration>> {
  @override
  Future<List<Registration>> build() async {
    return _fetch();
  }

  Future<List<Registration>> _fetch() async {
    return ref.read(registrationRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }
}
