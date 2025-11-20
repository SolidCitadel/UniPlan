import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/entities/course.dart';

final timetableRemoteDataSourceProvider = Provider<TimetableRemoteDataSource>((ref) {
  return TimetableRemoteDataSource();
});

class TimetableRemoteDataSource {
  final List<Timetable> _mockTimetables = [];

  Future<List<Timetable>> getTimetables() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTimetables;
  }

  Future<Timetable> createTimetable(String name, {String? parentId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTimetable = Timetable(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      courses: [],
      parentId: parentId,
    );
    _mockTimetables.add(newTimetable);
    
    if (parentId != null) {
      final parentIndex = _mockTimetables.indexWhere((t) => t.id == parentId);
      if (parentIndex != -1) {
        final parent = _mockTimetables[parentIndex];
        _mockTimetables[parentIndex] = parent.copyWith(
          childIds: [...parent.childIds, newTimetable.id],
        );
      }
    }
    
    return newTimetable;
  }

  Future<void> addCourseToTimetable(String timetableId, Course course) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockTimetables.indexWhere((t) => t.id == timetableId);
    if (index != -1) {
      final timetable = _mockTimetables[index];
      // Simple conflict check (mock)
      if (timetable.courses.any((c) => c.time == course.time && c.time != '-')) {
        throw Exception('Time conflict detected!');
      }
      _mockTimetables[index] = timetable.copyWith(
        courses: [...timetable.courses, course],
      );
    }
  }

  Future<void> removeCourseFromTimetable(String timetableId, String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockTimetables.indexWhere((t) => t.id == timetableId);
    if (index != -1) {
      final timetable = _mockTimetables[index];
      _mockTimetables[index] = timetable.copyWith(
        courses: timetable.courses.where((c) => c.id != courseId).toList(),
      );
    }
  }

  Future<void> deleteTimetable(String timetableId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTimetables.removeWhere((t) => t.id == timetableId);
  }
}
