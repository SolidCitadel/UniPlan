import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/timetable_dto.dart';

final timetableRemoteDataSourceProvider = Provider<TimetableRemoteDataSource>((ref) {
  return TimetableRemoteDataSource(ref.watch(dioProvider));
});

class TimetableRemoteDataSource {
  TimetableRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TimetableDto>> getTimetables() async {
    final resp = await _dio.get(ApiEndpoints.timetables);
    final data = resp.data as List;
    return data.map((e) => TimetableDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TimetableDto> createTimetable({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    final resp = await _dio.post(ApiEndpoints.timetables, data: {
      'name': name,
      'openingYear': openingYear,
      'semester': semester,
    });
    return TimetableDto.fromJson(resp.data);
  }

  Future<void> addCourseToTimetable(int timetableId, int courseId) async {
    await _dio.post('${ApiEndpoints.timetables}/$timetableId/courses', data: {
      'courseId': courseId,
    });
  }

  Future<void> removeCourseFromTimetable(int timetableId, int courseId) async {
    await _dio.delete('${ApiEndpoints.timetables}/$timetableId/courses/$courseId');
  }

  Future<void> deleteTimetable(int timetableId) async {
    await _dio.delete('${ApiEndpoints.timetables}/$timetableId');
  }
}
