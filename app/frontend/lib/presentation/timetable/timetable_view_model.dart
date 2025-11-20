import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/timetable_repository_impl.dart';

final timetableProvider = AsyncNotifierProvider<TimetableViewModel, List<Timetable>>(() {
  return TimetableViewModel();
});

class TimetableViewModel extends AsyncNotifier<List<Timetable>> {
  @override
  Future<List<Timetable>> build() async {
    return _fetchTimetables();
  }

  Future<List<Timetable>> _fetchTimetables() async {
    return await ref.read(timetableRepositoryProvider).getTimetables();
  }

  Future<void> fetchTimetables() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTimetables());
  }

  Future<void> createTimetable(String name, {String? parentId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).createTimetable(name, parentId: parentId);
      return _fetchTimetables();
    });
  }

  Future<void> addCourseToTimetable(String timetableId, Course course) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).addCourseToTimetable(timetableId, course);
      return _fetchTimetables();
    });
  }

  Future<void> removeCourseFromTimetable(String timetableId, String courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).removeCourseFromTimetable(timetableId, courseId);
      return _fetchTimetables();
    });
  }

  Future<void> deleteTimetable(String timetableId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).deleteTimetable(timetableId);
      return _fetchTimetables();
    });
  }
}
