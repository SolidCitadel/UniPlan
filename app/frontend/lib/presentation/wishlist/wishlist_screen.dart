import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/wishlist_item.dart';
import 'wishlist_view_model.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(wishlistViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: vm.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          error: e.toString(),
          onRetry: () => ref.read(wishlistViewModelProvider.notifier).refresh(),
        ),
        data: (items) {
          final grouped = {for (var i = 1; i <= 5; i++) i: <WishlistItem>[]};
          for (final item in items) {
            grouped[item.priority]?.add(item);
          }
          for (final entry in grouped.entries) {
            entry.value.sort((a, b) => a.courseName.compareTo(b.courseName));
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(wishlistViewModelProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                final priority = index + 1;
                final list = grouped[priority] ?? [];
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : AppTokens.space3),
                  child: _PrioritySection(
                    priority: priority,
                    items: list,
                    onRemove: (item) =>
                        ref.read(wishlistViewModelProvider.notifier).remove(item.courseId),
                    onChangePriority: (item, p) =>
                        ref.read(wishlistViewModelProvider.notifier).movePriority(item, p),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PrioritySection extends StatelessWidget {
  const _PrioritySection({
    required this.priority,
    required this.items,
    required this.onRemove,
    required this.onChangePriority,
  });

  final int priority;
  final List<WishlistItem> items;
  final ValueChanged<WishlistItem> onRemove;
  final void Function(WishlistItem item, int newPriority) onChangePriority;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTokens.primaryMuted,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('우선순위 $priority', style: AppTokens.body),
                ),
                const SizedBox(width: AppTokens.space2),
                Text('프로토타입: 우선순위별 그룹', style: AppTokens.caption),
              ],
            ),
            const SizedBox(height: AppTokens.space3),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppTokens.space2),
                child: Text('아직 담긴 강의가 없습니다.', style: AppTokens.caption),
              )
            else
              Column(
                children: items
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTokens.space2),
                          child: _WishlistTile(
                            item: item,
                            onRemove: () => onRemove(item),
                            onChangePriority: (p) => onChangePriority(item, p),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  const _WishlistTile({
    required this.item,
    required this.onRemove,
    required this.onChangePriority,
  });

  final WishlistItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onChangePriority;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTokens.border),
        borderRadius: BorderRadius.circular(AppTokens.radius4),
      ),
      padding: const EdgeInsets.all(AppTokens.space3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.courseName, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(item.professor, style: AppTokens.caption),
              ],
            ),
          ),
          _PriorityMenu(
            current: item.priority,
            onSelected: onChangePriority,
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppTokens.error),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }
}

class _PriorityMenu extends StatelessWidget {
  const _PriorityMenu({required this.current, required this.onSelected});

  final int current;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: '우선순위 변경',
      onSelected: onSelected,
      itemBuilder: (context) => List.generate(
        5,
        (index) {
          final value = index + 1;
          return PopupMenuItem(
            value: value,
            enabled: value != current,
            child: Row(
              children: [
                if (value == current) const Icon(Icons.check, size: 16),
                if (value == current) const SizedBox(width: 6),
                Text('우선순위 $value'),
              ],
            ),
          );
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTokens.primaryMuted,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('P$current', style: AppTokens.body),
            const Icon(Icons.expand_more, size: 18),
          ],
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
