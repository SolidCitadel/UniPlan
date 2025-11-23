import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds environment-dependent API configuration.
class ApiConfig {
  ApiConfig({
    required this.baseUrl,
    required this.flavor,
  });

  final String baseUrl;
  final String flavor;

  factory ApiConfig.fromEnv() {
    // Use dart-define to inject BASE_URL/FLAVOR. Provide sensible defaults for local dev.
    const baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8080');
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    return ApiConfig(baseUrl: baseUrl, flavor: flavor);
  }
}

final apiConfigProvider = Provider<ApiConfig>((ref) {
  throw UnimplementedError('apiConfigProvider must be overridden in main.dart');
});
