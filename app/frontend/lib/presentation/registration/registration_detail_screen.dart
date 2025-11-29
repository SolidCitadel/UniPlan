import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/registration.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/timetable.dart';
import 'registration_view_model.dart';

class RegistrationDetailScreen extends ConsumerStatefulWidget {
  const RegistrationDetailScreen({super.key, required this.registrationId});

  final int registrationId;

  @override
  ConsumerState<RegistrationDetailScreen> createState() => _RegistrationDetailScreenState();
}

class _RegistrationDetailScreenState extends ConsumerState<RegistrationDetailScreen> {
  final Set<int> _succeeded = {};
  final Set<int> _failed = {};
  final Set<int> _canceled = {};
  bool _dirty = false;
  String _lastSignature = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationViewModelProvider.notifier).loadById(widget.registrationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('수강신청 상세', style: TextStyle(color: AppTokens.textStrong)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/app/registrations'),
        ),
        actions: [
          IconButton(
            tooltip: '완료 처리',
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () async {
              final updated = await ref.read(registrationViewModelProvider.notifier).complete();
              if (!context.mounted) return;
              if (updated != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('세션이 완료로 변경되었습니다')));
              }
            },
          ),
          IconButton(
            tooltip: '취소/삭제',
            icon: const Icon(Icons.delete_outline, color: AppTokens.error),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('세션 처리'),
                  content: const Text('취소/삭제 중 하나를 선택하세요'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(null),
                      child: const Text('취소 처리'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTokens.error),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('완전 삭제'),
                    ),
                  ],
                ),
              );
              if (!context.mounted) return;
              try {
                if (ok == true) {
                  await ref.read(registrationViewModelProvider.notifier).delete();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('세션이 삭제되었습니다')));
                } else if (ok == null) {
                  await ref.read(registrationViewModelProvider.notifier).cancel();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('세션이 취소되었습니다')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('처리 중 오류가 발생했습니다: $e')),
                  );
                }
              } finally {
                if (context.mounted) {
                  GoRouter.of(context).go('/app/registrations');
                }
              }
            },
          ),
        ],
      ),
      body: regState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          debugPrint('Registration load error: $e\n$st');
          return Center(child: Text('불러오는 중 오류가 발생했습니다.\n$e'));
        },
        data: (reg) {
          if (reg == null) {
            return const Center(child: Text('세션 정보를 찾을 수 없습니다.'));
          }
          final sig =
              '${reg.id}-${reg.steps.length}-${reg.succeededCourses.length}-${reg.failedCourses.length}-${reg.canceledCourses.length}';
          if (!_dirty || _lastSignature != sig) {
            _succeeded
              ..clear()
              ..addAll(reg.succeededCourses);
            _failed
              ..clear()
              ..addAll(reg.failedCourses);
            _canceled
              ..clear()
              ..addAll(reg.canceledCourses);
            _lastSignature = sig;
            _dirty = false;
          }

          final courseMapAll = _collectCoursesUnion(reg.startScenario, reg.currentScenario);
          final courseMapGrid = _collectCourses(reg.currentScenario);
          final derivedCanceled = {
            ..._canceled,
            ..._succeeded.where((id) => !courseMapGrid.containsKey(id)),
          };
          final pending = courseMapGrid.keys.toSet().difference({..._succeeded, ..._failed, ...derivedCanceled});

          final successItems = _mapIdsToItems(_succeeded, courseMapAll);
          final failedItems = _mapIdsToItems(_failed, courseMapAll);
          final pendingItems = _mapIdsToItems(pending, courseMapGrid);

          return Padding(
            padding: const EdgeInsets.all(AppTokens.space4),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 360,
                    child: _LeftPanel(
                      reg: reg,
                      succeededItems: successItems,
                      pendingItems: pendingItems,
                      failedItems: failedItems,
                      canceled: derivedCanceled,
                      onMark: _onMark,
                      onSubmitStep: _submitStep,
                    ),
                  ),
                  const SizedBox(width: AppTokens.space3),
                  Expanded(
                    child: _RegistrationGrid(
                      courseMap: courseMapGrid,
                      succeeded: _succeeded,
                      failed: _failed,
                      canceled: derivedCanceled,
                      pending: pending,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onMark(int courseId, RegistrationMarkAction action) {
    setState(() {
      switch (action) {
        case RegistrationMarkAction.toSuccess:
          _succeeded.add(courseId);
          _failed.remove(courseId);
          break;
        case RegistrationMarkAction.toFail:
          _failed.add(courseId);
          _succeeded.remove(courseId);
          break;
        case RegistrationMarkAction.toPending:
          _succeeded.remove(courseId);
          _failed.remove(courseId);
          break;
      }
      _dirty = true;
    });
  }

  Future<void> _submitStep() async {
    final reg = ref.read(registrationViewModelProvider).value;
    if (reg == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('세션 정보를 불러온 뒤 다시 시도하세요')));
      }
      return;
    }
    final courseMapGrid = _collectCourses(reg.currentScenario);
    final effectiveCanceled = {
      ..._canceled,
      ..._succeeded.where((id) => !courseMapGrid.containsKey(id)),
    };
    final res = await ref.read(registrationViewModelProvider.notifier).addStep(
          succeeded: _succeeded.toList(),
          failed: _failed.toList(),
          canceled: effectiveCanceled.toList(),
        );
    if (res == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('업데이트 실패: 콘솔 로그를 확인하세요')),
        );
      }
      return;
    }
    _succeeded
      ..clear()
      ..addAll(res.succeededCourses);
    _failed
      ..clear()
      ..addAll(res.failedCourses);
    _canceled
      ..clear()
      ..addAll(res.canceledCourses);
    _lastSignature =
        '${res.id}-${res.steps.length}-${res.succeededCourses.length}-${res.failedCourses.length}-${res.canceledCourses.length}';
    _dirty = false;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('다음 단계가 저장되었습니다')));
    }
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    required this.reg,
    required this.succeededItems,
    required this.pendingItems,
    required this.failedItems,
    required this.canceled,
    required this.onMark,
    required this.onSubmitStep,
  });

  final Registration reg;
  final List<TimetableItem> succeededItems;
  final List<TimetableItem> pendingItems;
  final List<TimetableItem> failedItems;
  final Set<int> canceled;
  final void Function(int, RegistrationMarkAction) onMark;
  final Future<void> Function() onSubmitStep;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 시나리오', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppTokens.space2),
            Text(reg.currentScenario.name, style: AppTokens.body),
            const SizedBox(height: AppTokens.space3),
            _StatusList(
              label: '신청 성공',
              color: AppTokens.success,
              courses: succeededItems,
              canceledIds: canceled,
              action: (item) => onMark(item.courseId, RegistrationMarkAction.toPending),
              actionIcon: Icons.close,
              actionTooltip: '신청 대기로 이동',
            ),
            const SizedBox(height: AppTokens.space3),
            _StatusList(
              label: '신청 대기',
              color: AppTokens.textWeak,
              courses: pendingItems,
              action: (item) => onMark(item.courseId, RegistrationMarkAction.toSuccess),
              action2: (item) => onMark(item.courseId, RegistrationMarkAction.toFail),
              actionIcon: Icons.check,
              actionIcon2: Icons.close,
              actionTooltip: '신청 성공으로 이동',
              actionTooltip2: '신청 실패로 이동',
            ),
            const SizedBox(height: AppTokens.space3),
            _StatusList(
              label: '신청 실패',
              color: AppTokens.error,
              courses: failedItems,
              action: (item) => onMark(item.courseId, RegistrationMarkAction.toSuccess),
              actionIcon: Icons.check,
              actionTooltip: '신청 성공으로 이동',
            ),
            const SizedBox(height: AppTokens.space3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSubmitStep,
                icon: const Icon(Icons.save_outlined),
                label: const Text('다음 단계 저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusList extends StatelessWidget {
  const _StatusList({
    required this.label,
    required this.color,
    required this.courses,
    required this.action,
    this.action2,
    required this.actionIcon,
    this.actionIcon2,
    this.actionTooltip,
    this.actionTooltip2,
    this.canceledIds = const {},
  });

  final String label;
  final Color color;
  final List<TimetableItem> courses;
  final Set<int> canceledIds;
  final void Function(TimetableItem) action;
  final void Function(TimetableItem)? action2;
  final IconData actionIcon;
  final IconData? actionIcon2;
  final String? actionTooltip;
  final String? actionTooltip2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: AppTokens.space2),
        if (courses.isEmpty)
          Text('없음', style: AppTokens.caption)
        else
          ...courses.map(
            (c) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                c.courseName,
                style: AppTokens.body.copyWith(
                  color: canceledIds.contains(c.courseId) ? AppTokens.error : color,
                  fontWeight: canceledIds.contains(c.courseId) ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${c.professor.isNotEmpty ? c.professor : '담당 교수 미정'} · ${(c.classroom ?? '강의실 미정')}',
                style: AppTokens.caption,
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: Icon(actionIcon, color: color),
                    tooltip: actionTooltip,
                    onPressed: () => action(c),
                  ),
                  if (action2 != null && actionIcon2 != null)
                    IconButton(
                      icon: Icon(actionIcon2, color: color),
                      tooltip: actionTooltip2,
                      onPressed: () => action2!(c),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RegistrationGrid extends StatelessWidget {
  const _RegistrationGrid({
    required this.courseMap,
    required this.succeeded,
    required this.pending,
    required this.failed,
    required this.canceled,
  });

  final Map<int, TimetableItem> courseMap;
  final Set<int> succeeded;
  final Set<int> pending;
  final Set<int> failed;
  final Set<int> canceled;

  static const days = ['월', '화', '수', '목', '금'];
  static const double gridHeight = 640;
  static const int startHour = 9;
  static const int endHour = 21;

  @override
  Widget build(BuildContext context) {
    final baseMinutes = startHour * 60;
    final totalMinutes = (endHour - startHour) * 60;

    final items = courseMap.values.toList();
    final blocks = <_PlacedBlock>[];
    for (final item in items) {
      final status = canceled.contains(item.courseId)
          ? _CourseStatus.canceled
          : succeeded.contains(item.courseId)
              ? _CourseStatus.success
              : failed.contains(item.courseId)
                  ? _CourseStatus.failed
                  : _CourseStatus.pending;
      for (final slot in item.classTimes) {
        final start = _toMinutes(slot.startTime);
        final end = _toMinutes(slot.endTime);
        final top = ((start - baseMinutes) / totalMinutes) * gridHeight;
        final height = ((end - start) / totalMinutes) * gridHeight;
        blocks.add(_PlacedBlock(
          item: item,
          day: slot.day,
          top: top.clamp(0, gridHeight),
          height: height,
          status: status,
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
                                for (final block in blocks.where((b) => b.day == day))
                                  Positioned(
                                    top: block.top,
                                    left: 4,
                                    right: 4,
                                    height: block.height,
                                    child: _BlockTile(item: block.item, status: block.status),
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

enum _CourseStatus { success, pending, failed, canceled }

class _BlockTile extends StatelessWidget {
  const _BlockTile({required this.item, required this.status});

  final TimetableItem item;
  final _CourseStatus status;

  @override
  Widget build(BuildContext context) {
    final bg = switch (status) {
      _CourseStatus.success => AppTokens.success.withValues(alpha: 0.2),
      _CourseStatus.pending => AppTokens.textWeak.withValues(alpha: 0.08),
      _CourseStatus.failed => AppTokens.error.withValues(alpha: 0.12),
      _CourseStatus.canceled => AppTokens.error.withValues(alpha: 0.1),
    };
    final border = switch (status) {
      _CourseStatus.success => AppTokens.success,
      _CourseStatus.pending => AppTokens.textWeak,
      _CourseStatus.failed => AppTokens.error,
      _CourseStatus.canceled => AppTokens.error,
    };

    final prof = item.professor.isNotEmpty ? item.professor : '담당 교수 미정';
    final place = (item.classroom ?? '').isNotEmpty ? item.classroom! : '강의실 미정';

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTokens.radius4),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(AppTokens.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.courseName, style: AppTokens.body),
          Text('$prof · $place', style: AppTokens.caption),
        ],
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
    required this.status,
  });

  final TimetableItem item;
  final String day;
  final double top;
  final double height;
  final _CourseStatus status;
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

int _toMinutes(String hhmm) {
  final parts = hhmm.split(':');
  if (parts.length != 2) return 0;
  final h = int.tryParse(parts[0]) ?? 0;
  final m = int.tryParse(parts[1]) ?? 0;
  return h * 60 + m;
}

Map<int, TimetableItem> _collectCourses(Scenario scenario) {
  final map = <int, TimetableItem>{};
  for (final item in scenario.timetable.items) {
    map[item.courseId] = item;
  }
  return map;
}

Map<int, TimetableItem> _collectCoursesUnion(Scenario a, Scenario b) {
  final map = <int, TimetableItem>{};
  void addScenario(Scenario s) {
    for (final item in s.timetable.items) {
      map[item.courseId] = item;
    }
    for (final child in s.children) {
      addScenario(child);
    }
  }

  addScenario(a);
  addScenario(b);
  return map;
}

List<TimetableItem> _mapIdsToItems(Iterable<int> ids, Map<int, TimetableItem> map) {
  return ids.map((id) {
    final found = map[id];
    if (found != null) return found;
    return TimetableItem(
      id: id,
      courseId: id,
      courseName: '알 수 없는 과목 ($id)',
      professor: '',
      classroom: '',
      classTimes: const [],
    );
  }).toList();
}

enum RegistrationMarkAction { toSuccess, toFail, toPending }
