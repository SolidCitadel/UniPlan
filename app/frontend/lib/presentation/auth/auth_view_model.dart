import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authStateProvider = AsyncNotifierProvider<AuthViewModel, User?>(() {
  return AuthViewModel();
});

class AuthViewModel extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return null;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(username, password);
    });
  }

  Future<void> signup(String username, String password, String email, String studentId, String department) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signup(username, password, email, studentId, department);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}
