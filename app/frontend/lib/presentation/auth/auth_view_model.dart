import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, User?>(
  AuthViewModel.new,
);

class AuthViewModel extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Session restoration handled by authStatusProvider; keep null here.
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(email: email, password: password);
    });
  }

  Future<void> signup(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signup(email: email, password: password, name: name);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}
