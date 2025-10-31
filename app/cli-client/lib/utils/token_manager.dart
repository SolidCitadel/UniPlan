import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  String? _accessToken;
  String? _refreshToken;

  String get tokenDir {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    return path.join(home, '.uniplan');
  }

  String get tokenFile => path.join(tokenDir, 'token.json');

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get isLoggedIn => _accessToken != null;

  Future<void> load() async {
    try {
      final file = File(tokenFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        _accessToken = json['accessToken'] as String?;
        _refreshToken = json['refreshToken'] as String?;
      }
    } catch (e) {
      // Ignore load errors
      _accessToken = null;
      _refreshToken = null;
    }
  }

  Future<void> save(String accessToken, String refreshToken) async {
    try {
      final dir = Directory(tokenDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      _accessToken = accessToken;
      _refreshToken = refreshToken;

      final file = File(tokenFile);
      final json = {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  Future<void> clear() async {
    try {
      _accessToken = null;
      _refreshToken = null;

      final file = File(tokenFile);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore delete errors
    }
  }

  void updateAccessToken(String accessToken) {
    _accessToken = accessToken;
  }
}
