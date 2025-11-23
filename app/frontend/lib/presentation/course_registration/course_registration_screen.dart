import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable.dart';
import '../timetable/timetable_view_model.dart';
import '../timetable/time_slot_utils.dart';

// Course Registration Simulation
// Simulates course registration with success/failure and auto-switching to alternatives

enum CourseStatus { pending, success, failed }

class CourseWithStatus {
  final TimetableItem course;
  CourseStatus status;

  CourseWithStatus({
    required this.course,
    this.status = CourseStatus.pending,
  });
}

class CourseRegistrationScreen extends ConsumerStatefulWidget {
  const CourseRegistrationScreen({super.key});

  @override
  ConsumerState<CourseRegistrationScreen> createState() => _CourseRegistrationScreenState();
}

class _CourseRegistrationScreenState extends ConsumerState<CourseRegistrationScreen> {
  int? _selectedBaseTimetableId;
  final Map<int, CourseStatus> _courseStatuses = {};
  Timetable? _currentActiveTimetable;
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(timetableProvider.notifier).fetchTimetables());
  }

  Timetable? get _selectedBaseTimetable {
    final timetablesAsync = ref.watch(timetableProvider);
    if (_selectedBaseTimetableId == null || !timetablesAsync.hasValue) return null;
    try {
      return timetablesAsync.value!.firstWhere((t) => t.id == _selectedBaseTimetableId);
    } catch (e) {
      return null;
    }
  }

  List<CourseWithStatus> get _coursesWithStatuses {
    final activeTimetable = _currentActiveTimetable ?? _selectedBaseTimetable;
    if (activeTimetable == null) return [];

    return activeTimetable.items.map((course) {
      return CourseWithStatus(
        course: course,
        status: _courseStatuses[course.courseId] ?? CourseStatus.pending,
      );
    }).toList();
  }

  void _selectBaseTimetable(int timetableId) {
    setState(() {
      _selectedBaseTimetableId = timetableId;
      _currentActiveTimetable = null;
      _courseStatuses.clear();
    });
  }

  void _setCourseStatus(int courseId, CourseStatus status) {
    setState(() {
      _courseStatuses[courseId] = status;
      
      // Auto-switch to alternative if course failed
      if (status == CourseStatus.failed) {
        _tryAutoSwitch();
      }
    });
  }

  void _tryAutoSwitch() {
    // Get all failed courses
    final failedCourseIds = _courseStatuses.entries
        .where((entry) => entry.value == CourseStatus.failed)
        .map((entry) => entry.key)
        .toSet();

    if (failedCourseIds.isEmpty) return;

    // Find best alternative that excludes all failed courses
    Timetable? bestAlternative;
    final timetables = ref.read(timetableProvider).value ?? [];
    
    for (final timetable in timetables) {
      if (timetable.id == _selectedBaseTimetableId) continue;
      
      final excludesAllFailed = failedCourseIds.every(
        (courseId) => !timetable.items.any((c) => c.courseId == courseId),
      );
      
      if (excludesAllFailed) {
        bestAlternative = timetable;
        break;
      }
    }

    if (bestAlternative != null) {
      setState(() {
        _currentActiveTimetable = bestAlternative;
        
        // Reset statuses for new courses
        _courseStatuses.clear();
        for (final course in bestAlternative!.items) {
          if (!failedCourseIds.contains(course.courseId)) {
            _courseStatuses[course.courseId] = CourseStatus.pending;
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('대안 시간표로 자동 전환: ${bestAlternative.name}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _resetSimulation() {
    setState(() {
      _courseStatuses.clear();
      _currentActiveTimetable = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('시뮬레이션이 초기화되었습니다.')),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '수강신청 시뮬레이션',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '수강신청 성공/실패를 시뮬레이션하고 자동 대안 전환을 확인하세요.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (_selectedBaseTimetableId != null)
                  ElevatedButton.icon(
                    onPressed: _resetSimulation,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('초기화'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Row(
              children: [
                // Left: Timetable Selector
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          '시간표 선택',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ref.watch(timetableProvider).when(
                          data: (timetables) => ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: timetables.map((tt) {
                              final isSelected = _selectedBaseTimetableId == tt.id;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  title: Text(tt.name),
                                  subtitle: Text('${tt.items.length}개 과목'),
                                  selected: isSelected,
                                  selectedTileColor: Colors.blue[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                                    ),
                                  ),
                                  onTap: () => _selectBaseTimetable(tt.id),
                                ),
                              );
                            }).toList(),
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text('Error: $err')),
                        ),
                      ),
                    ],
                  ),
                ),

                // Center: Course List with Status
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(32),
                    child: _selectedBaseTimetableId == null
                        ? Center(
                            child: Text(
                              '시간표를 선택해주세요',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _currentActiveTimetable != null
                                        ? '현재: ${_currentActiveTimetable!.name}'
                                        : '현재: ${_selectedBaseTimetable!.name}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_currentActiveTimetable != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '자동 전환됨',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _coursesWithStatuses.length,
                                  itemBuilder: (context, index) {
                                    final courseWithStatus = _coursesWithStatuses[index];
                                    return _buildCourseCard(courseWithStatus);
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Right: Timetable Grid
                if (_selectedBaseTimetableId != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(left: BorderSide(color: Colors.grey[300]!)),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: _buildTimetableGrid(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseWithStatus courseWithStatus) {
    final course = courseWithStatus.course;
    final status = courseWithStatus.status;

    Color cardColor;
    Color borderColor;
    IconData? statusIcon;
    Color? iconColor;

    switch (status) {
      case CourseStatus.success:
        cardColor = Colors.blue[50]!;
        borderColor = Colors.blue;
        statusIcon = Icons.check_circle;
        iconColor = Colors.blue;
        break;
      case CourseStatus.failed:
        cardColor = Colors.red[50]!;
        borderColor = Colors.red;
        statusIcon = Icons.cancel;
        iconColor = Colors.red;
        break;
      case CourseStatus.pending:
        cardColor = Colors.white;
        borderColor = Colors.grey[300]!;
        statusIcon = null;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        children: [
          if (statusIcon != null)
            Icon(statusIcon, color: iconColor, size: 32),
          if (statusIcon != null) const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.professor ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (status == CourseStatus.pending) ...[
            ElevatedButton(
              onPressed: () => _setCourseStatus(course.courseId, CourseStatus.success),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('성공'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _setCourseStatus(course.courseId, CourseStatus.failed),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('실패'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimetableGrid() {
    final activeTimetable = _currentActiveTimetable ?? _selectedBaseTimetable;
    if (activeTimetable == null) return const SizedBox();

    final days = ['월', '화', '수', '목', '금'];
    final hours = List.generate(12, (i) => 9 + i); // 9 AM to 8 PM

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '시간표',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  const SizedBox(width: 60),
                  ...days.map((day) => Expanded(
                        child: Center(
                          child: Text(day, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              ),
              const Divider(),
              
              // Grid
              Expanded(
                child: ListView.builder(
                  itemCount: hours.length,
                  itemBuilder: (context, index) {
                    final hour = hours[index];
                    return SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              TimeSlotParser.formatHour(hour.toDouble()),
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                          ),
                          ...List.generate(5, (dayIndex) {
                            final coursesInSlot = activeTimetable.items.where((course) {
                              final slots = course.classTimes.map((ct) => TimeSlotParser.fromClassTime(ct)).toList();
                              return slots.any((slot) =>
                                  slot.day == dayIndex &&
                                  hour >= slot.startHour.floor() &&
                                  hour < slot.endHour);
                            }).toList();

                            final course = coursesInSlot.isNotEmpty ? coursesInSlot.first : null;
                            final status = course != null ? _courseStatuses[course.courseId] : null;

                            Color cellColor = Colors.grey[100]!;
                            if (course != null) {
                              switch (status) {
                                case CourseStatus.success:
                                  cellColor = Colors.blue[50]!;
                                  break;
                                case CourseStatus.failed:
                                  cellColor = Colors.red[50]!;
                                  break;
                                case CourseStatus.pending:
                                  cellColor = Colors.grey[200]!;
                                  break;
                                case null:
                                  cellColor = Colors.grey[200]!;
                                  break;
                              }
                            }

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: course != null
                                    ? Center(
                                        child: Text(
                                          course.courseName ?? 'Unknown',
                                          style: const TextStyle(fontSize: 9, color: Colors.black87),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
