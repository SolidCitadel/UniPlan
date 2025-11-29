import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/timetable.dart';
import '../planner/timetable_view_model.dart';
import 'scenario_detail_view_model.dart';

class ScenarioDetailScreen extends ConsumerWidget {
  const ScenarioDetailScreen({super.key, required this.scenarioId});

  final int scenarioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(scenarioDetailViewModelProvider(scenarioId));
    return Scaffold(
      body: vm.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (scenario) {
          if (scenario == null) {
            return const Center(child: Text('시나리오를 불러오지 못했습니다.'));
          }
          return ScenarioEditor(
            scenarioId: scenarioId,
            scenarioName: scenario.name,
            timetableId: scenario.timetableId,
          );
        },
      ),
    );
  }
}

class ScenarioEditor extends ConsumerStatefulWidget {
  const ScenarioEditor({
    super.key,
    required this.scenarioId,
    required this.scenarioName,
    required this.timetableId,
  });

  final int scenarioId;
  final String scenarioName;
  final int timetableId;

  @override
  ConsumerState<ScenarioEditor> createState() => _ScenarioEditorState();
}

class _ScenarioEditorState extends ConsumerState<ScenarioEditor> {
  final Set<int> _excludedCourseIds = {};
  bool _creating = false;
  int? _creatingForTimetableId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(timetableViewModelProvider).asData?.value;
      if (current == null || current.isEmpty) {
        ref.read(timetableViewModelProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableViewModelProvider);
    final timetables = timetableState.asData?.value ?? <Timetable>[];
    Timetable? baseTimetable;
    for (final t in timetables) {
      if (t.id == widget.timetableId) {
        baseTimetable = t;
        break;
      }
    }
    baseTimetable ??= timetables.isNotEmpty ? timetables.first : null;

    final scenarioState = ref.watch(scenarioDetailViewModelProvider(widget.scenarioId));
    final scenario = scenarioState.asData?.value;

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => GoRouter.of(context).go('/app/scenario'),
                  ),
                  Text(widget.scenarioName, style: AppTokens.heading),
                  IconButton(
                    tooltip: '이름/설명 수정',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _showEditDialog(context),
                  ),
                  IconButton(
                    tooltip: '삭제',
                    icon: const Icon(Icons.delete_outline, color: AppTokens.error),
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
              IconButton(
                tooltip: '새로고침',
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(scenarioDetailViewModelProvider(widget.scenarioId));
                  ref.read(timetableViewModelProvider.notifier).refresh();
                },
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space3),
          Expanded(
            child: timetables.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 380,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppTokens.space3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('기준 시간표', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                  subtitle: baseTimetable == null
                                      ? const Text('시간표 정보를 불러올 수 없습니다.')
                                      : Text(
                                          '${baseTimetable.name} · ${baseTimetable.openingYear}년 ${baseTimetable.semester}',
                                          style: AppTokens.caption,
                                        ),
                                ),
                                const SizedBox(height: AppTokens.space3),
                                Text('제외할 과목 선택', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: AppTokens.space2),
                                Text('선택된 과목은 대안 시나리오 생성 시 제외됩니다.', style: AppTokens.caption),
                                const SizedBox(height: AppTokens.space2),
                                Text(
                                  '호환 시간표는 기준 시간표의 제외 과목 + 선택된 과목을 모두 포함하지 않는 시간표만 표시됩니다.',
                                  style: AppTokens.caption,
                                ),
                                const SizedBox(height: AppTokens.space3),
                                Expanded(
                                  child: baseTimetable == null
                                      ? Center(
                                          child: TextButton(
                                            onPressed: () => ref.read(timetableViewModelProvider.notifier).refresh(),
                                            child: const Text('시간표 다시 불러오기'),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount: baseTimetable.items.length,
                                          separatorBuilder: (_, __) => const Divider(height: 1),
                                          itemBuilder: (context, index) {
                                            final item = baseTimetable!.items[index];
                                            final selected = _excludedCourseIds.contains(item.courseId);
                                            final place = (item.classroom ?? '').isNotEmpty ? item.classroom! : '강의실 미정';
                                            final timeText = item.classTimes.isEmpty
                                                ? ''
                                                : item.classTimes.map((c) => '${c.day} ${c.startTime}-${c.endTime}').join(', ');
                                            return CheckboxListTile(
                                              value: selected,
                                              onChanged: (_) {
                                                setState(() {
                                                  if (selected) {
                                                    _excludedCourseIds.remove(item.courseId);
                                                  } else {
                                                    _excludedCourseIds.add(item.courseId);
                                                  }
                                                });
                                              },
                                              title: Text(item.courseName),
                                              subtitle: Text(
                                                '${item.professor.isNotEmpty ? item.professor : '담당 교수 미정'} · $place${timeText.isNotEmpty ? ' · $timeText' : ''}',
                                                style: AppTokens.caption,
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTokens.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTokens.space3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('호환 시간표 결과', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                          Text('제외 과목 ${_excludedCourseIds.length}개', style: AppTokens.caption),
                                        ],
                                      ),
                                      const SizedBox(height: AppTokens.space3),
                                      Expanded(
                                        child: _CompatibleList(
                                          base: baseTimetable,
                                          all: timetables,
                                          excludedCourseIds: _excludedCourseIds,
                                          onCreate: _createAlternativeWithTimetable,
                                          creating: _creating,
                                          creatingTimetableId: _creatingForTimetableId,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTokens.space3),
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTokens.space3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('시나리오 트리', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: AppTokens.space2),
                                      Text(
                                        '트리에서 노드를 탭하면 해당 시나리오 상세로 이동 후 대안을 생성할 수 있습니다.',
                                        style: AppTokens.caption,
                                      ),
                                      const SizedBox(height: AppTokens.space2),
                                      Expanded(
                                        child: scenario == null
                                            ? const Center(child: Text('트리를 불러오는 중입니다.'))
                                            : SingleChildScrollView(
                                                child: _ScenarioTree(
                                                  root: scenario,
                                                  currentId: widget.scenarioId,
                                                  depth: 0,
                                                  timetables: timetables,
                                                  onSelect: (id) {
                                                    if (id == widget.scenarioId) return;
                                                    GoRouter.of(context).go('/app/scenario/$id');
                                                  },
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }

  Future<void> _createAlternativeWithTimetable(Timetable timetable) async {
    if (_creating) return;
    if (_excludedCourseIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('실패(제외)할 과목을 한 개 이상 선택해 주세요.')),
      );
      return;
    }
    final nameCtrl = TextEditingController(text: '${timetable.name} 대안');
    final descCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('대안 시나리오 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '이름')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: '설명(선택)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('생성')),
          ],
        );
      },
    );
    if (confirmed != true) return;

    setState(() {
      _creating = true;
      _creatingForTimetableId = timetable.id;
    });

    await ref.read(scenarioDetailViewModelProvider(widget.scenarioId).notifier).createAlternative(
          name: nameCtrl.text.trim().isEmpty ? '${timetable.name} 대안' : nameCtrl.text.trim(),
          description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
          timetableId: timetable.id,
          excludedCourseIds: _excludedCourseIds.toList(),
        );

    if (!mounted) return;
    setState(() {
      _creating = false;
      _creatingForTimetableId = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('대안 시나리오가 생성되었습니다.')),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final nameCtrl = TextEditingController(text: widget.scenarioName);
    final descCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('시나리오 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '이름')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: '설명(선택)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('저장')),
          ],
        );
      },
    );
    if (ok != true) return;
    final name = nameCtrl.text.trim();
    final desc = descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim();
    if (name.isEmpty) return;
    final notifier = ref.read(scenarioDetailViewModelProvider(widget.scenarioId).notifier);
    await notifier.updateScenario(name: name, description: desc);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('시나리오가 수정되었습니다.')));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('시나리오 삭제'),
          content: const Text('이 시나리오를 삭제하면 트리에서 제거됩니다. 계속할까요?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTokens.error),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    final notifier = ref.read(scenarioDetailViewModelProvider(widget.scenarioId).notifier);
    await notifier.deleteScenario();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('시나리오가 삭제되었습니다.')));
      GoRouter.of(context).go('/app/scenario');
    }
  }
}

class _CompatibleList extends StatelessWidget {
  const _CompatibleList({
    required this.base,
    required this.all,
    required this.excludedCourseIds,
    required this.onCreate,
    required this.creating,
    required this.creatingTimetableId,
  });

  final Timetable? base;
  final List<Timetable> all;
  final Set<int> excludedCourseIds;
  final ValueChanged<Timetable> onCreate;
  final bool creating;
  final int? creatingTimetableId;

  @override
  Widget build(BuildContext context) {
    if (base == null) {
      return const Center(child: Text('기준 시간표를 불러오는 중입니다.'));
    }
    final blocked = {
      ...excludedCourseIds,
      ...base!.excludedCourses.map((c) => c.courseId),
    };
    final compatible = all.where((t) {
      if (t.id == base!.id) return false;
      if (t.openingYear != base!.openingYear || t.semester != base!.semester) return false;
      final ids = t.items.map((e) => e.courseId).toSet();
      return blocked.every((id) => !ids.contains(id));
    }).toList();

    if (compatible.isEmpty) {
      return const Center(child: Text('조건에 맞는 시간표가 없습니다.'));
    }

    return ListView.separated(
      itemCount: compatible.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final t = compatible[index];
        return ListTile(
          title: Text(t.name, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
          subtitle: Text('${t.openingYear}년 ${t.semester} · 과목 ${t.items.length}개', style: AppTokens.caption),
          trailing: ElevatedButton(
            onPressed: creating && creatingTimetableId == t.id ? null : () => onCreate(t),
            child: creating && creatingTimetableId == t.id ? const Text('생성 중...') : const Text('대안 생성'),
          ),
        );
      },
    );
  }
}

class _ScenarioTree extends StatelessWidget {
  const _ScenarioTree({
    required this.root,
    required this.currentId,
    required this.depth,
    required this.timetables,
    required this.onSelect,
  });

  final Scenario root;
  final int currentId;
  final int depth;
  final List<Timetable> timetables;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final isCurrent = root.id == currentId;
    final courseLabels = _failedLabels(root.failedCourseIds, timetables);
    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            tileColor: isCurrent ? AppTokens.primaryMuted : null,
            leading: null,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: root.name, style: AppTokens.body),
                  if (courseLabels.isNotEmpty) ...[
                    TextSpan(text: ': ', style: AppTokens.body),
                    TextSpan(
                      text: courseLabels.join(', '),
                      style: AppTokens.body.copyWith(color: AppTokens.error, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' → ',
                      style: AppTokens.body.copyWith(color: AppTokens.error, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: _timetableName(root, timetables),
                      style: AppTokens.body,
                    ),
                  ],
                ],
              ),
            ),
            subtitle: root.description != null ? Text(root.description!, style: AppTokens.caption) : null,
            trailing: isCurrent ? const Text('현재', style: TextStyle(color: AppTokens.primary)) : null,
            onTap: () => onSelect(root.id),
          ),
          if (root.children.isNotEmpty)
            ...root.children.map(
              (c) => _ScenarioTree(
                root: c,
                currentId: currentId,
                depth: depth + 1,
                timetables: timetables,
                onSelect: onSelect,
              ),
            ),
        ],
      ),
    );
  }
}

List<String> _failedLabels(List<int> failedCourseIds, List<Timetable> timetables) {
  if (failedCourseIds.isEmpty) return const [];
  final labels = <String>[];
  for (final id in failedCourseIds) {
    TimetableItem? found;
    for (final t in timetables) {
      for (final item in t.items) {
        if (item.courseId == id) {
          found = item;
          break;
        }
      }
      if (found != null) break;
    }
    if (found != null) {
      final prof = found.professor.isNotEmpty ? found.professor : '담당 교수 미정';
      labels.add('${found.courseName}($prof)');
    } else {
      labels.add('과목 $id');
    }
  }
  return labels;
}

String _timetableName(Scenario scenario, List<Timetable> timetables) {
  for (final t in timetables) {
    if (t.id == scenario.timetableId) {
      return t.name;
    }
  }
  return '시간표 ${scenario.timetableId}';
}
