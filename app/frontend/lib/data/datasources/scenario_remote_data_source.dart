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
    return data.map((e) => ScenarioDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ScenarioDto> getScenario(int id) async {
    final resp = await _dio.get('${ApiEndpoints.scenarios}/$id');
    return ScenarioDto.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<ScenarioDto> createScenario({
    required String name,
    String? description,
    required int timetableId,
  }) async {
    final resp = await _dio.post(ApiEndpoints.scenarios, data: {
      'name': name,
      'description': description,
      'timetableId': timetableId,
    });
    return ScenarioDto.fromJson(resp.data as Map<String, dynamic>);
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
        'timetableId': timetableId,
        'excludedCourseIds': excludedCourseIds,
      },
    );
    return ScenarioDto.fromJson(resp.data as Map<String, dynamic>);
  }
}
