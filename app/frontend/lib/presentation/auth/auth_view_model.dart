import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/user_preferences.dart';
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

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(email, password);
    });
  }

  Future<void> signup(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signup(email, password, name);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    await ref.read(userPreferencesProvider).clear();
    state = const AsyncValue.data(null);
  }
}
