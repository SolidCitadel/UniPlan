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
    String? courseName,
    String? professor,
    String? departmentCode,
    String? campus,
    int? page,
    int? size,
  }) async {
    return await _remoteDataSource.getCourses(
      courseName: courseName,
      professor: professor,
      departmentCode: departmentCode,
      campus: campus,
      page: page,
      size: size,
    );
  }

  @override
  Future<Course> getCourseDetail(int courseId) async {
    return await _remoteDataSource.getCourseDetail(courseId);
  }
}
