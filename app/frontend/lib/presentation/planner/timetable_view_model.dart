import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/timetable.dart';
import '../../data/repositories/timetable_repository_impl.dart';

final timetableViewModelProvider =
    AsyncNotifierProvider<TimetableViewModel, List<Timetable>>(
  TimetableViewModel.new,
);

class TimetableViewModel extends AsyncNotifier<List<Timetable>> {
  @override
  Future<List<Timetable>> build() async {
    return _fetch();
  }

  Future<List<Timetable>> _fetch() async {
    return ref.read(timetableRepositoryProvider).getTimetables();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> create({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).createTimetable(
            name: name,
            openingYear: openingYear,
            semester: semester,
          );
      return _fetch();
    });
  }

  Future<void> addCourse(int timetableId, int courseId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).addCourseToTimetable(timetableId, courseId);
      return _fetch();
    });
  }

  Future<void> removeCourse(int timetableId, int courseId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).removeCourseFromTimetable(timetableId, courseId);
      return _fetch();
    });
  }

  Future<void> deleteTimetable(int timetableId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(timetableRepositoryProvider).deleteTimetable(timetableId);
      return _fetch();
    });
  }
}
