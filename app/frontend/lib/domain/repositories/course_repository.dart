import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses({
    String? courseName,
    String? professor,
    String? departmentCode,
    String? campus,
    int? page,
    int? size,
  });
  
  Future<Course> getCourseDetail(int courseId);
}
