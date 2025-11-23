import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/timetable.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_remote_data_source.dart';
import '../mappers/timetable_mapper.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepositoryImpl(ref.watch(timetableRemoteDataSourceProvider));
});

class TimetableRepositoryImpl implements TimetableRepository {
  TimetableRepositoryImpl(this._remote);

  final TimetableRemoteDataSource _remote;

  @override
  Future<List<Timetable>> getTimetables() async {
    final dtos = await _remote.getTimetables();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Timetable> createTimetable({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    final dto = await _remote.createTimetable(
      name: name,
      openingYear: openingYear,
      semester: semester,
    );
    return dto.toDomain();
  }

  @override
  Future<void> addCourseToTimetable(int timetableId, int courseId) {
    return _remote.addCourseToTimetable(timetableId, courseId);
  }

  @override
  Future<void> removeCourseFromTimetable(int timetableId, int courseId) {
    return _remote.removeCourseFromTimetable(timetableId, courseId);
  }

  @override
  Future<void> deleteTimetable(int timetableId) {
    return _remote.deleteTimetable(timetableId);
  }
}
