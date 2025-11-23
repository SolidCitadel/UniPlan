import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_provider.dart';
import '../config/api_config.dart';
import '../storage/token_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final api = ref.watch(apiConfigProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final authNotifier = ref.watch(authStatusProvider.notifier);

  final dio = Dio(
    BaseOptions(
      baseUrl: api.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;

        if (status == 401) {
          // No refresh endpoint in backend yet; clear session and force logout.
          await tokenStorage.clearTokens();
          await authNotifier.logout();
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
