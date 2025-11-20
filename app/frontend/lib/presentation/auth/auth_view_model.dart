import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authStateProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  return AuthViewModel(ref);
});

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthViewModel(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(authRepositoryProvider).login(username, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String username, String password, String email, String studentId, String department) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(authRepositoryProvider).signup(username, password, email, studentId, department);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}
