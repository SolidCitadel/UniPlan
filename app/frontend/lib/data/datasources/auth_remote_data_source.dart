import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/token_storage.dart';
import '../../core/network/dio_provider.dart';
import '../../domain/entities/user.dart';
import '../../core/errors/auth_exception.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.watch(dioProvider),
    ref.watch(tokenStorageProvider),
  );
});

class AuthRemoteDataSource {
  // ignore: unused_field
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRemoteDataSource(this._dio, this._tokenStorage);

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.authLogin,
        data: {'email': email, 'password': password},
      );
      
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      await _tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);

      return await _fetchUserProfile(accessToken);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  Future<User> signup(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        ApiConstants.authSignup,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      await _tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);

      return await _fetchUserProfile(accessToken);
    } on DioException catch (e) {
      // print('Signup DioError: ${e.message}');
      if (e.response != null) {
        // print('Signup Response Status: ${e.response?.statusCode}');
        // print('Signup Response Data: ${e.response?.data}');
      }
      throw _handleDioError(e);
    } catch (e) {
      // print('Signup Error: $e');
      throw AuthException('Signup failed: $e');
    }
  }

  AuthException _handleDioError(DioException e) {
    // print('Handling DioError: ${e.type}, ${e.message}');
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      // print('Error Data: $data');
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ?? 'Authentication failed';
        final validationErrors = data['validationErrors'] != null
            ? Map<String, String>.from(data['validationErrors'])
            : null;
        return AuthException(message, validationErrors: validationErrors);
      }
    }
    return AuthException(e.message ?? 'Network error occurred');
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  Future<User> _fetchUserProfile(String accessToken) async {
    try {
      final response = await _dio.get(
        ApiConstants.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
