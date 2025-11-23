import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  User? _currentUser;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final user = await _remoteDataSource.login(email, password);
    _currentUser = user;
    return user;
  }

  @override
  Future<User> signup(String email, String password, String name) async {
    final user = await _remoteDataSource.signup(email, password, name);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
