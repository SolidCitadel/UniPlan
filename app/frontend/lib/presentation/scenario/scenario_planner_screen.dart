// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../timetable/timetable_view_model.dart';
import '../timetable/timetable_planner_screen.dart';

// Simplified Scenario Planner
// Shows list-based UI instead of complex SVG tree diagram

class Scenario {
  final String failedCourseCode;
  final String failedCourseName;
  final String alternativeTimetableId;
  final String alternativeTimetableName;

  Scenario({
    required this.failedCourseCode,
    required this.failedCourseName,
    required this.alternativeTimetableId,
    required this.alternativeTimetableName,
  });
}

class ScenarioPlannerScreen extends ConsumerStatefulWidget {
  const ScenarioPlannerScreen({super.key});

  @override
  ConsumerState<ScenarioPlannerScreen> createState() => _ScenarioPlannerScreenState();
}

class _ScenarioPlannerScreenState extends ConsumerState<ScenarioPlannerScreen> {
  String? _selectedBaseTimetableId;
  final Set<String> _selectedFailureCourses = {};
  final List<Scenario> _scenarios = [];

  @override
  void initState() {
    super.initState();
    // Fetch timetables when screen loads
    Future.microtask(() => ref.read(timetableProvider.notifier).fetchTimetables());
  }

  Timetable? get _selectedTimetable {
    final timetablesAsync = ref.watch(timetableProvider);
    if (_selectedBaseTimetableId == null || !timetablesAsync.hasValue) return null;
    
    try {
      return timetablesAsync.value!.firstWhere((t) => t.id.toString() == _selectedBaseTimetableId);
    } catch (e) {
      return null;
    }
  }

  List<Timetable> get _availableAlternatives {
    final timetablesAsync = ref.watch(timetableProvider);
    final selectedTimetable = _selectedTimetable;
    
    if (selectedTimetable == null || _selectedFailureCourses.isEmpty || !timetablesAsync.hasValue) {
      return [];
    }

    // Filter timetables that don't contain any of the failed courses
    return timetablesAsync.value!
        .where((t) => t.id.toString() != _selectedBaseTimetableId)
        .where((tt) {
      if (tt.id.toString() == _selectedBaseTimetableId) return false;
      
      final hasFailedCourse = tt.items.any(
        (item) => _selectedFailureCourses.contains(item.courseCode),
      );
      
      return !hasFailedCourse;
    }).toList();
  }


  void _addScenario(String altTimetableId) {
    final selectedTimetable = _selectedTimetable;
    final timetablesAsync = ref.read(timetableProvider);
    
    if (selectedTimetable == null || !timetablesAsync.hasValue) return;
    
    final altTimetable = timetablesAsync.value!.firstWhere((t) => t.id.toString() == altTimetableId);

    // Add scenarios for each selected failure course
    setState(() {
      for (final courseCode in _selectedFailureCourses) {
        final course = selectedTimetable.items.firstWhere(
          (c) => c.courseCode == courseCode,
          orElse: () => TimetableItem(
            id: 0,
            courseId: 0,
            courseCode: courseCode,
            courseName: 'Unknown',
            credits: 0,
          ),
        );

        _scenarios.add(Scenario(
          failedCourseCode: courseCode,
          failedCourseName: course.courseName ?? 'Unknown',
          alternativeTimetableId: altTimetableId,
          alternativeTimetableName: altTimetable.name,
        ));
      }
      
      _selectedFailureCourses.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('시나리오가 추가되었습니다.')),
    );
  }

  void _removeScenario(int index) {
    setState(() {
      _scenarios.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('시나리오가 제거되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
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
                  '시나리오 계획',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '수강신청 실패 시나리오를 설정하고 대안 시간표를 준비하세요.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Select Base Timetable
                    _buildSectionCard(
                      title: '1. 기본 시간표 선택',
                      child: Column(
                        children: ref.watch(timetableProvider).when(
                          data: (timetables) => timetables.map((tt) {
                            final isSelected = _selectedBaseTimetableId == tt.id.toString();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: RadioListTile<String>(
                                value: tt.id.toString(),
                                groupValue: _selectedBaseTimetableId,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBaseTimetableId = value;
                                    _selectedFailureCourses.clear();
                                    _scenarios.clear();
                                  });
                                },
                                title: Text(tt.name),
                                subtitle: Text('${tt.items.length}개 과목'),
                                tileColor: isSelected ? Colors.blue[50] : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          loading: () => [const Center(child: CircularProgressIndicator())],
                          error: (err, stack) => [Text('Error: $err')],
                        ),
                      ),
                    ),

                    if (_selectedTimetable != null) ...[
                      const SizedBox(height: 24),

                      // Step 2: Select Failure Courses
                      _buildSectionCard(
                        title: '2. 실패 가능성이 있는 과목 선택',
                        subtitle: 'F학점을 받을 가능성이 있는 과목을 선택해주세요.',
                        child: Column(
                          children: _selectedTimetable!.items.map((course) {
                            final isSelected = _selectedFailureCourses.contains(course.courseCode);
                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedFailureCourses.add(course.courseCode!);
                                  } else {
                                    _selectedFailureCourses.remove(course.courseCode);
                                  }
                                });
                              },
                              title: Text(course.courseName ?? 'Unknown'),
                              subtitle: Text(course.professor ?? ''),
                              secondary: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            );
                          }).toList(),
                        ),
                      ),

                      if (_selectedFailureCourses.isNotEmpty) ...[
                        const SizedBox(height: 24),

                        // Step 3: Select Alternative Timetable
                        _buildSectionCard(
                          title: '3. 대안 시간표 선택',
                          subtitle: _availableAlternatives.isEmpty
                              ? '선택한 과목들을 제외한 대안 시간표가 없습니다.'
                              : null,
                          child: _availableAlternatives.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    '선택한 과목을 포함하지 않는 시간표를 먼저 만들어주세요.',
                                    style: TextStyle(color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Column(
                                  children: _availableAlternatives.map((tt) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        title: Text(tt.name),
                                        subtitle: Text('${tt.items.length}개 과목'),
                                        trailing: ElevatedButton(
                                          onPressed: () => _addScenario(tt.id.toString()),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('시나리오 추가'),
                                        ),
                                        tileColor: Colors.grey[100],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.grey[300]!),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ],

                      if (_scenarios.isNotEmpty) ...[
                        const SizedBox(height: 24),

                        // Step 4: Scenario List
                        _buildSectionCard(
                          title: '4. 설정된 시나리오',
                          child: Column(
                            children: _scenarios.asMap().entries.map((entry) {
                              final index = entry.key;
                              final scenario = entry.value;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red[100],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '실패: ${scenario.failedCourseName}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red[900],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(Icons.arrow_forward, size: 20),
                                              const SizedBox(width: 12),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '대안: ${scenario.alternativeTimetableName}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue[900],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeScenario(index),
                                      tooltip: '시나리오 제거',
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
