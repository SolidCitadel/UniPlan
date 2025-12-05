import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/course_dto.dart';
import '../dtos/page_dto.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSource(ref.watch(dioProvider));
});

class CourseRemoteDataSource {
  CourseRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PageDto<CourseDto>> getCourses({
    String? courseName,
    String? professor,
    String? departmentName,
    String? campus,
    int? targetGrade,
    int? credits,
    int page = 0,
    int size = 20,
  }) async {
    final resp = await _dio.get(
      ApiEndpoints.courses,
      queryParameters: {
        'page': page,
        'size': size,
        if (courseName != null && courseName.isNotEmpty) 'courseName': courseName,
        if (professor != null && professor.isNotEmpty) 'professor': professor,
        if (departmentName != null && departmentName.isNotEmpty) 'departmentName': departmentName,
        if (campus != null && campus.isNotEmpty) 'campus': campus,
        if (targetGrade != null) 'targetGrade': targetGrade,
        if (credits != null) ...{
          'minCredits': credits,
          'maxCredits': credits,
        },
      },
    );
    return PageDto<CourseDto>.fromJson(
      resp.data as Map<String, dynamic>,
      (obj) => CourseDto.fromJson(obj as Map<String, dynamic>),
    );
  }

  Future<CourseDto> getCourseDetail(int courseId) async {
    final resp = await _dio.get('${ApiEndpoints.courses}/$courseId');
    return CourseDto.fromJson(resp.data);
  }
}
