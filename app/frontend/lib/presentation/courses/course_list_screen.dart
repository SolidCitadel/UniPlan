import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/course.dart';
import '../wishlist/wishlist_view_model.dart';
import 'course_list_view_model.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({super.key});

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  final _queryCtrl = TextEditingController();
  final _profCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _campusCtrl = TextEditingController();

  @override
  void dispose() {
    _queryCtrl.dispose();
    _profCtrl.dispose();
    _deptCtrl.dispose();
    _campusCtrl.dispose();
    super.dispose();
  }

  void _search() {
    ref.read(courseListViewModelProvider.notifier).search(
          query: _queryCtrl.text.trim().isEmpty ? null : _queryCtrl.text.trim(),
          professor: _profCtrl.text.trim().isEmpty ? null : _profCtrl.text.trim(),
          department: _deptCtrl.text.trim().isEmpty ? null : _deptCtrl.text.trim(),
          campus: _campusCtrl.text.trim().isEmpty ? null : _campusCtrl.text.trim(),
        );
  }

  void _reset() {
    _queryCtrl.clear();
    _profCtrl.clear();
    _deptCtrl.clear();
    _campusCtrl.clear();
    ref.read(courseListViewModelProvider.notifier).search();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(courseListViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Filters(
            queryCtrl: _queryCtrl,
            profCtrl: _profCtrl,
            deptCtrl: _deptCtrl,
            campusCtrl: _campusCtrl,
            onSearch: _search,
            onReset: _reset,
          ),
          const SizedBox(height: AppTokens.space4),
          Expanded(
            child: vm.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorView(error: e.toString(), onRetry: _search),
              data: (page) {
                if (page.content.isEmpty) {
                  return const Center(child: Text('검색 결과가 없습니다.'));
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.space3,
                        vertical: AppTokens.space2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 ${page.totalElements}건',
                            style: AppTokens.body.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text('페이지 ${page.number + 1} / ${page.totalPages}', style: AppTokens.caption),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: page.content.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final course = page.content[index];
                          return _CourseTile(
                            course: course,
                            onAddWishlist: () => _showPriorityPicker(context, course),
                          );
                        },
                      ),
                    ),
                    _Pagination(
                      page: page.number,
                      totalPages: page.totalPages,
                      onPage: (p) => ref.read(courseListViewModelProvider.notifier).goToPage(p),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPriorityPicker(BuildContext context, Course course) async {
    final notifier = ref.read(wishlistViewModelProvider.notifier);
    final priority = await showModalBottomSheet<int>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위시리스트 우선순위 선택', style: AppTokens.heading),
              const SizedBox(height: AppTokens.space3),
              Wrap(
                spacing: AppTokens.space2,
                children: List.generate(5, (i) {
                  final value = i + 1;
                  return ChoiceChip(
                    label: Text('우선순위 $value'),
                    selected: false,
                    onSelected: (_) => Navigator.of(ctx).pop(value),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );

    if (priority != null) {
      try {
        await notifier.add(course.id, priority);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('위시리스트에 추가됨 (우선순위 $priority): ${course.courseName}')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('추가 실패: $e')),
          );
        }
      }
    }
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.queryCtrl,
    required this.profCtrl,
    required this.deptCtrl,
    required this.campusCtrl,
    required this.onSearch,
    required this.onReset,
  });

  final TextEditingController queryCtrl;
  final TextEditingController profCtrl;
  final TextEditingController deptCtrl;
  final TextEditingController campusCtrl;
  final VoidCallback onSearch;
  final VoidCallback onReset;

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
            Text('강의 검색', style: AppTokens.heading),
            const SizedBox(height: AppTokens.space3),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryCtrl,
                    decoration: const InputDecoration(
                      labelText: '과목명',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                Expanded(
                  child: TextField(
                    controller: profCtrl,
                    decoration: const InputDecoration(
                      labelText: '교수명',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space3),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: deptCtrl,
                    decoration: const InputDecoration(
                      labelText: '학과 코드',
                      prefixIcon: Icon(Icons.apartment),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                Expanded(
                  child: TextField(
                    controller: campusCtrl,
                    decoration: const InputDecoration(
                      labelText: '캠퍼스',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space3),
            Row(
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('검색'),
                  ),
                ),
                const SizedBox(width: AppTokens.space3),
                OutlinedButton(
                  onPressed: onReset,
                  child: const Text('초기화'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({
    required this.course,
    required this.onAddWishlist,
  });

  final Course course;
  final VoidCallback onAddWishlist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(course.courseName, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${course.professor ?? '담당 교수 미정'} · ${course.courseCode} · ${course.campus}'),
          const SizedBox(height: 4),
          if (course.classTimes.isNotEmpty)
            Text(
              _formatClassTimes(course.classTimes),
              style: AppTokens.caption,
            ),
        ],
      ),
      trailing: Wrap(
        spacing: AppTokens.space2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${course.credits}학점', style: const TextStyle(fontWeight: FontWeight.w600)),
              if (course.classroom != null) Text(course.classroom!, style: const TextStyle(fontSize: 12)),
            ],
          ),
          IconButton(
            tooltip: '위시리스트에 추가',
            icon: const Icon(Icons.bookmark_add_outlined, color: AppTokens.primary),
            onPressed: onAddWishlist,
          ),
        ],
      ),
    );
  }

  String _formatClassTimes(List<ClassTime> times) {
    return times.map((t) => '${t.day} ${t.startTime}-${t.endTime}').join(' · ');
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.page,
    required this.totalPages,
    required this.onPage,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: page > 0 ? () => onPage(page - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Page ${page + 1} / ${totalPages == 0 ? 1 : totalPages}'),
          IconButton(
            onPressed: page + 1 < totalPages ? () => onPage(page + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
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
          const SizedBox(height: 8),
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
