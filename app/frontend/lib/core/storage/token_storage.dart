import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Web-safe token storage using SharedPreferences (backed by localStorage on web).
class TokenStorage {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async => _prefs.getString(_accessTokenKey);
  Future<String?> getRefreshToken() async => _prefs.getString(_refreshTokenKey);

  Future<bool> hasAccessToken() async => _prefs.containsKey(_accessTokenKey);

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  throw UnimplementedError('tokenStorageProvider must be overridden in main.dart');
});
