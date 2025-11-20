import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'timetable_view_model.dart';
import '../../domain/entities/timetable.dart';

class TimetablePlannerScreen extends ConsumerStatefulWidget {
  const TimetablePlannerScreen({super.key});

  @override
  ConsumerState<TimetablePlannerScreen> createState() => _TimetablePlannerScreenState();
}

class _TimetablePlannerScreenState extends ConsumerState<TimetablePlannerScreen> {
  String? _selectedTimetableId;

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateTimetableDialog(context);
            },
          ),
        ],
      ),
      body: timetableState.when(
        data: (timetables) {
          if (timetables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No timetables yet.'),
                  ElevatedButton(
                    onPressed: () => _showCreateTimetableDialog(context),
                    child: const Text('Create Plan A'),
                  ),
                ],
              ),
            );
          }

          // Default selection
          if (_selectedTimetableId == null && timetables.isNotEmpty) {
            _selectedTimetableId = timetables.first.id;
          }
          
          // Handle case where selected timetable was deleted
          if (!timetables.any((t) => t.id == _selectedTimetableId)) {
             _selectedTimetableId = timetables.isNotEmpty ? timetables.first.id : null;
          }

          if (_selectedTimetableId == null) return const SizedBox.shrink();

          final selectedTimetable = timetables.firstWhere((t) => t.id == _selectedTimetableId);

          return Column(
            children: [
              // Timetable Selector / Tabs
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: timetables.length,
                  itemBuilder: (context, index) {
                    final timetable = timetables[index];
                    final isSelected = timetable.id == _selectedTimetableId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(timetable.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedTimetableId = timetable.id;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              // Timetable View (Grid or List)
              Expanded(
                child: _TimetableView(timetable: selectedTimetable),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCreateTimetableDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Timetable'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Timetable Name (e.g., Plan B)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(timetableProvider.notifier).createTimetable(nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _TimetableView extends ConsumerWidget {
  final Timetable timetable;

  const _TimetableView({required this.timetable});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (timetable.courses.isEmpty) {
      return const Center(child: Text('No courses in this timetable. Go to Courses to add some!'));
    }
    return ListView.builder(
      itemCount: timetable.courses.length,
      itemBuilder: (context, index) {
        final course = timetable.courses[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(course.name),
            subtitle: Text('${course.time} | ${course.room}'),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                ref.read(timetableProvider.notifier).removeCourseFromTimetable(timetable.id, course.id);
              },
            ),
          ),
        );
      },
    );
  }
}
