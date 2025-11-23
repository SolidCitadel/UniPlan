import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'time_slot_utils.dart';
import '../wishlist/wishlist_view_model.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/entities/timetable.dart';
import 'timetable_view_model.dart';

class TimetablePlannerScreen extends ConsumerStatefulWidget {
  const TimetablePlannerScreen({super.key});

  @override
  ConsumerState<TimetablePlannerScreen> createState() => _TimetablePlannerScreenState();
}

class _TimetablePlannerScreenState extends ConsumerState<TimetablePlannerScreen> {
 int? _editingTimetableId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(timetableProvider.notifier).fetchTimetables());
  }

  Timetable? get _currentTimetable {
    final timetablesAsync = ref.watch(timetableProvider);
    if (_editingTimetableId == null || !timetablesAsync.hasValue) return null;
    try {
      return timetablesAsync.value!.firstWhere((t) => t.id == _editingTimetableId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _createNewTimetable() async {
    final timetablesAsync = ref.read(timetableProvider);
    final count = timetablesAsync.value?.length ?? 0;
    
    await ref.read(timetableProvider.notifier).createTimetable(
      name: '기본 시간표 ${count + 1}',
      openingYear: 2025,
      semester: '2학기',
    );

    final updatedTimetables = ref.read(timetableProvider).value;
    if (updatedTimetables != null && updatedTimetables.isNotEmpty) {
      setState(() {
        _editingTimetableId = updatedTimetables.last.id;
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 시간표가 생성되었습니다.')),
      );
    }
  }

  Future<void> _deleteTimetable(int timetableId) async {
    await ref.read(timetableProvider.notifier).deleteTimetable(timetableId);
    setState(() {
      _editingTimetableId = null;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시간표가 삭제되었습니다.')),
      );
    }
  }

  Future<void> _handleCourseAdd(WishlistItem item) async {
    final currentTimetable = _currentTimetable;
    if (currentTimetable == null) return;

    if (currentTimetable.items.any((c) => c.courseId == item.courseId)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 추가된 과목입니다.')),
        );
      }
      return;
    }

    await ref.read(timetableProvider.notifier).addCourseToTimetable(currentTimetable.id, item.courseId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.courseName}이(가) 시간표에 추가되었습니다.')),
      );
    }
  }

  Future<void> _removeCourseFromTimetable(int courseId) async {
    final currentTimetable = _currentTimetable;
    if (currentTimetable == null) return;

    await ref.read(timetableProvider.notifier).removeCourseFromTimetable(currentTimetable.id, courseId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('과목이 제거되었습니다.')),
      );
    }
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
                      '시간표 관리',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '시간표를 만들고 희망과목을 추가하세요.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _createNewTimetable,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('새 시간표'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _editingTimetableId == null
                ? _buildTimetableListView()
                : _buildEditView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableListView() {
    return ref.watch(timetableProvider).when(
      data: (timetables) {
        if (timetables.isEmpty) {
          return const Center(
            child: Text(
              '시간표가 없습니다. 새 시간표를 만들어주세요.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(32),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          itemCount: timetables.length,
          itemBuilder: (context, index) {
            final timetable = timetables[index];
            return _buildTimetableCard(timetable);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildTimetableCard(Timetable timetable) {
    final isSelected = _editingTimetableId == timetable.id;

    return GestureDetector(
      onTap: () => setState(() => _editingTimetableId = timetable.id),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    timetable.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _deleteTimetable(timetable.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${timetable.items.length}개 과목',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: timetable.items.isEmpty
                  ? Text(
                      '아직 추가된 과목이 없습니다',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400], fontStyle: FontStyle.italic),
                    )
                  : ListView(
                      children: timetable.items.map((course) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.courseName ?? 'Unknown',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                course.professor ?? '',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditView() {
    final currentTimetable = _currentTimetable;
    if (currentTimetable == null) {
      return const Center(child: Text('시간표를 찾을 수 없습니다'));
    }

    final wishlistAsync = ref.watch(wishlistProvider);

    return Column(
      children: [
        // Top Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () => setState(() => _editingTimetableId = null),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('목록'),
              ),
              const SizedBox(width: 12),
              Text('/', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(width: 12),
              Text(
                currentTimetable.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _deleteTimetable(currentTimetable.id),
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                label: const Text('삭제', style: TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(backgroundColor: Colors.red[50]),
              ),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: Row(
            children: [
              // Left Sidebar (Wishlist)
              Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        '희망과목 목록',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: wishlistAsync.when(
                        data: (wishlistItems) {
                          if (wishlistItems.isEmpty) {
                            return const Center(
                              child: Text('희망과목이 없습니다', style: TextStyle(color: Colors.grey)),
                            );
                          }

                          return ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: wishlistItems.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(item.courseName ?? 'Unknown', style: const TextStyle(fontSize: 14)),
                                  subtitle: Text(item.professor ?? '', style: const TextStyle(fontSize: 12)),
                                  onTap: () => _handleCourseAdd(item),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(child: Text('Error: $err')),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Side (Timetable Grid)
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(32),
                  child: _buildTimetableGrid(currentTimetable),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableGrid(Timetable timetable) {
    final days = ['월', '화', '수', '목', '금'];
    final hours = List.generate(15, (i) => 9 + i); // 9 AM to 11 PM

    return Column(
      children: [
        // Header row
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
        
        // Time slots
        Expanded(
          child: ListView.builder(
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final hour = hours[index];
              return SizedBox(
                height: 60,
                child: Row(
                  children: [
                    // Time label
                    SizedBox(
                      width: 60,
                      child: Text(
                        TimeSlotParser.formatHour(hour.toDouble()),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                    
                    // Day cells
                    ...List.generate(5, (dayIndex) {
                      final courses = timetable.items.where((course) {
                        final slots = course.classTimes.map((ct) => TimeSlotParser.fromClassTime(ct)).toList();
                        return slots.any((slot) =>
                            slot.day == dayIndex &&
                            hour >= slot.startHour.floor() &&
                            hour < slot.endHour);
                      }).toList();

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: courses.isEmpty ? Colors.grey[50] : Colors.blue[50],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: courses.isEmpty
                              ? null
                              : Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        courses.first.courseName ?? 'Unknown',
                                        style: const TextStyle(fontSize: 10, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 12),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => _removeCourseFromTimetable(courses.first.courseId),
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }
}
