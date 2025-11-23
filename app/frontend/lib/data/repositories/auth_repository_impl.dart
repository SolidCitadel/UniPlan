import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session_provider.dart';
import '../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_remote_data_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(userRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(authStatusProvider.notifier),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authRemote,
    this._userRemote,
    this._tokenStorage,
    this._authStatusNotifier,
  );

  final AuthRemoteDataSource _authRemote;
  final UserRemoteDataSource _userRemote;
  final TokenStorage _tokenStorage;
  final AuthStatusNotifier _authStatusNotifier;

  @override
  Future<User> login({required String email, required String password}) async {
    final dto = await _authRemote.login(email: email, password: password);
    await _tokenStorage.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    _authStatusNotifier.setAuthenticated();
    return _userRemote.me();
  }

  @override
  Future<User> signup({required String email, required String password, required String name}) async {
    final dto = await _authRemote.signup(email: email, password: password, name: name);
    await _tokenStorage.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    _authStatusNotifier.setAuthenticated();
    return _userRemote.me();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    await _authStatusNotifier.logout();
  }
}
