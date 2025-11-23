import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/course_repository_impl.dart';

final courseListProvider = AsyncNotifierProvider<CourseListViewModel, List<Course>>(() {
  return CourseListViewModel();
});

class CourseListViewModel extends AsyncNotifier<List<Course>> {
  // Search parameters matching backend CourseSearchRequest
  String? _courseName;       // 과목명 검색
  String? _professor;        // 교수명 검색
  String? _departmentCode;   // 학과 코드
  String? _campus;           // 캠퍼스
  int? _page;
  int? _size;

  @override
  Future<List<Course>> build() async {
    // Initial fetch with default params
    return _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    return await ref.read(courseRepositoryProvider).getCourses(
      courseName: _courseName,
      professor: _professor,
      departmentCode: _departmentCode,
      campus: _campus,
      page: _page,
      size: _size,
    );
  }

  /// Perform search with all parameters
  Future<void> search({
    String? query,             // Search query (will be used for both courseName and professor)
    String? departmentCode,
    String? campus,
    int? page,
    int? size,
  }) async {
    // Use query for both courseName and professor search
    // Backend will search either field if provided
    _courseName = query;
    _professor = query;
    _departmentCode = (departmentCode == null || departmentCode == '전체') ? null : departmentCode;
    _campus = (campus == null || campus == '전체') ? null : campus;
    _page = page;
    _size = size;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCourses());
  }

  /// Quick search by query only
  Future<void> quickSearch(String query) async {
    await search(query: query);
  }

  /// Reset all filters and fetch all courses
  Future<void> reset() async {
    _courseName = null;
    _professor = null;
    _departmentCode = null;
    _campus = null;
    _page = null;
    _size = null;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCourses());
  }

  // Legacy methods for backward compatibility
  Future<void> fetchCourses() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCourses());
  }
}
