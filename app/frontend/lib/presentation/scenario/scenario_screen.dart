import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../planner/timetable_view_model.dart';
import 'scenario_list_view_model.dart';

class ScenarioScreen extends ConsumerWidget {
  const ScenarioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(scenarioListViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('시나리오', style: TextStyle(color: AppTokens.textStrong)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
        child: vm.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(
            error: e.toString(),
            onRetry: () => ref.read(scenarioListViewModelProvider.notifier).refresh(),
          ),
          data: (list) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('시나리오 추가'),
                  ),
                ),
                const SizedBox(height: AppTokens.space3),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('시나리오가 없습니다. 새로 추가해 주세요.'))
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final s = list[index];
                            return ListTile(
                              title: Text(s.name, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                              subtitle: Text(
                                s.description ?? (s.parentId == null ? '루트 시나리오' : '부모 ${s.parentId}'),
                                style: AppTokens.caption,
                              ),
                              onTap: () => context.push('/app/scenario/${s.id}'),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final timetableList = ref.read(timetableViewModelProvider).asData?.value ?? [];
    if (timetableList.isEmpty) {
      await ref.read(timetableViewModelProvider.notifier).refresh();
    }
    if (!context.mounted) return;

    final timetables = ref.read(timetableViewModelProvider).asData?.value ?? [];
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? selectedTimetableId;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
          title: const Text('시나리오 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: '설명(선택)'),
              ),
              const SizedBox(height: AppTokens.space2),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: '기반 시간표'),
                items: timetables
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.id,
                        child: Text('${t.name} (${t.openingYear}년 ${t.semester})'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => selectedTimetableId = v,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('확인')),
          ],
        );
      },
    );

    if (result != true) return;
    final name = nameCtrl.text.trim();
    final desc = descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim();
    if (name.isEmpty || selectedTimetableId == null) return;

    final created = await ref.read(scenarioListViewModelProvider.notifier).create(
          name: name,
          description: desc,
          timetableId: selectedTimetableId!,
        );
    if (!context.mounted) return;
    if (created != null) {
      context.push('/app/scenario/${created.id}');
    }
  }
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
