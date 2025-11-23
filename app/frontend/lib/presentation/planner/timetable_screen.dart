import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/timetable.dart';
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

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(timetableViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CreateCard(
            nameCtrl: _nameCtrl,
            yearCtrl: _yearCtrl,
            semesterCtrl: _semesterCtrl,
            onCreate: _create,
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
                return RefreshIndicator(
                  onRefresh: () => ref.read(timetableViewModelProvider.notifier).refresh(),
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final t = list[index];
                      return _TimetableTile(
                        timetable: t,
                        onDelete: () => ref.read(timetableViewModelProvider.notifier).deleteTimetable(t.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateCard extends StatelessWidget {
  const _CreateCard({
    required this.nameCtrl,
    required this.yearCtrl,
    required this.semesterCtrl,
    required this.onCreate,
  });

  final TextEditingController nameCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController semesterCtrl;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('시간표 생성', style: AppTokens.heading),
            const SizedBox(height: AppTokens.space3),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: '이름',
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: yearCtrl,
                    decoration: const InputDecoration(
                      labelText: '년도',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: semesterCtrl,
                    decoration: const InputDecoration(
                      labelText: '학기',
                      prefixIcon: Icon(Icons.filter_1),
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                ElevatedButton(
                  onPressed: onCreate,
                  child: const Text('생성'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimetableTile extends StatelessWidget {
  const _TimetableTile({required this.timetable, required this.onDelete});

  final Timetable timetable;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timetable.name, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
      subtitle: Text('${timetable.openingYear}년 · ${timetable.semester}학기', style: AppTokens.caption),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline, color: AppTokens.error),
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
