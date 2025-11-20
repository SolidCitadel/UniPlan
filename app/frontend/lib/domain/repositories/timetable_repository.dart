import '../entities/timetable.dart';
import '../entities/course.dart';

abstract class TimetableRepository {
  Future<List<Timetable>> getTimetables();
  Future<Timetable> createTimetable(String name, {String? parentId});
  Future<void> addCourseToTimetable(String timetableId, Course course);
  Future<void> removeCourseFromTimetable(String timetableId, String courseId);
  Future<void> deleteTimetable(String timetableId);
}
