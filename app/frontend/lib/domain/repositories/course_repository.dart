import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses({
    String? department,
    String? search,
    int? page,
    int? size,
  });
  
  Future<Course> getCourseDetail(String courseId);
}
