import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_provider.dart';
import '../../domain/entities/course.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSource(ref.watch(dioProvider));
});

class CourseRemoteDataSource {
  final Dio _dio;

  CourseRemoteDataSource(this._dio);

  Future<List<Course>> getCourses({
    String? courseName,        // 과목명 검색
    String? professor,         // 교수명 검색
    String? departmentCode,    // 학과 코드
    String? campus,            // 캠퍼스
    int? page,
    int? size,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.courses,
        queryParameters: {
          if (courseName != null && courseName.isNotEmpty) 'courseName': courseName,
          if (professor != null && professor.isNotEmpty) 'professor': professor,
          if (departmentCode != null && departmentCode.isNotEmpty) 'departmentCode': departmentCode,
          if (campus != null && campus.isNotEmpty) 'campus': campus,
          if (page != null) 'page': page,
          if (size != null) 'size': size,
        },
      );
      
      // Backend returns Page format: { content: [...], totalElements, totalPages, etc }
      final data = response.data;
      if (data is Map && data.containsKey('content')) {
        return (data['content'] as List).map((json) => Course.fromJson(json)).toList();
      } else if (data is List) {
        // Fallback for direct list response
        return data.map((json) => Course.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[CourseRemoteDataSource] Failed to load courses: $e');
      throw Exception('Failed to load courses: $e');
    }
  }

  Future<Course> getCourseDetail(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.courses}/$courseId');
      return Course.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course detail: $e');
    }
  }
}
