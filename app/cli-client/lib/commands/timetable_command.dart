import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class TimetableCommand {
  final ApiClient _apiClient = ApiClient();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'create':
          await _create(args);
          break;
        case 'alternative':
          await _alternative(args);
          break;
        case 'list':
          await _list(args);
          break;
        case 'get':
          await _get(args);
          break;
        case 'add-course':
          await _addCourse(args);
          break;
        case 'remove-course':
          await _removeCourse(args);
          break;
        case 'delete':
          await _delete(args);
          break;
        default:
          TerminalUtils.printError('Unknown timetable command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _create(List<String> args) async {
    if (args.length < 4) {
      TerminalUtils.printError(
        'Usage: uniplan timetable create <name> <year> <semester>',
      );
      return;
    }

    final name = args[1];
    final year = int.tryParse(args[2]);
    final semester = args[3];

    if (year == null) {
      TerminalUtils.printError('Invalid year: ${args[2]}');
      return;
    }

    TerminalUtils.printInfo('Creating timetable "$name"...');

    final response = await _apiClient.post(
      Endpoints.timetables,
      body: {
        'name': name,
        'openingYear': year,
        'semester': semester,
      },
    );

    final timetable = response.json;
    TerminalUtils.printSuccess('Timetable created successfully!');
    _printTimetableSummary(timetable);
  }

  Future<void> _alternative(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan timetable alternative <baseTimetableId> <name> <excludedCourseId1> [excludedCourseId2...]',
      );
      TerminalUtils.printInfo(
        'Example: uniplan timetable alternative 1 "Plan B - CS101 failed" 101',
      );
      return;
    }

    final baseTimetableId = int.tryParse(args[1]);
    if (baseTimetableId == null) {
      TerminalUtils.printError('Invalid base timetable ID: ${args[1]}');
      return;
    }

    final name = args[2];

    // Parse excluded course IDs (from args[3] onwards)
    final excludedCourseIds = <int>[];
    for (var i = 3; i < args.length; i++) {
      final courseId = int.tryParse(args[i]);
      if (courseId == null) {
        TerminalUtils.printError('Invalid course ID: ${args[i]}');
        return;
      }
      excludedCourseIds.add(courseId);
    }

    if (excludedCourseIds.isEmpty) {
      TerminalUtils.printError('At least one excluded course ID is required');
      return;
    }

    TerminalUtils.printInfo(
      'Creating alternative timetable from timetable $baseTimetableId...',
    );
    TerminalUtils.printInfo(
      'Excluding courses: ${excludedCourseIds.join(", ")}',
    );

    final response = await _apiClient.post(
      Endpoints.timetableAlternatives(baseTimetableId),
      body: {
        'name': name,
        'excludedCourseIds': excludedCourseIds,
      },
    );

    final timetable = response.json;
    TerminalUtils.printSuccess('Alternative timetable created successfully!');
    _printTimetableSummary(timetable);
  }

  Future<void> _list(List<String> args) async {
    TerminalUtils.printInfo('Fetching timetables...');

    // Parse optional filters
    var path = Endpoints.timetables;
    final filters = <String>[];
    for (var i = 1; i < args.length; i++) {
      if (args[i].startsWith('--')) {
        final param = args[i].substring(2);
        if (param.contains('=')) {
          filters.add(param);
        }
      }
    }
    if (filters.isNotEmpty) {
      path += '?${filters.join('&')}';
    }

    final response = await _apiClient.get(path);
    final timetables = response.jsonList;

    if (timetables.isEmpty) {
      TerminalUtils.printWarning('No timetables found.');
      return;
    }

    TerminalUtils.printHeader('My Timetables (${timetables.length})');

    final rows = timetables.map((t) {
      final timetable = t as Map<String, dynamic>;
      final items = timetable['items'] as List?;
      final courseCount = items?.length ?? 0;
      return {
        'ID': timetable['id']?.toString() ?? '',
        'Name': timetable['name']?.toString() ?? '',
        'Year': timetable['openingYear']?.toString() ?? '',
        'Semester': timetable['semester']?.toString() ?? '',
        'Courses': courseCount.toString(),
      };
    }).toList();

    TerminalUtils.printTable(
      rows,
      ['ID', 'Name', 'Year', 'Semester', 'Courses'],
    );
  }

  Future<void> _get(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan timetable get <timetableId>');
      return;
    }

    final timetableId = int.tryParse(args[1]);
    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Fetching timetable $timetableId...');

    final response = await _apiClient.get(Endpoints.timetable(timetableId));
    final timetable = response.json;

    TerminalUtils.printHeader('Timetable Details');
    _printTimetableDetails(timetable);
  }

  Future<void> _addCourse(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan timetable add-course <timetableId> <courseId>',
      );
      return;
    }

    final timetableId = int.tryParse(args[1]);
    final courseId = int.tryParse(args[2]);

    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[1]}');
      return;
    }
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[2]}');
      return;
    }

    TerminalUtils.printInfo(
      'Adding course $courseId to timetable $timetableId...',
    );

    final response = await _apiClient.post(
      Endpoints.timetableAddCourse(timetableId),
      body: {'courseId': courseId},
    );

    final item = response.json;
    TerminalUtils.printSuccess('Course added to timetable!');
    TerminalUtils.printKeyValue('Item ID', item['id'].toString());
    TerminalUtils.printKeyValue('Course ID', item['courseId'].toString());
  }

  Future<void> _removeCourse(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan timetable remove-course <timetableId> <courseId>',
      );
      return;
    }

    final timetableId = int.tryParse(args[1]);
    final courseId = int.tryParse(args[2]);

    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[1]}');
      return;
    }
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[2]}');
      return;
    }

    TerminalUtils.printInfo(
      'Removing course $courseId from timetable $timetableId...',
    );

    await _apiClient.delete(
      Endpoints.timetableRemoveCourse(timetableId, courseId),
    );

    TerminalUtils.printSuccess('Course removed from timetable!');
  }

  Future<void> _delete(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan timetable delete <timetableId>');
      return;
    }

    final timetableId = int.tryParse(args[1]);
    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Deleting timetable $timetableId...');

    await _apiClient.delete(Endpoints.timetable(timetableId));

    TerminalUtils.printSuccess('Timetable deleted successfully!');
  }

  void _printTimetableSummary(Map<String, dynamic> timetable) {
    TerminalUtils.printKeyValue('ID', timetable['id'].toString());
    TerminalUtils.printKeyValue('Name', timetable['name'].toString());
    TerminalUtils.printKeyValue(
      'Opening Year',
      timetable['openingYear'].toString(),
    );
    TerminalUtils.printKeyValue('Semester', timetable['semester'].toString());
  }

  void _printTimetableDetails(Map<String, dynamic> timetable) {
    _printTimetableSummary(timetable);

    // Show excluded courses if any
    final excludedCourseIds = timetable['excludedCourseIds'] as List?;
    if (excludedCourseIds != null && excludedCourseIds.isNotEmpty) {
      print('\n${TerminalUtils.bold('Excluded Courses')} (${excludedCourseIds.length}):');
      for (final courseId in excludedCourseIds) {
        print('  - Course ID: $courseId');
      }
    }

    final items = timetable['items'] as List?;
    if (items != null && items.isNotEmpty) {
      print('\n${TerminalUtils.bold('Courses')} (${items.length}):');
      for (final item in items) {
        final i = item as Map<String, dynamic>;
        print('  - Course ID: ${i['courseId']}');
      }
    } else {
      print('\n${TerminalUtils.gray('No courses in this timetable.')}');
    }
  }

  void _printHelp() {
    print('''
Timetable Commands:

  create <name> <year> <semester>                Create a new timetable
  alternative <baseId> <name> <excludedId...>    Create alternative timetable (copy with excluded courses)
  list [--openingYear=X --semester=Y]            List all timetables (with optional filters)
  get <timetableId>                              Get timetable details
  add-course <timetableId> <courseId>            Add a course to timetable
  remove-course <timetableId> <courseId>         Remove a course from timetable
  delete <timetableId>                           Delete a timetable

Examples:
  uniplan timetable create "Plan A" 2025 "1학기"
  uniplan timetable alternative 1 "Plan B - CS101 failed" 101
  uniplan timetable alternative 1 "Plan C - Multiple failed" 101 102
  uniplan timetable list
  uniplan timetable list --openingYear=2025 --semester=1학기
  uniplan timetable get 1
  uniplan timetable add-course 1 123
  uniplan timetable remove-course 1 123
  uniplan timetable delete 1
''');
  }
}
