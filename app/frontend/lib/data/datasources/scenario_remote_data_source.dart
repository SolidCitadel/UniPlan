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
    return {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'parentId': json['parentScenarioId'],
      'timetableId': timetable != null ? timetable['id'] : json['timetableId'],
      'failedCourseIds': failed.map((e) => (e as num).toInt()).toList(),
      'children': children.map((e) => _normalizeScenario(e as Map<String, dynamic>)).toList(),
    };
  }
}
