import '../entities/course.dart';
import '../entities/page.dart';

abstract class CourseRepository {
  Future<PageEnvelope<Course>> getCourses({
    String? courseName,
    String? professor,
    String? departmentCode,
    String? campus,
    int page,
    int size,
  });

  Future<Course> getCourseDetail(int courseId);
}
