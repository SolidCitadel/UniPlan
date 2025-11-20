import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/course_repository_impl.dart';

final courseListProvider = AsyncNotifierProvider<CourseListViewModel, List<Course>>(() {
  return CourseListViewModel();
});

class CourseListViewModel extends AsyncNotifier<List<Course>> {
  String? _searchQuery;
  String? _departmentFilter;

  @override
  Future<List<Course>> build() async {
    return _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    return await ref.read(courseRepositoryProvider).getCourses(
      search: _searchQuery,
      department: _departmentFilter,
    );
  }

  Future<void> fetchCourses() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCourses());
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
