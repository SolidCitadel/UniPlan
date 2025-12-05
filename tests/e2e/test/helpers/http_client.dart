import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

class GatewayClient {
  GatewayClient({required this.baseUrl});

  final String baseUrl;
  String? _email;
  String? _password;
  String? _token;

  String? get token => _token;
  String? get email => _email;

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<void> signup({required String email, required String password, required String name}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw StateError('Signup failed (${resp.statusCode}): ${resp.body}');
    }
    _email = email;
    _password = password;

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    _token = body['accessToken'] as String?;
    if (_token == null || _token!.isEmpty) {
      throw StateError('Signup succeeded but accessToken missing');
    }
  }

  Future<void> login({required String email, required String password}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode != 200) {
      throw StateError('Login failed (${resp.statusCode}): ${resp.body}');
    }
    _email = email;
    _password = password;

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    _token = body['accessToken'] as String?;
    if (_token == null || _token!.isEmpty) {
      throw StateError('Login succeeded but accessToken missing');
    }
  }

  Future<http.Response> get(String path) async {
    return http.get(Uri.parse('$baseUrl$path'), headers: _headers());
  }

  Future<http.Response> post(String path, {Object? body}) async {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    return http.delete(Uri.parse('$baseUrl$path'), headers: _headers());
  }
}

class EnvConfig {
  EnvConfig._(this.baseUrl);

  final String baseUrl;

  static EnvConfig load() {
    final env = DotEnv(includePlatformEnvironment: true)..load(['.env']);
    final baseUrl = env['API_BASE_URL'] ?? 'http://localhost:8080';
    // Debug print to verify env loading during tests
    // ignore: avoid_print
    print('E2E using API_BASE_URL=$baseUrl');
    return EnvConfig._(baseUrl);
  }
}
