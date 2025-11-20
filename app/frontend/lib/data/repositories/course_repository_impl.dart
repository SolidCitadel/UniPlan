import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final remoteDataSource = ref.watch(courseRemoteDataSourceProvider);
  return CourseRepositoryImpl(remoteDataSource);
});

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  CourseRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Course>> getCourses({
    String? department,
    String? search,
    int? page,
    int? size,
  }) async {
    return await _remoteDataSource.getCourses(
      department: department,
      search: search,
      page: page,
      size: size,
    );
  }

  @override
  Future<Course> getCourseDetail(String courseId) async {
    return await _remoteDataSource.getCourseDetail(courseId);
  }
}
