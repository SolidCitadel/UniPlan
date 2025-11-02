import 'dart:io';
import 'dart:convert';
import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class CoursesCommand {
  final ApiClient _apiClient = ApiClient();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'list':
          await _list(args);
          break;
        case 'search':
          await _search(args);
          break;
        case 'get':
          await _get(args);
          break;
        case 'import':
          await _import(args);
          break;
        default:
          TerminalUtils.printError('Unknown courses command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _list(List<String> args) async {
    TerminalUtils.printInfo('Fetching courses...');

    // Parse query parameters
    final queryParams = <String>[];
    var i = 1;
    while (i < args.length) {
      if (args[i].startsWith('--')) {
        final param = args[i].substring(2);
        if (param.contains('=')) {
          // Format: --key=value
          queryParams.add(param);
          i++;
        } else if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
          // Format: --key value
          queryParams.add('$param=${args[i + 1]}');
          i += 2; // Skip both --key and value
        } else {
          i++;
        }
      } else {
        i++;
      }
    }

    var path = Endpoints.courses;
    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }

    final response = await _apiClient.get(path);
    final data = response.json;

    // Handle paginated response
    final List<dynamic> courses = data.containsKey('content')
        ? data['content'] as List<dynamic>
        : <dynamic>[];

    if (courses.isEmpty) {
      TerminalUtils.printWarning('No courses found.');
      return;
    }

    TerminalUtils.printHeader('Courses (${courses.length})');

    // Convert to table format
    final rows = courses.map((course) {
      final c = course as Map<String, dynamic>;
      return {
        'Code': c['courseCode']?.toString() ?? '',
        'Name': c['courseName']?.toString() ?? '',
        'Professor': c['professor']?.toString() ?? '',
        'Credits': c['credits']?.toString() ?? '',
        'Department': c['departmentName']?.toString() ?? c['departmentCode']?.toString() ?? '',
      };
    }).toList();

    TerminalUtils.printTable(
      rows,
      ['Code', 'Name', 'Professor', 'Credits', 'Department'],
    );
  }

  Future<void> _search(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan courses search [keyword] [options]');
      TerminalUtils.printInfo('Options:');
      TerminalUtils.printInfo('  --professor <name>    Filter by professor name');
      TerminalUtils.printInfo('  --credits <number>    Filter by credits');
      TerminalUtils.printInfo('  --department <code>   Filter by department code');
      TerminalUtils.printInfo('  --college <code>      Filter by college code');
      TerminalUtils.printInfo('  --year <year>         Filter by opening year');
      TerminalUtils.printInfo('  --semester <semester> Filter by semester (e.g., "1학기", "2학기")');
      TerminalUtils.printInfo('');
      TerminalUtils.printInfo('Examples:');
      TerminalUtils.printInfo('  courses search --professor 이성원 --year 2025 --semester 2학기');
      TerminalUtils.printInfo('  courses search "컴퓨터" --credits 3');
      return;
    }

    // Build query parameters
    final queryParams = <String>[];
    String? keyword;

    var i = 1;
    while (i < args.length) {
      final arg = args[i];
      if (arg.startsWith('--')) {
        final param = arg.substring(2);
        if (param.contains('=')) {
          // Format: --key=value
          queryParams.add(param);
          i++;
        } else if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
          // Format: --key value
          queryParams.add('$param=${args[i + 1]}');
          i += 2; // Skip both --key and value
        } else {
          i++;
        }
      } else if (keyword == null) {
        // First non-flag argument is the keyword
        keyword = arg;
        i++;
      } else {
        i++;
      }
    }

    // Add keyword if provided
    if (keyword != null && keyword.isNotEmpty) {
      queryParams.add('keyword=$keyword');
    }

    if (queryParams.isEmpty) {
      TerminalUtils.printError('Please provide at least one search criterion');
      return;
    }

    final searchDesc = keyword != null ? '"$keyword"' : 'with filters';
    TerminalUtils.printInfo('Searching for $searchDesc...');

    final response = await _apiClient.get(
      '${Endpoints.courses}?${queryParams.join('&')}',
    );

    final data = response.json;

    // Handle paginated response
    final List<dynamic> courses = data.containsKey('content')
        ? data['content'] as List<dynamic>
        : <dynamic>[];

    if (courses.isEmpty) {
      TerminalUtils.printWarning('No courses found for $searchDesc.');
      return;
    }

    TerminalUtils.printHeader('Search Results (${courses.length})');

    final rows = courses.map((course) {
      final c = course as Map<String, dynamic>;
      return {
        'Code': c['courseCode']?.toString() ?? '',
        'Name': c['courseName']?.toString() ?? '',
        'Professor': c['professor']?.toString() ?? '',
        'Credits': c['credits']?.toString() ?? '',
        'Department': c['departmentName']?.toString() ?? c['departmentCode']?.toString() ?? '',
      };
    }).toList();

    TerminalUtils.printTable(
      rows,
      ['Code', 'Name', 'Professor', 'Credits', 'Department'],
    );
  }

  Future<void> _get(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan courses get <course-code>');
      return;
    }

    final courseCode = args[1];
    TerminalUtils.printInfo('Fetching course $courseCode...');

    final response = await _apiClient.get(
      Endpoints.courseByCode(courseCode),
    );
    final course = response.json;

    TerminalUtils.printHeader('Course Details');
    _printCourseDetails(course);
  }

  Future<void> _import(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan courses import <file-path>');
      return;
    }

    final filePath = args[1];
    final file = File(filePath);

    if (!await file.exists()) {
      TerminalUtils.printError('File not found: $filePath');
      return;
    }

    TerminalUtils.printInfo('Reading file $filePath...');

    final content = await file.readAsString();
    final json = jsonDecode(content);

    TerminalUtils.printInfo('Importing courses to server...');

    final response = await _apiClient.post(
      Endpoints.coursesImport,
      body: json is Map ? json as Map<String, dynamic> : {'courses': json},
    );

    final result = response.json;
    TerminalUtils.printSuccess('Import completed!');

    if (result.containsKey('imported')) {
      TerminalUtils.printKeyValue('Imported', result['imported'].toString());
    }
    if (result.containsKey('failed')) {
      TerminalUtils.printKeyValue('Failed', result['failed'].toString());
    }
  }

  void _printCourseDetails(Map<String, dynamic> course) {
    TerminalUtils.printKeyValue('Course Code', course['courseCode']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Course Name', course['courseName']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Professor', course['professor']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Credits', course['credits']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Opening Year', course['openingYear']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Semester', course['semester']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Department Code', course['departmentCode']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Course Type Code', course['courseTypeCode']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Campus', course['campus']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Classroom', course['classroom']?.toString() ?? 'N/A');

    if (course['classTime'] != null) {
      print('\n${TerminalUtils.bold('Class Time')}:');
      final classTime = course['classTime'] as List;
      for (final time in classTime) {
        final t = time as Map<String, dynamic>;
        print('  ${t['day']} ${t['startTime']}-${t['endTime']}');
      }
    }
  }

  void _printHelp() {
    print('''
Courses Commands:

  list [options]                List all courses with optional filters
  search [keyword] [options]    Search courses by keyword or filters
  get <course-code>             Get course details by code
  import <file-path>            Import courses from JSON file

Search/List Options:
  --professor <name>            Filter by professor name
  --professor=<name>            (alternative format)
  --credits <number>            Filter by credits (e.g., 3)
  --department <code>           Filter by department code
  --college <code>              Filter by college code
  --year <year>                 Filter by opening year (e.g., 2025)
  --semester <semester>         Filter by semester (e.g., "1학기", "2학기")

Examples:
  uniplan courses list
  uniplan courses list --department A10627
  uniplan courses search "컴퓨터"
  uniplan courses search --professor 김철수
  uniplan courses search --credits 3
  uniplan courses search "네트워크" --credits 3
  uniplan courses search --professor 이성원 --year 2025 --semester 2학기
  uniplan courses get CSE302
  uniplan courses import output/transformed_2025_1.json
''');
  }
}
