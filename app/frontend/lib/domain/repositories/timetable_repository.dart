import '../entities/timetable.dart';

abstract class TimetableRepository {
  Future<List<Timetable>> getTimetables();
  Future<Timetable> createTimetable({
    required String name,
    required int openingYear,
    required String semester,
  });
  Future<void> addCourseToTimetable(int timetableId, int courseId);
  Future<void> removeCourseFromTimetable(int timetableId, int courseId);
  Future<void> deleteTimetable(int timetableId);
  Future<Timetable> getTimetable(int timetableId);
  Future<Timetable> createAlternativeTimetable({
    required int parentTimetableId,
    required String name,
    required int openingYear,
    required String semester,
    required List<int> excludedCourseIds,
  });
}
