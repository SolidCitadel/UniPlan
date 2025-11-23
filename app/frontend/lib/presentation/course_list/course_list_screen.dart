import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'course_list_view_model.dart';
import '../wishlist/wishlist_view_model.dart';
import '../../domain/entities/course.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({super.key});

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  final _searchController = TextEditingController();
  String _campusFilter = '전체';
  String _departmentFilter = '전체';

  Course? _selectedCourse;
  bool _isActionDialogOpen = false;
  int _selectedPriority = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    ref.read(courseListProvider.notifier).search(
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      departmentCode: _departmentFilter == '전체' ? null : _departmentFilter,
      campus: _campusFilter == '전체' ? null : _campusFilter,
    );
  }

  void _handleReset() {
    setState(() {
      _searchController.clear();
      _campusFilter = '전체';
      _departmentFilter = '전체';
    });
    ref.read(courseListProvider.notifier).reset();
  }

  void _handleCourseClick(Course course) {
    setState(() {
      _selectedCourse = course;
      _selectedPriority = 1;
      _isActionDialogOpen = true;
    });
  }

  void _addToWishlist() {
    if (_selectedCourse != null) {
      ref.read(wishlistProvider.notifier).addToWishlist(_selectedCourse!.id, _selectedPriority);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_selectedCourse!.courseName}을(를) 희망과목에 추가했습니다.')),
      );
      setState(() {
        _isActionDialogOpen = false;
        _selectedCourse = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '강의 목록',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '강의를 검색하고 희망과목에 추가하세요.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Filter Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: '강의명 또는 교수명',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _campusFilter,
                            decoration: InputDecoration(
                              labelText: '캠퍼스',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: ['전체', '서울', '안성'].map((campus) {
                              return DropdownMenuItem(value: campus, child: Text(campus));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _campusFilter = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _departmentFilter,
                            decoration: InputDecoration(
                              labelText: '학과',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: ['전체', 'CSE', 'EE', 'ME'].map((dept) {
                              return DropdownMenuItem(value: dept, child: Text(dept));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _departmentFilter = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _handleReset,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('초기화'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _handleSearch,
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('검색'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Course Table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ref.watch(courseListProvider).when(
                    data: (courses) {
                      if (courses.isEmpty) {
                        return const Center(
                          child: Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                          columnSpacing: 24,
                          horizontalMargin: 24,
                          columns: const [
                            DataColumn(label: Text('강의코드', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('강의명', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('학점', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('교수', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('캠퍼스', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('학과', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: courses.map((course) {
                            return DataRow(
                              onSelectChanged: (_) => _handleCourseClick(course),
                              color: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.blue[50];
                                }
                                return null;
                              }),
                              cells: [
                                DataCell(Text(course.courseCode ?? '-')),
                                DataCell(Text(course.courseName)),
                                DataCell(Text(course.credits?.toString() ?? '-')),
                                DataCell(Text(course.professor ?? '-')),
                                DataCell(Text(course.campus ?? '-')),
                                DataCell(Text(course.departmentCode ?? '-')),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                ),
              ),
            ],
          ),

          // Course Detail Dialog
          if (_isActionDialogOpen && _selectedCourse != null)
            GestureDetector(
              onTap: () => setState(() {
                _isActionDialogOpen = false;
                _selectedCourse = null;
              }),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent closing when clicking dialog itself
                    child: Container(
                      width: 480,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '강의 정보',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => setState(() {
                                  _isActionDialogOpen = false;
                                  _selectedCourse = null;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow('강의코드', _selectedCourse!.courseCode ?? '-'),
                          _buildInfoRow('강의명', _selectedCourse!.courseName),
                          _buildInfoRow('학점', _selectedCourse!.credits?.toString() ?? '-'),
                          _buildInfoRow('교수', _selectedCourse!.professor ?? '-'),
                          _buildInfoRow('캠퍼스', _selectedCourse!.campus ?? '-'),
                          _buildInfoRow('학과', _selectedCourse!.departmentCode ?? '-'),
                          const SizedBox(height: 24),
                          _buildInfoRow('우선순위', ''),
                          Row(
                            children: List.generate(10, (index) {
                              final priority = index + 1;
                              final isSelected = priority == _selectedPriority;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedPriority = priority),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$priority',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => setState(() {
                                  _isActionDialogOpen = false;
                                  _selectedCourse = null;
                                }),
                                child: const Text('취소'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _addToWishlist,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('희망과목에 추가'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
