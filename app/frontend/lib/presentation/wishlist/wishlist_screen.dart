import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wishlist_view_model.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  void _showPriorityDialog(int itemId, String courseName, int currentPriority) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('우선순위 변경'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$courseName의 우선순위를 변경해주세요'),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final priority = index + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(wishlistProvider.notifier).updatePriority(itemId, priority);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('우선순위가 $priority로 변경되었습니다.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: currentPriority == priority ? Colors.blue[50] : null,
                    side: BorderSide(
                      color: currentPriority == priority ? Colors.blue : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('우선순위 $priority'),
                      if (currentPriority == priority)
                        Text('현재', style: TextStyle(color: Colors.blue[600], fontSize: 12)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: wishlistState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '아직 추가된 희망과목이 없습니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '강의 목록 조회에서 과목을 추가해보세요.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          // Group by priority
          final groupedByPriority = <int, List>{};
          for (final item in items) {
            groupedByPriority.putIfAbsent(item.priority, () => []).add(item);
          }

          final priorities = groupedByPriority.keys.toList()..sort();

          return SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1280),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    '희망과목',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '우선순위별로 정리된 희망과목 목록입니다. 우선순위 변경 및 삭제가 가능합니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Priority Groups
                  ...priorities.map((priority) {
                    final courses = groupedByPriority[priority]!;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                            ),
                            child: Text(
                              '우선순위 $priority (${courses.length}개)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Table
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 24,
                              headingRowHeight: 48,
                              dataRowMinHeight: 56,
                              headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                              columns: const [
                                DataColumn(label: Text('강좌코드', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                DataColumn(label: Text('강좌명', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                DataColumn(label: Text('교수명', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                DataColumn(label: Text('관리', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                              ],
                              rows: courses.map((item) {
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.grey[50];
                                    }
                                    return null;
                                  }),
                                  cells: [
                                    DataCell(Text(item.courseId?.toString() ?? '-', style: TextStyle(fontSize: 14, color: Colors.grey[600]))),
                                    DataCell(Text(item.courseName ?? 'Unknown', style: const TextStyle(fontSize: 14))),
                                    DataCell(Text(item.professor ?? '-', style: TextStyle(fontSize: 14, color: Colors.grey[600]))),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 18),
                                            color: Colors.blue[600],
                                            tooltip: '우선순위 변경',
                                            onPressed: () => _showPriorityDialog(
                                              item.id,
                                              item.courseName ?? 'Unknown',
                                              item.priority,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, size: 18),
                                            color: Colors.red[600],
                                            tooltip: '삭제',
                                            onPressed: () {
                                              ref.read(wishlistProvider.notifier).removeFromWishlist(item.id);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('${item.courseName}이(가) 삭제되었습니다.')),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
