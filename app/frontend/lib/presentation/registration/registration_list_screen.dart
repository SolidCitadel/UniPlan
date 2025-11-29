import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/scenario.dart';
import '../scenario/scenario_list_view_model.dart';
import 'registration_list_view_model.dart';
import 'registration_view_model.dart';

class RegistrationListScreen extends ConsumerStatefulWidget {
  const RegistrationListScreen({super.key});

  @override
  ConsumerState<RegistrationListScreen> createState() => _RegistrationListScreenState();
}

class _RegistrationListScreenState extends ConsumerState<RegistrationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationListViewModelProvider.notifier).refresh();
      ref.read(scenarioListViewModelProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final regList = ref.watch(registrationListViewModelProvider);
    final scenarioList = ref.watch(scenarioListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('수강신청 세션', style: TextStyle(color: AppTokens.textStrong)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
        child: regList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(
            message: '수강신청 목록을 불러오지 못했습니다.\n$e',
            onRetry: () => ref.read(registrationListViewModelProvider.notifier).refresh(),
          ),
          data: (list) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.space3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('수강신청 세션', style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                        _StartButton(scenarioList: scenarioList),
                      ],
                    ),
                    const SizedBox(height: AppTokens.space3),
                    if (list.isEmpty)
                      const Text('등록된 수강신청이 없습니다. 새로 시작해 주세요.', style: TextStyle(color: Colors.grey))
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final r = list[index];
                            final statusText = r.status.name;
                            return ListTile(
                              title: Text('세션 #${r.id} · ${r.currentScenario.name}', style: AppTokens.body),
                              subtitle: Text('상태: $statusText', style: AppTokens.caption),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => GoRouter.of(context).go('/app/registrations/${r.id}'),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StartButton extends ConsumerStatefulWidget {
  const _StartButton({required this.scenarioList});
  final AsyncValue<List<Scenario>> scenarioList;

  @override
  ConsumerState<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<_StartButton> {
  int? _selectedId;

  @override
  Widget build(BuildContext context) {
    final scenarios = widget.scenarioList.asData?.value ?? [];
    return ElevatedButton.icon(
      onPressed: scenarios.isEmpty
          ? null
          : () async {
              _selectedId ??= scenarios.first.id;
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('시나리오 선택'),
                    content: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: '시나리오'),
                      items: scenarios
                          .map((s) => DropdownMenuItem<int>(value: s.id, child: Text('${s.name} (${s.timetableId})')))
                          .toList(),
                      onChanged: (v) => _selectedId = v,
                      initialValue: _selectedId,
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('취소')),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('시작'),
                      ),
                    ],
                  );
                },
              );
              if (!mounted || confirmed != true || _selectedId == null) return;
              final notifier = ref.read(registrationViewModelProvider.notifier);
              final created = await notifier.start(_selectedId!);
              if (created != null && context.mounted) {
                GoRouter.of(context).go('/app/registrations/${created.id}');
              }
            },
      icon: const Icon(Icons.play_circle_outline),
      label: const Text('새로 시작'),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppTokens.space3),
          OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('다시 시도')),
        ],
      ),
    );
  }
}
