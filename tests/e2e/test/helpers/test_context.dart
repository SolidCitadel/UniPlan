import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uniplan_models/uniplan_models.dart';

import 'http_client.dart';

class E2eContext {
  E2eContext(this.env) : client = GatewayClient(baseUrl: env.baseUrl);

  final EnvConfig env;
  final GatewayClient client;
  final List<int> timetableIds = [];
  final List<int> scenarioIds = [];
  final List<int> registrationIds = [];
  int fixtureCourseId = -1;

  Future<void> signup() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final email = 'e2e_$timestamp@test.com';
    final password = 'Test1234!';
    final name = 'E2E Test User';
    await client.signup(email: email, password: password, name: name);
  }

  Future<void> login({required String email, required String password}) => client.login(email: email, password: password);

  Future<void> seedCourse() async {
    final year = DateTime.now().year;
    final importPayload = [
      {
        'openingYear': year,
        'semester': '1',
        'targetGrade': 1,
        'courseCode': 'E2E001',
        'section': '01',
        'courseName': 'E2E Fixture Course',
        'professor': 'E2E Prof',
        'credits': 3,
        'classroom': 'E2E-101',
        'campus': 'MAIN',
        'departmentCodes': ['E2E'],
        'courseTypeCode': '01',
        'notes': 'fixture for E2E tests',
        'classTime': [
          {'day': 'MON', 'startTime': '09:00', 'endTime': '10:15'},
        ],
      }
    ];

    final resp = await client.post('/api/v1/courses/import', body: importPayload);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw StateError('Failed to seed course: ${resp.statusCode} ${resp.body}');
    }

    final searchResp = await client.get(
      '/api/v1/courses?courseCode=E2E001&openingYear=$year&semester=1&size=1&page=0',
    );
    _expectSuccess(searchResp, allowed: {200});
    final body = jsonDecode(searchResp.body) as Map<String, dynamic>;
    final content = (body['content'] as List?) ?? const [];
    if (content.isEmpty) {
      throw StateError('Seeded course not found in search results.');
    }
    final course = content.first as Map<String, dynamic>;
    final id = course['id'] ?? course['courseId'];
    if (id == null) {
      throw StateError('Seeded course missing id field.');
    }
    fixtureCourseId = (id as num).toInt();
  }

  Future<Timetable> createTimetable({required String name, required int openingYear, required String semester}) async {
    final resp = await client.post('/api/v1/timetables', body: {
      'name': name,
      'openingYear': openingYear,
      'semester': semester,
    });
    _expectSuccess(resp, allowed: {201});
    final timetable = Timetable.fromJson(_decode(resp));
    timetableIds.add(timetable.id);
    return timetable;
  }

  Future<void> addCourse(int timetableId, int courseId) async {
    final resp = await client.post('/api/v1/timetables/$timetableId/courses', body: {'courseId': courseId});
    _expectSuccess(resp, allowed: {201});
  }

  Future<Timetable> createAlternativeTimetable({
    required int baseTimetableId,
    required String name,
    required Set<int> excludedCourseIds,
  }) async {
    final resp = await client.post(
      '/api/v1/timetables/$baseTimetableId/alternatives',
      body: {
        'name': name,
        'excludedCourseIds': excludedCourseIds.toList(),
      },
    );
    _expectSuccess(resp, allowed: {201});
    final timetable = Timetable.fromJson(_decode(resp));
    timetableIds.add(timetable.id);
    return timetable;
  }

  Future<Scenario> createScenario({required String name, required int timetableId}) async {
    final resp = await client.post('/api/v1/scenarios', body: {
      'name': name,
      'existingTimetableId': timetableId,
    });
    _expectSuccess(resp, allowed: {201});
    final scenario = Scenario.fromJson(_decode(resp));
    scenarioIds.add(scenario.id);
    return scenario;
  }

  Future<Registration> startRegistration({required int scenarioId}) async {
    final resp = await client.post('/api/v1/registrations', body: {'scenarioId': scenarioId});
    _expectSuccess(resp, allowed: {201});
    final registration = Registration.fromJson(_decode(resp));
    registrationIds.add(registration.id);
    return registration;
  }

  Future<void> deleteRegistration(int id) async {
    final resp = await client.delete('/api/v1/registrations/$id');
    if (resp.statusCode != 204) return;
  }

  Future<void> deleteScenario(int id) async {
    final resp = await client.delete('/api/v1/scenarios/$id');
    if (resp.statusCode != 204) return;
  }

  Future<void> deleteTimetable(int id) async {
    final resp = await client.delete('/api/v1/timetables/$id');
    if (resp.statusCode != 204) return;
  }

  Future<void> cleanup() async {
    // Delete registrations first (they reference scenarios)
    for (final id in registrationIds.reversed) {
      try {
        await deleteRegistration(id);
      } catch (_) {}
    }
    // Then scenarios (they reference timetables)
    for (final id in scenarioIds.reversed) {
      try {
        await deleteScenario(id);
      } catch (_) {}
    }
    // Finally timetables
    for (final id in timetableIds.reversed) {
      try {
        await deleteTimetable(id);
      } catch (_) {}
    }
  }

  Map<String, dynamic> _decode(http.Response resp) {
    return resp.body.isEmpty ? <String, dynamic>{} : (jsonDecode(resp.body) as Map<String, dynamic>);
  }

  void _expectSuccess(http.Response resp, {Set<int> allowed = const {200}}) {
    if (!allowed.contains(resp.statusCode)) {
      throw StateError('Unexpected status ${resp.statusCode}: ${resp.body}');
    }
  }
}
