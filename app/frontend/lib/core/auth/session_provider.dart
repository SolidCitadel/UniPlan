import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthStatusNotifier extends AsyncNotifier<AuthStatus> {
  @override
  Future<AuthStatus> build() async {
    final tokenStorage = ref.watch(tokenStorageProvider);
    final hasToken = await tokenStorage.hasAccessToken();
    return hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> setAuthenticated() async {
    state = const AsyncValue.data(AuthStatus.authenticated);
  }

  Future<void> logout() async {
    final tokenStorage = ref.watch(tokenStorageProvider);
    await tokenStorage.clearTokens();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }
}

final authStatusProvider = AsyncNotifierProvider<AuthStatusNotifier, AuthStatus>(
  AuthStatusNotifier.new,
);
