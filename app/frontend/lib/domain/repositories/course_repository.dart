import '../entities/course.dart';
import '../entities/page.dart';

abstract class CourseRepository {
  Future<PageEnvelope<Course>> getCourses({
    String? courseName,
    String? professor,
    String? departmentName,
    String? campus,
    int? targetGrade,
    int? credits,
    int page,
    int size,
  });

  Future<Course> getCourseDetail(int courseId);
}
