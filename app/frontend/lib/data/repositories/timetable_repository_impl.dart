import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_remote_data_source.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final remoteDataSource = ref.watch(timetableRemoteDataSourceProvider);
  return TimetableRepositoryImpl(remoteDataSource);
});

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableRemoteDataSource _remoteDataSource;

  TimetableRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Timetable>> getTimetables() async {
    return await _remoteDataSource.getTimetables();
  }

  @override
  Future<Timetable> createTimetable({
    required String name,
    required int openingYear,
    required String semester,
  }) async {
    return await _remoteDataSource.createTimetable(
      name: name,
      openingYear: openingYear,
      semester: semester,
    );
  }

  @override
  Future<void> addCourseToTimetable(int timetableId, int courseId) async {
    return await _remoteDataSource.addCourseToTimetable(timetableId, courseId);
  }

  @override
  Future<void> removeCourseFromTimetable(int timetableId, int courseId) async {
    return await _remoteDataSource.removeCourseFromTimetable(timetableId, courseId);
  }

  @override
  Future<void> deleteTimetable(int timetableId) async {
    return await _remoteDataSource.deleteTimetable(timetableId);
  }
}
