import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/page.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';
import '../mappers/course_mapper.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(ref.watch(courseRemoteDataSourceProvider));
});

class CourseRepositoryImpl implements CourseRepository {
  CourseRepositoryImpl(this._remote);

  final CourseRemoteDataSource _remote;

  @override
  Future<PageEnvelope<Course>> getCourses({
    String? courseName,
    String? professor,
    String? departmentCode,
    String? campus,
    int page = 0,
    int size = 20,
  }) async {
    final dto = await _remote.getCourses(
      courseName: courseName,
      professor: professor,
      departmentCode: departmentCode,
      campus: campus,
      page: page,
      size: size,
    );
    return dto.toDomain();
  }

  @override
  Future<Course> getCourseDetail(int courseId) async {
    final dto = await _remote.getCourseDetail(courseId);
    return dto.toDomain();
  }
}
