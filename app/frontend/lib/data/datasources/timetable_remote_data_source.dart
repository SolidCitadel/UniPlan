import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_provider.dart';
import '../../domain/entities/timetable.dart';

final timetableRemoteDataSourceProvider = Provider<TimetableRemoteDataSource>((ref) {
  return TimetableRemoteDataSource(ref.watch(dioProvider));
});

class TimetableRemoteDataSource {
  final Dio _dio;

  TimetableRemoteDataSource(this._dio);

  Future<List<Timetable>> getTimetables() async {
    try {
      final response = await _dio.get(ApiConstants.timetables);
      
      final data = response.data as List;
      return data.map((json) => Timetable.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load timetables: $e');
    }
  }

  Future<Timetable> createTimetable({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.timetables,
        data: {
          'name': name,
          'openingYear': openingYear,
          'semester': semester,
        },
      );
      
      return Timetable.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create timetable: $e');
    }
  }

  Future<void> addCourseToTimetable(int timetableId, int courseId) async {
    try {
      await _dio.post(
        '${ApiConstants.timetables}/$timetableId/courses',
        data: {'courseId': courseId},
      );
    } catch (e) {
      throw Exception('Failed to add course: $e');
    }
  }

  Future<void> removeCourseFromTimetable(int timetableId, int courseId) async {
    try {
      await _dio.delete(
        '${ApiConstants.timetables}/$timetableId/courses/$courseId',
      );
    } catch (e) {
      throw Exception('Failed to remove course: $e');
    }
  }

  Future<void> deleteTimetable(int timetableId) async {
    try {
      await _dio.delete(
        '${ApiConstants.timetables}/$timetableId',
      );
    } catch (e) {
      throw Exception('Failed to delete timetable: $e');
    }
  }
}
