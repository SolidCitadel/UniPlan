import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/scenario_dto.dart';

final scenarioRemoteDataSourceProvider = Provider<ScenarioRemoteDataSource>((ref) {
  return ScenarioRemoteDataSource(ref.watch(dioProvider));
});

class ScenarioRemoteDataSource {
  ScenarioRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ScenarioDto>> getScenarios() async {
    final resp = await _dio.get(ApiEndpoints.scenarios);
    final data = resp.data as List;
    return data.map((e) => ScenarioDto.fromJson(_normalizeScenario(e as Map<String, dynamic>))).toList();
  }

  Future<ScenarioDto> getScenario(int id) async {
    final resp = await _dio.get('${ApiEndpoints.scenarios}/$id/tree');
    return ScenarioDto.fromJson(_normalizeScenario(resp.data as Map<String, dynamic>));
  }

  Future<ScenarioDto> createScenario({
    required String name,
    String? description,
    required int timetableId,
  }) async {
    final resp = await _dio.post(ApiEndpoints.scenarios, data: {
      'name': name,
      'description': description,
      'existingTimetableId': timetableId,
    });
    return ScenarioDto.fromJson(_normalizeScenario(resp.data as Map<String, dynamic>));
  }

  Future<ScenarioDto> createAlternative({
    required int parentScenarioId,
    required String name,
    String? description,
    required int timetableId,
    required List<int> excludedCourseIds,
  }) async {
    final resp = await _dio.post(
      '${ApiEndpoints.scenarios}/$parentScenarioId/alternatives',
      data: {
        'name': name,
        'description': description,
        'existingTimetableId': timetableId,
        'failedCourseIds': excludedCourseIds,
      },
    );
    return ScenarioDto.fromJson(_normalizeScenario(resp.data as Map<String, dynamic>));
  }

  Future<ScenarioDto> updateScenario({
    required int scenarioId,
    required String name,
    String? description,
  }) async {
    final resp = await _dio.put(
      '${ApiEndpoints.scenarios}/$scenarioId',
      data: {
        'name': name,
        'description': description,
      },
    );
    return ScenarioDto.fromJson(_normalizeScenario(resp.data as Map<String, dynamic>));
  }

  Future<void> deleteScenario(int scenarioId) async {
    await _dio.delete('${ApiEndpoints.scenarios}/$scenarioId');
  }

  Map<String, dynamic> _normalizeScenario(Map<String, dynamic> json) {
    final timetable = json['timetable'] as Map<String, dynamic>?;
    final children = (json['childScenarios'] as List?) ?? const [];
    final failed = (json['failedCourseIds'] as List?) ?? const [];
    final normalizedTimetable = _normalizeTimetable(timetable ??
        {
          'id': json['timetableId'] ?? 0,
          'name': '알 수 없는 시간표',
          'openingYear': 0,
          'semester': '',
          'excludedCourses': const [],
          'items': const [],
        });
    return {
      'id': json['id'],
      'name': json['name'] ?? '알 수 없는 시나리오',
      'description': json['description'],
      'parentId': json['parentScenarioId'],
      'timetableId': normalizedTimetable['id'],
      'timetable': normalizedTimetable,
      'failedCourseIds': failed.where((e) => e != null).map((e) => (e as num).toInt()).toList(),
      'children': children.map((e) => _normalizeScenario(e as Map<String, dynamic>)).toList(),
    };
  }

  Map<String, dynamic> _normalizeTimetable(Map<String, dynamic> t) {
    Map<String, dynamic> normClassTime(Map<String, dynamic> c) => {
          'day': c['day']?.toString() ?? '',
          'startTime': c['startTime']?.toString() ?? '',
          'endTime': c['endTime']?.toString() ?? '',
        };

    Map<String, dynamic> normCourse(Map<String, dynamic> c) => {
          'courseId': (c['courseId'] ?? 0) is num ? (c['courseId'] as num).toInt() : 0,
          'courseName': c['courseName']?.toString() ?? '알 수 없는 과목',
          'professor': c['professor']?.toString() ?? '',
          'classroom': c['classroom']?.toString() ?? '',
          'classTimes': ((c['classTimes'] as List?) ?? const []).map((e) => normClassTime(e as Map<String, dynamic>)).toList(),
        };

    Map<String, dynamic> normItem(Map<String, dynamic> i) => {
          'id': (i['id'] ?? 0) is num ? (i['id'] as num).toInt() : 0,
          'courseId': (i['courseId'] ?? 0) is num ? (i['courseId'] as num).toInt() : 0,
          'courseName': i['courseName']?.toString() ?? '알 수 없는 과목',
          'professor': i['professor']?.toString() ?? '',
          'classroom': i['classroom']?.toString() ?? '',
          'classTimes': ((i['classTimes'] as List?) ?? const []).map((e) => normClassTime(e as Map<String, dynamic>)).toList(),
        };

    return {
      'id': (t['id'] ?? 0) is num ? (t['id'] as num).toInt() : 0,
      'name': t['name']?.toString() ?? '알 수 없는 시간표',
      'openingYear': (t['openingYear'] ?? 0) is num ? (t['openingYear'] as num).toInt() : 0,
      'semester': t['semester']?.toString() ?? '',
      'excludedCourses': ((t['excludedCourses'] as List?) ?? const []).map((e) => normCourse(e as Map<String, dynamic>)).toList(),
      'items': ((t['items'] as List?) ?? const []).map((e) => normItem(e as Map<String, dynamic>)).toList(),
    };
  }
}
