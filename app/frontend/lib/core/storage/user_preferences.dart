import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPreferencesProvider = Provider<UserPreferences>((ref) {
  throw UnimplementedError('Initialize userPreferencesProvider in main.dart');
});

class UserPreferences {
  final SharedPreferences _prefs;
  static const _schoolKey = 'user_school';
  static const _campusKey = 'user_campus';
  static const _semesterKey = 'user_semester';

  UserPreferences(this._prefs);

  Future<void> saveUserContext({
    required String school,
    required String campus,
    required String semester,
  }) async {
    await _prefs.setString(_schoolKey, school);
    await _prefs.setString(_campusKey, campus);
    await _prefs.setString(_semesterKey, semester);
  }

  String? getSchool() => _prefs.getString(_schoolKey);
  String? getCampus() => _prefs.getString(_campusKey);
  String? getSemester() => _prefs.getString(_semesterKey);

  Future<void> clear() async {
    await _prefs.remove(_schoolKey);
    await _prefs.remove(_campusKey);
    await _prefs.remove(_semesterKey);
  }
}
