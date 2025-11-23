import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // Add auth interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Get token from storage
          final token = await tokenStorage.getAccessToken();
          
          // Add Authorization header if token exists
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          // If getting token fails, just continue without it
          // This allows non-authenticated requests to proceed
        }
        
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized errors
        if (error.response?.statusCode == 401) {
          // Token might be expired
          // For now, just log and pass error through
          print('401 Unauthorized - Token may be expired');
        }
        
        // Log all errors for debugging
        print('API Error: ${error.message}');
        if (error.response != null) {
          print('Status: ${error.response?.statusCode}');
          print('Data: ${error.response?.data}');
        }
        
        return handler.next(error);
      },
    ),
  );

  return dio;
});

