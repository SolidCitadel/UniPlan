import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/auth_dto.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final resp = await _dio.post(
      ApiEndpoints.authLogin,
      data: {'email': email, 'password': password},
    );
    return AuthResponseDto.fromJson(resp.data);
  }

  Future<AuthResponseDto> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final resp = await _dio.post(
      ApiEndpoints.authSignup,
      data: {'email': email, 'password': password, 'name': name},
    );
    return AuthResponseDto.fromJson(resp.data);
  }
}
