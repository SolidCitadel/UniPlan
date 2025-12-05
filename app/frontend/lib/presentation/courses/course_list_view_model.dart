import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/page.dart';
import '../../data/repositories/course_repository_impl.dart';

final courseListViewModelProvider =
    AsyncNotifierProvider<CourseListViewModel, PageEnvelope<Course>>(
  CourseListViewModel.new,
);

class CourseListViewModel extends AsyncNotifier<PageEnvelope<Course>> {
  String? _query;
  String? _professor;
  String? _departmentName;
  String? _campus;
  int? _targetGrade;
  int? _credits;
  int _page = 0;
  final int _size = 20;

  @override
  Future<PageEnvelope<Course>> build() async {
    return _fetch();
  }

  Future<PageEnvelope<Course>> _fetch() async {
    return ref.read(courseRepositoryProvider).getCourses(
          courseName: _query,
          professor: _professor,
          departmentName: _departmentName,
          campus: _campus,
          targetGrade: _targetGrade,
          credits: _credits,
          page: _page,
          size: _size,
        );
  }

  Future<void> search({
    String? query,
    String? professor,
    String? departmentName,
    String? campus,
    int? targetGrade,
    int? credits,
  }) async {
    _query = query;
    _professor = professor;
    _departmentName = departmentName;
    _campus = campus;
    _targetGrade = targetGrade;
    _credits = credits;
    _page = 0;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> goToPage(int page) async {
    _page = page;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  int get currentPage => _page;
  int get pageSize => _size;
}
