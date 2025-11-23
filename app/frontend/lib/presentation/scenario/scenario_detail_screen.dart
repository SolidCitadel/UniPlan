import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/timetable.dart';
import '../planner/timetable_view_model.dart';
import '../wishlist/wishlist_view_model.dart';
import 'scenario_detail_view_model.dart';

class ScenarioDetailScreen extends ConsumerWidget {
  const ScenarioDetailScreen({super.key, required this.scenarioId});

  final int scenarioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(scenarioDetailViewModelProvider(scenarioId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('시나리오 상세', style: TextStyle(color: AppTokens.textStrong)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ),
      body: vm.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (scenario) {
          if (scenario == null) {
            return const Center(child: Text('시나리오를 불러오지 못했습니다.'));
          }
          return ScenarioEditor(
            scenarioId: scenarioId,
            timetableId: scenario.timetableId,
          );
        },
      ),
    );
  }
}

class ScenarioEditor extends ConsumerStatefulWidget {
  const ScenarioEditor({super.key, required this.scenarioId, required this.timetableId});

  final int scenarioId;
  final int timetableId;

  @override
  ConsumerState<ScenarioEditor> createState() => _ScenarioEditorState();
}

class _ScenarioEditorState extends ConsumerState<ScenarioEditor> {
  final Set<int> _toggleCourses = {};
  int? _selectedAltTimetableId;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableViewModelProvider);
    final timetables = timetableState.asData?.value ?? <Timetable>[];
    Timetable? timetable;
    for (final t in timetables) {
      if (t.id == widget.timetableId) {
        timetable = t;
        break;
      }
    }

    final wishlistState = ref.watch(wishlistViewModelProvider);
    final altOptions = timetables.where((t) => t.id != widget.timetableId).toList();

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: timetable == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('시간표 정보를 불러오는 중입니다.'),
                const SizedBox(height: AppTokens.space2),
                TextButton(
                  onPressed: () => ref.read(timetableViewModelProvider.notifier).refresh(),
                  child: const Text('새로 고침'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        Text('${timetable.name} 기반', style: AppTokens.heading),
                        const SizedBox(width: AppTokens.space2),
                        Text('과목 ${timetable.items.length}개', style: AppTokens.caption),
                      ],
                    ),
                    Row(
                      children: [
                        DropdownButton<int>(
                          hint: const Text('대안 시간표 선택'),
                          value: _selectedAltTimetableId,
                          items: altOptions
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t.id,
                                  child: Text('${t.name} (${t.openingYear}/${t.semester})'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedAltTimetableId = v),
                        ),
                        const SizedBox(width: AppTokens.space2),
                        ElevatedButton.icon(
                          onPressed: _submitting ? null : _createAlternative,
                          icon: const Icon(Icons.alt_route),
                          label: _submitting ? const Text('생성 중...') : const Text('대안 생성'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space3),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 360,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppTokens.space3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('제외할 과목 선택', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: AppTokens.space2),
                                Expanded(
                                  child: ListView(
                                    children: timetable.items
                                        .map(
                                          (item) => CheckboxListTile(
                                            value: _toggleCourses.contains(item.courseId),
                                            onChanged: (_) => setState(() {
                                              if (_toggleCourses.contains(item.courseId)) {
                                                _toggleCourses.remove(item.courseId);
                                              } else {
                                                _toggleCourses.add(item.courseId);
                                              }
                                            }),
                                            title: Text(item.courseName),
                                            subtitle: Text(
                                              item.professor.isEmpty ? '담당 교수 미정' : item.professor,
                                              style: AppTokens.caption,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: AppTokens.space3),
                                Text('위시리스트에서 제외 추가', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: AppTokens.space2),
                                Expanded(
                                  child: wishlistState.when(
                                    loading: () => const Center(child: CircularProgressIndicator()),
                                    error: (e, _) => Text('오류: $e'),
                                    data: (items) => ListView(
                                      children: items
                                          .map(
                                            (w) => CheckboxListTile(
                                              value: _toggleCourses.contains(w.courseId),
                                              onChanged: (_) => setState(() {
                                                if (_toggleCourses.contains(w.courseId)) {
                                                  _toggleCourses.remove(w.courseId);
                                                } else {
                                                  _toggleCourses.add(w.courseId);
                                                }
                                              }),
                                              title: Text(w.courseName),
                                              subtitle: Text(
                                                w.professor.isEmpty ? '담당 교수 미정' : w.professor,
                                                style: AppTokens.caption,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTokens.space3),
                      Expanded(
                        flex: 2,
                        child: _ScenarioGrid(
                          items: timetable.items,
                          selected: _toggleCourses,
                          onToggle: (id) => setState(() {
                            if (_toggleCourses.contains(id)) {
                              _toggleCourses.remove(id);
                            } else {
                              _toggleCourses.add(id);
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _createAlternative() async {
    if (_selectedAltTimetableId == null || _toggleCourses.isEmpty) return;

    setState(() => _submitting = true);
    final nameCtrl = TextEditingController(text: '대안 시나리오');
    final descCtrl = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('대안 시나리오 이름'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '이름')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: '설명(선택)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('취소')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(nameCtrl.text.trim()), child: const Text('확인')),
          ],
        );
      },
    );

    if (!mounted) return;
    if (name == null || name.isEmpty) {
      setState(() => _submitting = false);
      return;
    }

    await ref.read(scenarioDetailViewModelProvider(widget.scenarioId).notifier).createAlternative(
          name: name,
          description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
          timetableId: _selectedAltTimetableId!,
          excludedCourseIds: _toggleCourses.toList(),
        );

    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('대안 시나리오가 생성되었습니다.')),
    );
  }
}

class _ScenarioGrid extends StatelessWidget {
  const _ScenarioGrid({
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  final List<TimetableItem> items;
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  static const days = ['월', '화', '수', '목', '금'];
  static const double gridHeight = 640;
  static const int startHour = 9;
  static const int endHour = 21;

  @override
  Widget build(BuildContext context) {
    final baseMinutes = startHour * 60;
    final totalMinutes = (endHour - startHour) * 60;
    final placed = <_PlacedBlock>[];
    for (final item in items) {
      for (final slot in item.classTimes) {
        final start = _toMinutes(slot.startTime);
        final end = _toMinutes(slot.endTime);
        final top = ((start - baseMinutes) / totalMinutes) * gridHeight;
        final height = ((end - start) / totalMinutes) * gridHeight;
        placed.add(_PlacedBlock(
          item: item,
          day: slot.day,
          top: top.clamp(0, gridHeight),
          height: height,
        ));
      }
    }

    final conflicts = _buildConflicts(items);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주간 그리드', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppTokens.space2),
            SizedBox(
              height: gridHeight + 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TimeRail(
                    baseMinutes: baseMinutes,
                    endMinutes: endHour * 60,
                    height: gridHeight,
                    startHour: startHour,
                    endHour: endHour,
                  ),
                  const SizedBox(width: AppTokens.space2),
                  Expanded(
                    child: Row(
                      children: [
                        for (final day in days)
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: gridHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: AppTokens.border),
                                      bottom: BorderSide(color: AppTokens.border),
                                    ),
                                  ),
                                ),
                                for (final block in placed.where((b) => b.day == day))
                                  Positioned(
                                    top: block.top,
                                    left: 4,
                                    right: 4,
                                    height: block.height,
                                    child: _BlockTile(
                                      item: block.item,
                                      conflicts: conflicts,
                                      onSelect: onToggle,
                                      isSelected: selected.contains(block.item.courseId),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeRail extends StatelessWidget {
  const _TimeRail({
    required this.baseMinutes,
    required this.endMinutes,
    required this.height,
    required this.startHour,
    required this.endHour,
  });

  final int baseMinutes;
  final int endMinutes;
  final double height;
  final int startHour;
  final int endHour;

  @override
  Widget build(BuildContext context) {
    final totalMinutes = endMinutes - baseMinutes;
    final ticks = <int>[];
    for (int h = startHour; h <= endHour; h++) {
      ticks.add(h * 60);
    }
    return SizedBox(
      width: 48,
      child: Stack(
        children: [
          for (final tick in ticks)
            Positioned(
              top: ((tick - baseMinutes) / totalMinutes) * height - 8,
              left: 0,
              right: 0,
              child: Text(
                '${(tick ~/ 60).toString().padLeft(2, '0')}:00',
                style: AppTokens.caption,
              ),
            ),
          Positioned.fill(
            child: Column(
              children: List.generate(
                ticks.length - 1,
                (i) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTokens.border)),
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
}

class _BlockTile extends StatelessWidget {
  const _BlockTile({
    required this.item,
    required this.conflicts,
    required this.onSelect,
    this.isSelected = false,
  });

  final TimetableItem item;
  final Set<String> conflicts;
  final ValueChanged<int> onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isConflict = conflicts.any((c) => c.contains(item.courseName));
    final professorText = item.professor.isNotEmpty ? item.professor : '담당 교수 미정';
    final placeText = (item.classroom ?? '').isNotEmpty ? item.classroom! : '강의실 미정';
    return GestureDetector(
      onTap: () => onSelect(item.courseId),
      child: Container(
        decoration: BoxDecoration(
          color: isConflict ? AppTokens.error.withAlpha((0.1 * 255).toInt()) : AppTokens.primaryMuted,
          borderRadius: BorderRadius.circular(AppTokens.radius4),
          border: Border.all(
            color: isSelected
                ? AppTokens.primary
                : isConflict
                    ? AppTokens.error
                    : AppTokens.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppTokens.space2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.courseName, style: AppTokens.body),
                  Text('$professorText / $placeText', style: AppTokens.caption),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onSelect(item.courseId),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlacedBlock {
  _PlacedBlock({
    required this.item,
    required this.day,
    required this.top,
    required this.height,
  });

  final TimetableItem item;
  final String day;
  final double top;
  final double height;
}

Set<String> _buildConflicts(List<TimetableItem> items) {
  final conflicts = <String>{};
  for (var i = 0; i < items.length; i++) {
    for (var j = i + 1; j < items.length; j++) {
      final a = items[i];
      final b = items[j];
      if (_hasOverlap(a.classTimes, b.classTimes)) {
        conflicts.add('${a.courseName} vs ${b.courseName}');
      }
    }
  }
  return conflicts;
}

bool _hasOverlap(List<ClassTime> a, List<ClassTime> b) {
  for (final ca in a) {
    for (final cb in b) {
      if (ca.day != cb.day) continue;
      final aStart = _toMinutes(ca.startTime);
      final aEnd = _toMinutes(ca.endTime);
      final bStart = _toMinutes(cb.startTime);
      final bEnd = _toMinutes(cb.endTime);
      if (aStart < bEnd && bStart < aEnd) return true;
    }
  }
  return false;
}

int _toMinutes(String hhmm) {
  final parts = hhmm.split(':');
  if (parts.length != 2) return 0;
  final h = int.tryParse(parts[0]) ?? 0;
  final m = int.tryParse(parts[1]) ?? 0;
  return h * 60 + m;
}
