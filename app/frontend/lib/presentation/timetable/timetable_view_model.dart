import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/timetable_repository_impl.dart';

final timetableProvider = StateNotifierProvider<TimetableViewModel, AsyncValue<List<Timetable>>>((ref) {
  return TimetableViewModel(ref);
});

class TimetableViewModel extends StateNotifier<AsyncValue<List<Timetable>>> {
  final Ref _ref;

  TimetableViewModel(this._ref) : super(const AsyncValue.loading()) {
    fetchTimetables();
  }

  Future<void> fetchTimetables() async {
    state = const AsyncValue.loading();
    try {
      final timetables = await _ref.read(timetableRepositoryProvider).getTimetables();
      state = AsyncValue.data(timetables);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createTimetable(String name, {String? parentId}) async {
    try {
      await _ref.read(timetableRepositoryProvider).createTimetable(name, parentId: parentId);
      await fetchTimetables();
    } catch (e) {
      print('Error creating timetable: $e');
    }
  }

  Future<void> addCourseToTimetable(String timetableId, Course course) async {
    try {
      await _ref.read(timetableRepositoryProvider).addCourseToTimetable(timetableId, course);
      await fetchTimetables();
    } catch (e) {
      // In a real app, we'd expose this error to the UI
      print('Error adding course to timetable: $e');
      throw e; // Rethrow to let UI handle it if needed
    }
  }

  Future<void> removeCourseFromTimetable(String timetableId, String courseId) async {
    try {
      await _ref.read(timetableRepositoryProvider).removeCourseFromTimetable(timetableId, courseId);
      await fetchTimetables();
    } catch (e) {
      print('Error removing course from timetable: $e');
    }
  }

  Future<void> deleteTimetable(String timetableId) async {
    try {
      await _ref.read(timetableRepositoryProvider).deleteTimetable(timetableId);
      await fetchTimetables();
    } catch (e) {
      print('Error deleting timetable: $e');
    }
  }
}
