import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/course_repository_impl.dart';

final courseListProvider = StateNotifierProvider<CourseListViewModel, AsyncValue<List<Course>>>((ref) {
  return CourseListViewModel(ref);
});

class CourseListViewModel extends StateNotifier<AsyncValue<List<Course>>> {
  final Ref _ref;
  String? _searchQuery;
  String? _departmentFilter;

  CourseListViewModel(this._ref) : super(const AsyncValue.loading()) {
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    state = const AsyncValue.loading();
    try {
      final courses = await _ref.read(courseRepositoryProvider).getCourses(
        search: _searchQuery,
        department: _departmentFilter,
      );
      state = AsyncValue.data(courses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchCourses();
  }

  void setDepartmentFilter(String? department) {
    _departmentFilter = department;
    fetchCourses();
  }
}
