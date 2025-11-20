import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/course.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  // In a real app, we might want to use a Dio instance with interceptors for auth
  return CourseRemoteDataSource(Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)));
});

class CourseRemoteDataSource {
  final Dio _dio;

  CourseRemoteDataSource(this._dio);

  Future<List<Course>> getCourses({
    String? department,
    String? search,
    int? page,
    int? size,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.courses,
        queryParameters: {
          if (department != null) 'department': department,
          if (search != null) 'search': search,
          if (page != null) 'page': page,
          if (size != null) 'size': size,
        },
      );
      // Assuming API returns a list or a paginated response with a 'content' field
      // Adjust based on actual API. Assuming list for now or content field.
      final data = response.data;
      if (data is List) {
        return data.map((json) => Course.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('content')) {
         return (data['content'] as List).map((json) => Course.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  Future<Course> getCourseDetail(String courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.courses}/$courseId');
      return Course.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course detail: $e');
    }
  }
}
