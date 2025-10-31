import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uniplan_cli/config.dart';
import 'package:uniplan_cli/utils/token_manager.dart';
import 'package:uniplan_cli/utils/output_formatter.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Config _config = Config();
  final TokenManager _tokenManager = TokenManager();

  Future<ApiResponse> get(String path, {bool requiresAuth = true}) async {
    return _request('GET', path, requiresAuth: requiresAuth);
  }

  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _request('POST', path, body: body, requiresAuth: requiresAuth);
  }

  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _request('PUT', path, body: body, requiresAuth: requiresAuth);
  }

  Future<ApiResponse> delete(String path, {bool requiresAuth = true}) async {
    return _request('DELETE', path, requiresAuth: requiresAuth);
  }

  Future<ApiResponse> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    // Check authentication
    if (requiresAuth) {
      await _tokenManager.load();
      if (!_tokenManager.isLoggedIn) {
        throw ApiException(401, 'Not logged in. Please run: uniplan auth login');
      }
    }

    // Build URL
    final url = Uri.parse('${_config.apiUrl}$path');

    // Build headers
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth && _tokenManager.accessToken != null) {
      headers['Authorization'] = 'Bearer ${_tokenManager.accessToken}';
    }

    // Print request details if requested
    if (_config.showDetails) {
      OutputFormatter.printHttpRequest(
        method,
        url.toString(),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    }

    try {
      // Send request
      late http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Print response details if requested
      if (_config.showDetails) {
        OutputFormatter.printHttpResponse(
          response.statusCode,
          response.body,
          headers: response.headers,
        );
      }

      // Parse response
      final apiResponse = ApiResponse(
        statusCode: response.statusCode,
        body: response.body,
      );

      // Handle errors
      if (response.statusCode >= 400) {
        final errorMessage = _extractErrorMessage(apiResponse);
        throw ApiException(response.statusCode, errorMessage);
      }

      return apiResponse;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(0, 'Network error: $e');
    }
  }

  String _extractErrorMessage(ApiResponse response) {
    try {
      final json = response.json;
      if (json.containsKey('message')) {
        return json['message'] as String;
      }
      if (json.containsKey('error')) {
        return json['error'] as String;
      }
    } catch (e) {
      // Ignore JSON parsing errors
    }
    return response.body;
  }
}

class ApiResponse {
  final int statusCode;
  final String body;

  ApiResponse({required this.statusCode, required this.body});

  Map<String, dynamic> get json {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  }

  List<dynamic> get jsonList {
    try {
      return jsonDecode(body) as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to parse JSON list: $e');
    }
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
