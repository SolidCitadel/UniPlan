import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/user.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)));
});

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<User> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.authLogin,
        data: {'username': username, 'password': password},
      );
      // Assuming the API returns the user object directly or in a 'data' field
      // Adjust based on actual API response structure
      return User.fromJson(response.data); 
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> signup(String username, String password, String email, String studentId, String department) async {
    try {
      final response = await _dio.post(
        ApiConstants.authSignup,
        data: {
          'username': username,
          'password': password,
          'email': email,
          'studentId': studentId,
          'department': department,
        },
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}
