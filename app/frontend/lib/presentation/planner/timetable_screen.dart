import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/entities/wishlist_item.dart' hide ClassTime;
import '../wishlist/wishlist_view_model.dart';
import 'timetable_view_model.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> {
  final _nameCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '2025');
  final _semesterCtrl = TextEditingController(text: '1');
  int? _selectedId;
  Timetable? _editing;
  _EditorTab _editorTab = _EditorTab.available;
  bool _isEditingLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    final year = int.tryParse(_yearCtrl.text.trim());
    final sem = _semesterCtrl.text.trim();
    if (name.isEmpty || year == null || sem.isEmpty) return;
    await ref.read(timetableViewModelProvider.notifier).create(
          name: name,
          openingYear: year,
          semester: sem,
        );
    _nameCtrl.clear();
  }

  void _select(int id) {
    _openEditor(id);
  }

  Future<void> _openEditor(int id) async {
    setState(() {
      _isEditingLoading = true;
      _selectedId = id;
      _editorTab = _EditorTab.available;
    });
    final one = await ref.read(timetableViewModelProvider.notifier).fetchOne(id);
    setState(() {
      _editing = one;
      _isEditingLoading = false;
    });
  }

  void _closeEditor() {
    setState(() {
      _selectedId = null;
      _editing = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(timetableViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: _editingView(vm),
    );
  }

  Widget _editingView(AsyncValue<List<Timetable>> vm) {
    if (_selectedId != null && _editing != null) {
      return _EditingOnly(
        timetable: _editing!,
        onBack: _closeEditor,
        tab: _editorTab,
        onTabChange: (t) => setState(() => _editorTab = t),
        isLoading: _isEditingLoading,
        onRefreshEditing: () => _openEditor(_editing!.id),
        onRemoveCourse: (courseId) => ref
            .read(timetableViewModelProvider.notifier)
            .removeCourse(_editing!.id, courseId)
            .then((_) => _openEditor(_editing!.id)),
        onAddCourse: (courseId) => ref
            .read(timetableViewModelProvider.notifier)
            .addCourse(_editing!.id, courseId)
            .then((_) => _openEditor(_editing!.id)),
        onCreateAlternative: (excludedIds, name) async {
          setState(() {
            _isEditingLoading = true;
          });
          final alt = await ref.read(timetableViewModelProvider.notifier).createAlternative(
                parentTimetableId: _editing!.id,
                name: name,
                openingYear: _editing!.openingYear,
                semester: _editing!.semester,
                excludedCourseIds: excludedIds,
              );
          if (alt != null) {
            setState(() {
              _editing = alt;
              _selectedId = alt.id;
            });
          }
          setState(() {
            _isEditingLoading = false;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('시간표 생성'),
            onPressed: () => _showCreateDialog(context),
          ),
        ),
        const SizedBox(height: AppTokens.space4),
        Expanded(
          child: vm.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorView(
              error: e.toString(),
              onRetry: () => ref.read(timetableViewModelProvider.notifier).refresh(),
            ),
            data: (list) {
              if (list.isEmpty) {
                return const Center(child: Text('시간표가 없습니다. 새로 만들어주세요.'));
              }
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.space3),
                  child: _TimetableList(
                    timetables: list,
                    selectedId: _selectedId,
                    onSelect: _select,
                    onDelete: (id) => ref.read(timetableViewModelProvider.notifier).deleteTimetable(id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('시간표 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: _yearCtrl,
                decoration: const InputDecoration(labelText: '연도'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _semesterCtrl,
                decoration: const InputDecoration(labelText: '학기'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('취소')),
            ElevatedButton(
              onPressed: () async {
                await _create();
                if (context.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('생성'),
            ),
          ],
        );
      },
    );
  }
}

class _TimetableList extends StatelessWidget {
  const _TimetableList({
    required this.timetables,
    required this.selectedId,
    required this.onSelect,
    required this.onDelete,
  });

  final List<Timetable> timetables;
  final int? selectedId;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: timetables.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final t = timetables[index];
          final selected = t.id == selectedId;
          return ListTile(
            selected: selected,
            selectedTileColor: AppTokens.primaryMuted,
            title: Text(t.name, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
            subtitle: Text('${t.openingYear}년 · ${t.semester}학기', style: AppTokens.caption),
            onTap: () => onSelect(t.id),
            trailing: IconButton(
              onPressed: () => onDelete(t.id),
              icon: const Icon(Icons.delete_outline, color: AppTokens.error),
            ),
          );
        },
      ),
    );
  }
}

class _EditingOnly extends ConsumerStatefulWidget {
  const _EditingOnly({
    required this.timetable,
    required this.onBack,
    required this.tab,
    required this.onTabChange,
    required this.isLoading,
    required this.onRefreshEditing,
    required this.onRemoveCourse,
    required this.onAddCourse,
    required this.onCreateAlternative,
  });

  final Timetable timetable;
  final VoidCallback onBack;
  final _EditorTab tab;
  final ValueChanged<_EditorTab> onTabChange;
  final bool isLoading;
  final Future<void> Function() onRefreshEditing;
  final ValueChanged<int> onRemoveCourse;
  final ValueChanged<int> onAddCourse;
  final Future<void> Function(List<int> excludedCourseIds, String name) onCreateAlternative;

  @override
  ConsumerState<_EditingOnly> createState() => _EditingOnlyState();
}

class _EditingOnlyState extends ConsumerState<_EditingOnly> {
  bool _altMode = false;
  bool _submitting = false;
  final Set<int> _excluded = {};

  void _toggleSelect(int courseId) {
    if (!_altMode) return;
    setState(() {
      if (_excluded.contains(courseId)) {
        _excluded.remove(courseId);
      } else {
        _excluded.add(courseId);
      }
    });
  }

  Future<void> _confirmAlternative() async {
    if (_excluded.isEmpty) return;
    final nameCtrl = TextEditingController(text: '${widget.timetable.name} 대안');
    final confirmed = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('대안 시간표 생성'),
          content: TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('취소')),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(nameCtrl.text.trim()),
              child: const Text('생성'),
            ),
          ],
        );
      },
    );
    if (confirmed == null || confirmed.isEmpty) return;
    setState(() {
      _submitting = true;
    });
    await widget.onCreateAlternative(_excluded.toList(), confirmed);
    setState(() {
      _submitting = false;
      _altMode = false;
      _excluded.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timetable = widget.timetable;
    final conflicts = _buildConflicts(timetable.items);
    final excluded = timetable.excludedCourseIds;
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistCourses = wishlistState.asData?.value ?? [];
    final currentIds = timetable.items.map((e) => e.courseId).toSet();

    final availableAll = wishlistCourses.where((w) => !currentIds.contains(w.courseId)).toList();
    final available = <WishlistItem>[];
    final conflictCandidates = <WishlistItem>[];
    for (final w in availableAll) {
      final candidateTimes =
          w.classTimes.map((c) => ClassTime(day: c.day, startTime: c.startTime, endTime: c.endTime)).toList();
      if (candidateTimes.isEmpty || _overlapsWithTimetable(candidateTimes, timetable.items)) {
        conflictCandidates.add(w);
      } else {
        available.add(w);
      }
    }

    Widget tabBody;
    switch (widget.tab) {
      case _EditorTab.available:
        tabBody = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: available.isEmpty
              ? [Text('추가할 수 있는 과목이 없습니다.', style: AppTokens.caption)]
              : available
                  .map(
                    (w) => MouseRegion(
                      onEnter: (_) {
                        if (w.classTimes.isNotEmpty) {
                          ref.read(previewCourseProvider.notifier).setPreview(w);
                        }
                      },
                      onExit: (_) => ref.read(previewCourseProvider.notifier).clear(),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(w.courseName),
                        subtitle: Text(w.professor, style: AppTokens.caption),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppTokens.primary),
                          onPressed: () => widget.onAddCourse(w.courseId),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        );
        break;
      case _EditorTab.conflicts:
        tabBody = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (conflicts.isNotEmpty) ...[
              Text('현재 시간표 내 겹치는 과목', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppTokens.space2),
              ...conflicts.map(
                (pair) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTokens.space2),
                  child: Text(pair, style: AppTokens.body),
                ),
              ),
              const SizedBox(height: AppTokens.space3),
            ],
            if (conflictCandidates.isNotEmpty) ...[
              Text('시간이 겹쳐 추가 불가', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppTokens.space2),
              ...conflictCandidates.map(
                (w) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(w.courseName),
                  subtitle: Text(w.professor, style: AppTokens.caption),
                  trailing: const Icon(Icons.block, size: 18, color: AppTokens.error),
                ),
              ),
            ] else ...[
              Text('시간이 겹치는 추가 대상이 없습니다.', style: AppTokens.caption),
            ],
          ],
        );
        break;
      case _EditorTab.excluded:
        tabBody = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: excluded.isEmpty
              ? [Text('제외된 과목이 없습니다.', style: AppTokens.caption)]
              : excluded
                  .map((id) => Padding(
                        padding: const EdgeInsets.only(bottom: AppTokens.space2),
                        child: Text('courseId $id'),
                      ))
                  .toList(),
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${timetable.name} 편집', style: AppTokens.heading),
            Row(
              children: [
                if (_altMode)
                  Padding(
                    padding: const EdgeInsets.only(right: AppTokens.space2),
                    child: Text('제외할 과목을 선택하세요', style: AppTokens.caption),
                  ),
                if (_altMode)
                  TextButton(
                    onPressed: _submitting
                        ? null
                        : () {
                            setState(() {
                              _altMode = false;
                              _excluded.clear();
                            });
                            ref.read(previewCourseProvider.notifier).clear();
                          },
                    child: const Text('취소'),
                  ),
                const SizedBox(width: AppTokens.space2),
                if (_altMode)
                  ElevatedButton.icon(
                    onPressed: _submitting || _excluded.isEmpty ? null : _confirmAlternative,
                    icon: const Icon(Icons.alt_route),
                    label: _submitting ? const Text('생성 중...') : const Text('대안 생성'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _altMode = true;
                        _excluded.clear();
                      });
                    },
                    icon: const Icon(Icons.alt_route),
                    label: const Text('대안 시간표 생성'),
                  ),
                const SizedBox(width: AppTokens.space2),
                Text('과목 ${timetable.items.length}개', style: AppTokens.caption),
                const SizedBox(width: AppTokens.space3),
                OutlinedButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('목록으로'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppTokens.space3),
        if (widget.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 340,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTokens.space3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: AppTokens.space2,
                                        children: _EditorTab.values
                                            .map(
                                              (t) => ChoiceChip(
                                                label: Text(_labelForTab(t)),
                                                selected: widget.tab == t,
                                                onSelected: (_) => widget.onTabChange(t),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: AppTokens.space3),
                                      tabBody,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space3),
                            Expanded(
                              flex: 2,
                              child: _TimetableGrid(
                                items: timetable.items,
                                conflicts: conflicts,
                                onRemoveCourse: widget.onRemoveCourse,
                                preview: ref.watch(previewCourseProvider),
                                selectionMode: _altMode,
                                selectedCourseIds: _excluded,
                                onSelectCourse: _toggleSelect,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

enum _EditorTab { available, conflicts, excluded }

String _labelForTab(_EditorTab tab) {
  switch (tab) {
    case _EditorTab.available:
      return '추가 가능';
    case _EditorTab.conflicts:
      return '시간 겹침';
    case _EditorTab.excluded:
      return '제외됨';
  }
}

final previewCourseProvider = NotifierProvider<_PreviewNotifier, PreviewData?>(_PreviewNotifier.new);

class _PreviewNotifier extends Notifier<PreviewData?> {
  @override
  PreviewData? build() => null;

  void setPreview(WishlistItem item) {
    state = PreviewData(
      item: TimetableItem(
        id: -1,
        courseId: item.courseId,
        courseName: item.courseName,
        professor: item.professor,
        classroom: item.classroom,
        classTimes:
            item.classTimes.map((c) => ClassTime(day: c.day, startTime: c.startTime, endTime: c.endTime)).toList(),
      ),
    );
  }

  void clear() => state = null;
}

class PreviewData {
  PreviewData({required this.item});
  final TimetableItem item;
}

bool _overlapsWithTimetable(List<ClassTime> candidate, List<TimetableItem> items) {
  for (final t in items) {
    if (_hasOverlap(candidate, t.classTimes)) return true;
  }
  return false;
}
class _TimetableGrid extends StatelessWidget {
  const _TimetableGrid({
    required this.items,
    required this.conflicts,
    required this.onRemoveCourse,
    required this.preview,
    this.selectionMode = false,
    this.selectedCourseIds = const {},
    this.onSelectCourse,
  });

  final List<TimetableItem> items;
  final Set<String> conflicts;
  final ValueChanged<int> onRemoveCourse;
  final PreviewData? preview;
  final bool selectionMode;
  final Set<int> selectedCourseIds;
  final ValueChanged<int>? onSelectCourse;

  static const days = ['월', '화', '수', '목', '금'];
  static const double gridHeight = 640;
  static const int startHour = 9;
  static const int endHour = 21;

  @override
  Widget build(BuildContext context) {
    final baseMinutes = startHour * 60;
    final totalMinutes = (endHour - startHour) * 60;

    List<_PlacedBlock> placed = [];
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

    if (preview?.item != null) {
      final p = preview!.item;
      for (final slot in p.classTimes) {
        final start = _toMinutes(slot.startTime);
        final end = _toMinutes(slot.endTime);
        final top = ((start - baseMinutes) / totalMinutes) * gridHeight;
        final height = ((end - start) / totalMinutes) * gridHeight;
        placed.add(_PlacedBlock(
          item: p,
          day: slot.day,
          top: top.clamp(0, gridHeight),
          height: height,
          isPreview: true,
        ));
      }
    }

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
                                      onRemoveCourse: onRemoveCourse,
                                      isPreview: block.isPreview,
                                      selectionMode: selectionMode,
                                      isSelected: selectedCourseIds.contains(block.item.courseId),
                                      onSelect: onSelectCourse,
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
    required this.onRemoveCourse,
    this.isPreview = false,
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelect,
  });

  final TimetableItem item;
  final Set<String> conflicts;
  final ValueChanged<int> onRemoveCourse;
  final bool isPreview;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final isConflict = conflicts.any((c) => c.contains(item.courseName));
    final professorText = item.professor.isNotEmpty ? item.professor : '담당 교수 미정';
    final placeText = (item.classroom ?? '').isNotEmpty ? item.classroom! : '강의실 미정';
    return GestureDetector(
      onTap: selectionMode ? () => onSelect?.call(item.courseId) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isPreview
              ? AppTokens.primary.withAlpha((0.15 * 255).toInt())
              : isConflict
                  ? AppTokens.error.withAlpha((0.1 * 255).toInt())
                  : AppTokens.primaryMuted,
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
                  Text('$professorText · $placeText', style: AppTokens.caption),
                ],
              ),
            ),
            if (!isPreview && !selectionMode)
              IconButton(
                tooltip: '시간표에서 제거',
                icon: const Icon(Icons.delete_outline, size: 18, color: AppTokens.error),
                onPressed: () => onRemoveCourse(item.courseId),
              ),
            if (selectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onSelect?.call(item.courseId),
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
    this.isPreview = false,
  });

  final TimetableItem item;
  final String day;
  final double top;
  final double height;
  final bool isPreview;
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('오류가 발생했습니다\n$error', textAlign: TextAlign.center),
          const SizedBox(height: AppTokens.space3),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

Set<String> _buildConflicts(List<TimetableItem> items) {
  final conflicts = <String>{};
  for (var i = 0; i < items.length; i++) {
    for (var j = i + 1; j < items.length; j++) {
      final a = items[i];
      final b = items[j];
      if (_hasOverlap(a.classTimes, b.classTimes)) {
        conflicts.add('${a.courseName} ↔ ${b.courseName}');
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
