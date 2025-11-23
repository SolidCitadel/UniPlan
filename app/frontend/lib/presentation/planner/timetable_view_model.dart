import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/timetable.dart';
import '../../data/repositories/timetable_repository_impl.dart';

final timetableViewModelProvider =
    AsyncNotifierProvider<TimetableViewModel, List<Timetable>>(TimetableViewModel.new);

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

  Future<Timetable?> create({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    try {
      final created = await ref.read(timetableRepositoryProvider).createTimetable(
            name: name,
            openingYear: openingYear,
            semester: semester,
          );
      state = await AsyncValue.guard(_fetch);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
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

  Future<Timetable?> fetchOne(int timetableId) async {
    try {
      return await ref.read(timetableRepositoryProvider).getTimetable(timetableId);
    } catch (_) {
      return null;
    }
  }

  Future<Timetable?> createAlternative({
    required int parentTimetableId,
    required String name,
    required int openingYear,
    required String semester,
    required List<int> excludedCourseIds,
  }) async {
    return ref.read(timetableRepositoryProvider).createAlternativeTimetable(
          parentTimetableId: parentTimetableId,
          name: name,
          openingYear: openingYear,
          semester: semester,
          excludedCourseIds: excludedCourseIds,
        );
  }
}
