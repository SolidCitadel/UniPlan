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
  Future<User> login(String username, String password) async {
    final user = await _remoteDataSource.login(username, password);
    _currentUser = user;
    return user;
  }

  @override
  Future<User> signup(String username, String password, String email, String studentId, String department) async {
    final user = await _remoteDataSource.signup(username, password, email, studentId, department);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    // Clear token if implemented
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
