import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  Future<void> _goEdit(int id) async {
    final result = await context.push('/app/timetables/$id');
    if (result == true && mounted) {
      await ref.read(timetableViewModelProvider.notifier).refresh();
    }
  }

  Future<void> _showCreateDialog() async {
    final result = await showDialog<bool>(
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
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('생성')),
          ],
        );
      },
    );
    if (result != true) return;
    final name = _nameCtrl.text.trim();
    final year = int.tryParse(_yearCtrl.text.trim());
    final sem = _semesterCtrl.text.trim();
    if (name.isEmpty || year == null || sem.isEmpty) return;
    final created = await ref.read(timetableViewModelProvider.notifier).create(
          name: name,
          openingYear: year,
          semester: sem,
        );
    if (!mounted) return;
    if (created != null) {
      await _goEdit(created.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시간표 생성 후 편집 화면으로 이동하지 못했습니다.')),
      );
    }
    _nameCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(timetableViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표 목록', style: TextStyle(color: AppTokens.textStrong)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add),
              label: const Text('시간표 생성'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
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
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final t = list[index];
                  return ListTile(
                    title: Text(t.name, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text('${t.openingYear}년 · ${t.semester}학기', style: AppTokens.caption),
                    onTap: () => _goEdit(t.id),
                    trailing: IconButton(
                      onPressed: () {
                        ref.read(timetableViewModelProvider.notifier).deleteTimetable(t.id);
                      },
                      icon: const Icon(Icons.delete_outline, color: AppTokens.error),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
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
