import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'course_list_view_model.dart';
import '../wishlist/wishlist_view_model.dart';
import '../timetable/timetable_view_model.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({super.key});

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseListState = ref.watch(courseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Catalog'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onSubmitted: (value) {
                      ref.read(courseListProvider.notifier).setSearchQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Placeholder for Department Filter
                DropdownButton<String>(
                  hint: const Text('Dept'),
                  items: const [
                    DropdownMenuItem(value: 'CS', child: Text('CS')),
                    DropdownMenuItem(value: 'EE', child: Text('EE')),
                  ],
                  onChanged: (value) {
                    ref.read(courseListProvider.notifier).setDepartmentFilter(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: courseListState.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(child: Text('No courses found'));
          }
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(course.name),
                  subtitle: Text('${course.code} - ${course.professor}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${course.credits} Credits'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          ref.read(wishlistProvider.notifier).addToWishlist(course, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.name} added to wishlist')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final timetables = ref.read(timetableProvider).asData?.value ?? [];
                          if (timetables.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No timetables found. Create one in Planner first.')),
                            );
                            return;
                          }
                          
                          // Show dialog to select timetable
                          await showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                              title: const Text('Add to Timetable'),
                              children: timetables.map((t) => SimpleDialogOption(
                                onPressed: () {
                                  ref.read(timetableProvider.notifier).addCourseToTimetable(t.id, course);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${course.name} added to ${t.name}')),
                                  );
                                },
                                child: Text(t.name),
                              )).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
