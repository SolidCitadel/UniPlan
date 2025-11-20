import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/entities/course.dart';
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
  Future<Timetable> createTimetable(String name, {String? parentId}) async {
    return await _remoteDataSource.createTimetable(name, parentId: parentId);
  }

  @override
  Future<void> addCourseToTimetable(String timetableId, Course course) async {
    return await _remoteDataSource.addCourseToTimetable(timetableId, course);
  }

  @override
  Future<void> removeCourseFromTimetable(String timetableId, String courseId) async {
    return await _remoteDataSource.removeCourseFromTimetable(timetableId, courseId);
  }

  @override
  Future<void> deleteTimetable(String timetableId) async {
    return await _remoteDataSource.deleteTimetable(timetableId);
  }
}
