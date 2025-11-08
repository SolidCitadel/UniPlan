import 'dart:io';
import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/session/registration_session.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';
import 'package:uniplan_cli/utils/simple_menu.dart';

class RegistrationCommand {
  final ApiClient _apiClient = ApiClient();
  final RegistrationSession _session = RegistrationSession();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'start':
          await _start(args);
          break;
        case 'resume':
          await _resume(args);
          break;
        case 'interactive':
          await _interactive();
          break;
        case 'mark':
          _mark(args);
          break;
        case 'unmark':
          _unmark(args);
          break;
        case 'status':
          _status();
          break;
        case 'submit':
          await _submit();
          break;
        case 'get':
          await _get(args);
          break;
        case 'list':
          await _list();
          break;
        case 'complete':
          await _complete(args);
          break;
        case 'cancel':
          await _cancel(args);
          break;
        case 'delete-all':
          await _deleteAll();
          break;
        default:
          TerminalUtils.printError('Unknown registration command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
      _ensureTerminalRestored();
    } on StateError catch (e) {
      TerminalUtils.printError(e.message);
      _ensureTerminalRestored();
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
      _ensureTerminalRestored();
    }
  }

  void _ensureTerminalRestored() {
    try {
      if (!stdin.echoMode) stdin.echoMode = true;
      if (!stdin.lineMode) stdin.lineMode = true;
    } catch (e) {
      // Ignore restoration errors
    }
  }

  Future<void> _start(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError(
        'Usage: uniplan registration start <scenarioId> [--manual]',
      );
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }

    // Check for flags
    final isManual = args.contains('--manual');

    TerminalUtils.printInfo('Starting registration with scenario $scenarioId...');

    final response = await _apiClient.post(
      Endpoints.registrations,
      body: {'scenarioId': scenarioId},
    );

    final registration = response.json;
    final registrationId = registration['id'] as int;

    // Initialize session
    _session.start(registrationId);

    TerminalUtils.printSuccess('Registration started!');

    if (isManual) {
      // Manual mode: show detailed information and instructions
      _printRegistrationDetails(registration);
      print('\n${TerminalUtils.bold('Manual Mode')}:');
      print('  1. Mark courses as SUCCESS or FAILED: ${TerminalUtils.gray('mark <courseId> <SUCCESS|FAILED>')}');
      print('  2. Check status: ${TerminalUtils.gray('status')}');
      print('  3. Submit to backend: ${TerminalUtils.gray('submit')}');
    } else {
      // Auto-launch interactive mode - no detailed output, all info shown in interactive UI
      print('\n${TerminalUtils.gray('Launching interactive mode...')}');
      await Future.delayed(Duration(milliseconds: 500));

      await _interactiveWithAutoSubmit();
    }
  }

  Future<void> _resume(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan registration resume <registrationId> [--manual]');
      return;
    }

    final registrationId = int.tryParse(args[1]);
    if (registrationId == null) {
      TerminalUtils.printError('Invalid registration ID: ${args[1]}');
      return;
    }

    // Check for flags
    final isManual = args.contains('--manual');

    if (isManual) {
      // Manual mode: fetch full registration details for display
      TerminalUtils.printInfo('Resuming registration $registrationId...');

      final response = await _apiClient.get(Endpoints.registration(registrationId));
      final registration = response.json;

      // Check if registration is still in progress
      final status = registration['status'] as String?;
      if (status != 'IN_PROGRESS') {
        TerminalUtils.printError('Cannot resume registration: status is $status');
        TerminalUtils.printInfo('Only IN_PROGRESS registrations can be resumed.');
        return;
      }

      // Initialize session
      _session.start(registrationId);

      TerminalUtils.printSuccess('Registration session resumed!');

      // Manual mode: show detailed information and instructions
      _printRegistrationDetails(registration);
      print('\n${TerminalUtils.bold('Manual Mode')}:');
      print('  1. Mark courses as SUCCESS or FAILED: ${TerminalUtils.gray('mark <courseId> <SUCCESS|FAILED>')}');
      print('  2. Check status: ${TerminalUtils.gray('status')}');
      print('  3. Submit to backend: ${TerminalUtils.gray('submit')}');
    } else {
      // Interactive mode: don't fetch data here, let interactive menu fetch it
      // Initialize session first
      _session.start(registrationId);

      TerminalUtils.printSuccess('Registration session resumed!');
      print('\n${TerminalUtils.gray('Launching interactive mode...')}');
      await Future.delayed(Duration(milliseconds: 500));

      await _interactiveWithAutoSubmit();
    }
  }

  Future<void> _interactive() async {
    if (!_session.isActive) {
      TerminalUtils.printError('No active registration session.');
      TerminalUtils.printInfo('Use "registration start <scenarioId>" or "registration resume <id>" first.');
      return;
    }

    final selectedMarks = await _runInteractiveMenu();
    if (selectedMarks == null) {
      return;
    }

    TerminalUtils.printSuccess('Marks updated!');
    print('\n${_session.getSummary()}');
    print('\n${TerminalUtils.gray('Use "submit" to send to backend.')}');
  }

  Future<void> _interactiveWithAutoSubmit() async {
    if (!_session.isActive) {
      TerminalUtils.printError('No active registration session.');
      return;
    }

    // Loop until user quits or registration is complete
    while (true) {
      final selectedMarks = await _runInteractiveMenu();
      if (selectedMarks == null) {
        // User quit with 'Q' - session remains active
        TerminalUtils.printWarning('Registration paused. Session is still active.');
        print('Use ${TerminalUtils.cyan('registration interactive')} to continue later.');
        return;
      }

      // Auto-submit (silent mode for interactive)
      if (_session.markedCourses.isEmpty) {
        // No changes - just continue to next iteration (re-open interactive menu)
        continue;
      }

      // Submit marked courses to backend
      final registrationId = _session.registrationId!;
      final submitData = _session.getSubmitData();

      try {
        await _apiClient.post(
          Endpoints.registrationSteps(registrationId),
          body: submitData,
        );

        // Clear marks after successful submit
        _session.clearMarks();

        // Check if registration is still in progress
        final response = await _apiClient.get(Endpoints.registration(registrationId));
        final registration = response.json;
        final status = registration['status'] as String?;

        if (status != 'IN_PROGRESS') {
          // Registration completed automatically by backend
          TerminalUtils.clearScreen();
          TerminalUtils.printSuccess('Registration completed!');
          _printRegistrationSummary(registration);
          _session.end();
          return;
        }

        // Continue to next scenario automatically - no prompt
        // Loop will re-open interactive menu with new scenario
      } catch (e) {
        TerminalUtils.clearScreen();
        TerminalUtils.printError('Failed to submit: $e');
        print('Use ${TerminalUtils.cyan('registration interactive')} to try again.');
        return;
      }
    }
  }

  Future<void> _completeCurrentRegistration() async {
    final registrationId = _session.registrationId!;
    try {
      TerminalUtils.printInfo('Completing registration $registrationId...');

      final response = await _apiClient.post(
        Endpoints.registrationComplete(registrationId),
      );

      final registration = response.json;
      TerminalUtils.printSuccess('Registration completed!');
      _printRegistrationSummary(registration);

      _session.end();
    } catch (e) {
      TerminalUtils.printError('Failed to complete registration: $e');
    }
  }

  Future<Map<int, String>?> _runInteractiveMenu() async {
    final registrationId = _session.registrationId!;
    TerminalUtils.printInfo('Fetching registration details...');

    final response = await _apiClient.get(Endpoints.registration(registrationId));
    final registration = response.json;

    final currentScenario = registration['currentScenario'] as Map<String, dynamic>?;
    if (currentScenario == null) {
      TerminalUtils.printError('No current scenario found.');
      return null;
    }

    final timetable = currentScenario['timetable'] as Map<String, dynamic>?;
    if (timetable == null) {
      TerminalUtils.printError('No timetable found in current scenario.');
      return null;
    }

    final items = timetable['items'] as List?;
    if (items == null || items.isEmpty) {
      TerminalUtils.printWarning('No courses in current timetable.');
      return null;
    }

    // Get succeeded/failed/canceled courses
    final succeededCourses = (registration['succeededCourses'] as List? ?? []).cast<int>().toSet();
    final failedCourses = (registration['failedCourses'] as List? ?? []).cast<int>().toSet();
    final canceledCourses = (registration['canceledCourses'] as List? ?? []).cast<int>().toSet();

    // Course details are already included in items from backend
    final courses = <CourseItem>[];
    final initialMarks = <int, String>{};

    for (final item in items) {
      final i = item as Map<String, dynamic>;
      final courseId = i['courseId'] as int;
      final courseName = i['courseName']?.toString() ?? 'Course $courseId';

      String category;
      // Determine category based on current state
      if (succeededCourses.contains(courseId)) {
        initialMarks[courseId] = 'SUCCESS';
        category = 'registered';
      } else if (failedCourses.contains(courseId)) {
        initialMarks[courseId] = 'FAILED';
        category = 'failed';
      } else if (canceledCourses.contains(courseId)) {
        initialMarks[courseId] = 'CANCELED';
        category = 'failed'; // Canceled courses treated as failed
      } else {
        // PENDING (not in initialMarks)
        category = 'pending';
      }

      courses.add(CourseItem(
        courseId: courseId,
        courseName: courseName,
        category: category,
      ));
    }

    // Add courses to cancel (registered but not in current timetable)
    final timetableCourseIds = items.map((item) => (item as Map<String, dynamic>)['courseId'] as int).toSet();
    final coursesToCancel = succeededCourses.where((courseId) => !timetableCourseIds.contains(courseId)).toList();

    if (coursesToCancel.isNotEmpty) {
      // Fetch all courses to cancel in parallel to minimize latency
      final cancelFutures = coursesToCancel.map((courseId) async {
        initialMarks[courseId] = 'SUCCESS'; // Start as SUCCESS, can change to CANCELED

        try {
          final courseResponse = await _apiClient.get('${Endpoints.courses}/$courseId');
          final course = courseResponse.json;
          final courseName = course['courseName']?.toString() ?? 'Unknown Course';

          return CourseItem(
            courseId: courseId,
            courseName: courseName,
            category: 'toCancel',
          );
        } catch (e) {
          return CourseItem(
            courseId: courseId,
            courseName: 'Course $courseId',
            category: 'toCancel',
          );
        }
      }).toList();

      final cancelCourses = await Future.wait(cancelFutures);
      courses.addAll(cancelCourses);
    }

    // Override with session marks if any
    final currentMarks = Map<int, String>.from(initialMarks);
    currentMarks.addAll(_session.markedCourses);

    // Prepare context info for display
    final contextInfo = {
      'scenarioName': currentScenario['name']?.toString() ?? 'Unknown Scenario',
      'timetableName': timetable['name']?.toString() ?? 'Unknown Timetable',
      'registrationId': registrationId.toString(),
      'totalSucceeded': succeededCourses.length.toString(),
      'totalFailed': failedCourses.length.toString(),
      'totalCanceled': canceledCourses.length.toString(),
    };

    // Launch simple menu (number-based, Windows-compatible)
    final selectedMarks = await SimpleMenu.selectCourseStatuses(
      courses: courses,
      initialMarks: currentMarks,
      contextInfo: contextInfo,
    );

    if (selectedMarks.isEmpty) {
      return null;
    }

    // Apply marks to session
    _session.clearMarks();
    for (final entry in selectedMarks.entries) {
      _session.mark(entry.key, entry.value);
    }

    return selectedMarks;
  }

  void _mark(List<String> args) {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan registration mark <courseId> <SUCCESS|FAILED|CANCELED>',
      );
      return;
    }

    final courseId = int.tryParse(args[1]);
    final status = args[2].toUpperCase();

    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[1]}');
      return;
    }

    if (status != 'SUCCESS' && status != 'FAILED' && status != 'CANCELED') {
      TerminalUtils.printError('Status must be SUCCESS, FAILED, or CANCELED');
      return;
    }

    try {
      _session.mark(courseId, status);
      TerminalUtils.printSuccess('Course $courseId marked as $status');
      print('\nCurrent marks:');
      print(_session.getSummary());
      print('\nUse ${TerminalUtils.bold('submit')} to send to backend.');
    } on StateError catch (e) {
      TerminalUtils.printError(e.message);
      TerminalUtils.printInfo('Use "registration start <scenarioId>" first.');
    }
  }

  void _unmark(List<String> args) {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan registration unmark <courseId>');
      return;
    }

    final courseId = int.tryParse(args[1]);
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[1]}');
      return;
    }

    try {
      _session.unmark(courseId);
      TerminalUtils.printSuccess('Course $courseId unmarked');
      print('\n${_session.getSummary()}');
    } on StateError catch (e) {
      TerminalUtils.printError(e.message);
    }
  }

  void _status() {
    if (!_session.isActive) {
      TerminalUtils.printWarning('No active registration session.');
      TerminalUtils.printInfo('Use "registration start <scenarioId>" to begin.');
      return;
    }

    TerminalUtils.printHeader('Registration Session Status');
    TerminalUtils.printKeyValue('Registration ID', _session.registrationId.toString());
    print('\n${_session.getSummary()}');

    if (_session.markedCourses.isEmpty) {
      print('\n${TerminalUtils.gray('Use "mark <courseId> <SUCCESS|FAILED>" to record results.')}');
    } else {
      print('\n${TerminalUtils.gray('Use "submit" to send to backend.')}');
    }
  }

  Future<void> _submit() async {
    if (!_session.isActive) {
      TerminalUtils.printError('No active registration session.');
      TerminalUtils.printInfo('Use "registration start <scenarioId>" first.');
      return;
    }

    if (_session.markedCourses.isEmpty) {
      TerminalUtils.printWarning('No courses marked yet.');
      TerminalUtils.printInfo('Use "mark <courseId> <SUCCESS|FAILED>" to record results first.');
      return;
    }

    final registrationId = _session.registrationId!;
    final submitData = _session.getSubmitData();

    TerminalUtils.printInfo('Submitting marked courses to backend...');

    final response = await _apiClient.post(
      Endpoints.registrationSteps(registrationId),
      body: submitData,
    );

    final registration = response.json;

    TerminalUtils.printSuccess('Results submitted successfully!');

    // Clear marks after successful submit
    _session.clearMarks();

    // Show current scenario
    final currentScenario = registration['currentScenario'] as Map<String, dynamic>?;
    if (currentScenario != null) {
      print('\n${TerminalUtils.bold('Current Scenario')}:');
      TerminalUtils.printKeyValue('ID', currentScenario['id'].toString());
      TerminalUtils.printKeyValue('Name', currentScenario['name'].toString());

      // Show timetable information
      final timetable = currentScenario['timetable'] as Map<String, dynamic>?;
      if (timetable != null) {
        print('\n${TerminalUtils.bold('Current Timetable')}:');
        TerminalUtils.printKeyValue('Name', timetable['name'].toString());

        final succeededCourses = registration['succeededCourses'] as List? ?? [];
        final items = timetable['items'] as List?;

        // Get course IDs in current timetable
        final timetableCourseIds = items
            ?.map((item) => (item as Map<String, dynamic>)['courseId'])
            .toSet() ?? {};

        // Show courses in timetable
        if (items != null && items.isNotEmpty) {
          print('\n${TerminalUtils.bold('Courses to Register')}:');

          for (final item in items) {
            final i = item as Map<String, dynamic>;
            final courseId = i['courseId'];
            final isRegistered = succeededCourses.contains(courseId);

            if (isRegistered) {
              print('  ${TerminalUtils.green('✓')} Course ID: $courseId ${TerminalUtils.gray('(already registered)')}');
            } else {
              print('  ${TerminalUtils.yellow('○')} Course ID: $courseId ${TerminalUtils.yellow('(pending)')}');
            }
          }
        }

        // Show courses to cancel (registered but not in current timetable)
        final coursesToCancel = succeededCourses
            .where((courseId) => !timetableCourseIds.contains(courseId))
            .toList();

        if (coursesToCancel.isNotEmpty) {
          print('\n${TerminalUtils.bold('Courses to Cancel')}:');
          for (final courseId in coursesToCancel) {
            print('  ${TerminalUtils.red('✗')} Course ID: $courseId ${TerminalUtils.red('(registered but removed from timetable)')}');
          }
        }
      }
    }

    // Show summary
    final succeededCourses = registration['succeededCourses'] as List?;
    final failedCourses = registration['failedCourses'] as List?;
    final canceledCourses = registration['canceledCourses'] as List?;

    if (succeededCourses != null && succeededCourses.isNotEmpty) {
      print('\n${TerminalUtils.green('✓ Total Registered')} (${succeededCourses.length}): ${succeededCourses.join(', ')}');
    }

    if (failedCourses != null && failedCourses.isNotEmpty) {
      print('${TerminalUtils.red('✗ Total Failed')} (${failedCourses.length}): ${failedCourses.join(', ')}');
    }

    if (canceledCourses != null && canceledCourses.isNotEmpty) {
      print('${TerminalUtils.gray('⊗ Total Canceled')} (${canceledCourses.length}): ${canceledCourses.join(', ')}');
    }

    print('\n${TerminalUtils.gray('→ Mark remaining courses and submit again, or use "complete" when done.')}');
  }

  Future<void> _get(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan registration get <registrationId>');
      return;
    }

    final registrationId = int.tryParse(args[1]);
    if (registrationId == null) {
      TerminalUtils.printError('Invalid registration ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Fetching registration $registrationId...');

    final response = await _apiClient.get(
      Endpoints.registration(registrationId),
    );
    final registration = response.json;

    TerminalUtils.printHeader('Registration Details');
    _printRegistrationDetails(registration);
  }

  Future<void> _list() async {
    TerminalUtils.printInfo('Fetching registrations...');

    final response = await _apiClient.get(Endpoints.registrations);
    final registrations = response.jsonList;

    if (registrations.isEmpty) {
      TerminalUtils.printWarning('No registrations found.');
      return;
    }

    TerminalUtils.printHeader('My Registrations (${registrations.length})');

    final rows = registrations.map((r) {
      final registration = r as Map<String, dynamic>;
      final startScenario = registration['startScenario'] as Map<String, dynamic>?;
      final succeededCourses = registration['succeededCourses'] as List?;
      return {
        'ID': registration['id']?.toString() ?? '',
        'Status': registration['status']?.toString() ?? '',
        'Scenario': startScenario?['name']?.toString() ?? 'N/A',
        'Succeeded': succeededCourses?.length.toString() ?? '0',
      };
    }).toList();

    TerminalUtils.printTable(rows, ['ID', 'Status', 'Scenario', 'Succeeded']);
  }

  Future<void> _complete(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError(
        'Usage: uniplan registration complete <registrationId>',
      );
      return;
    }

    final registrationId = int.tryParse(args[1]);
    if (registrationId == null) {
      TerminalUtils.printError('Invalid registration ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Completing registration $registrationId...');

    final response = await _apiClient.post(
      Endpoints.registrationComplete(registrationId),
    );

    final registration = response.json;
    TerminalUtils.printSuccess('Registration completed!');
    _printRegistrationSummary(registration);

    // End session if it matches
    if (_session.isActive && _session.registrationId == registrationId) {
      _session.end();
      TerminalUtils.printInfo('Session ended.');
    }
  }

  Future<void> _cancel(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError(
        'Usage: uniplan registration cancel <registrationId>',
      );
      return;
    }

    final registrationId = int.tryParse(args[1]);
    if (registrationId == null) {
      TerminalUtils.printError('Invalid registration ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Canceling registration $registrationId...');

    await _apiClient.delete(Endpoints.registration(registrationId));

    TerminalUtils.printSuccess('Registration canceled!');

    // End session if it matches
    if (_session.isActive && _session.registrationId == registrationId) {
      _session.end();
      TerminalUtils.printInfo('Session ended.');
    }
  }

  Future<void> _deleteAll() async {
    TerminalUtils.printInfo('Deleting all registrations...');

    await _apiClient.delete(Endpoints.registrations);

    TerminalUtils.printSuccess('All registrations deleted!');

    // End session if active
    if (_session.isActive) {
      _session.end();
      TerminalUtils.printInfo('Session ended.');
    }
  }

  void _printRegistrationSummary(Map<String, dynamic> registration) {
    TerminalUtils.printKeyValue('ID', registration['id'].toString());
    TerminalUtils.printKeyValue('Status', registration['status'].toString());

    final startScenario = registration['startScenario'] as Map<String, dynamic>?;
    if (startScenario != null) {
      TerminalUtils.printKeyValue('Start Scenario', startScenario['name'].toString());
    }

    final succeededCourses = registration['succeededCourses'] as List?;
    if (succeededCourses != null) {
      TerminalUtils.printKeyValue(
        'Succeeded Courses',
        succeededCourses.length.toString(),
      );
    }
  }

  void _printRegistrationDetails(Map<String, dynamic> registration) {
    _printRegistrationSummary(registration);

    final currentScenario = registration['currentScenario'] as Map<String, dynamic>?;
    if (currentScenario != null) {
      print('\n${TerminalUtils.bold('Current Scenario')}:');
      TerminalUtils.printKeyValue('ID', currentScenario['id'].toString());
      TerminalUtils.printKeyValue('Name', currentScenario['name'].toString());

      final timetable = currentScenario['timetable'] as Map<String, dynamic>?;
      if (timetable != null) {
        print('\n${TerminalUtils.bold('Current Timetable')}:');
        TerminalUtils.printKeyValue('Name', timetable['name'].toString());

        final succeededCourses = registration['succeededCourses'] as List? ?? [];
        final items = timetable['items'] as List?;

        // Get course IDs in current timetable
        final timetableCourseIds = items
            ?.map((item) => (item as Map<String, dynamic>)['courseId'])
            .toSet() ?? {};

        // Show courses with status (registered / pending)
        if (items != null && items.isNotEmpty) {
          print('\n${TerminalUtils.bold('Courses to Register')}:');

          for (final item in items) {
            final i = item as Map<String, dynamic>;
            final courseId = i['courseId'];
            final courseName = i['courseName']?.toString() ?? 'Course $courseId';
            final isRegistered = succeededCourses.contains(courseId);

            if (isRegistered) {
              print('  ${TerminalUtils.green('✓')} $courseId: $courseName ${TerminalUtils.gray('(already registered)')}');
            } else {
              print('  ${TerminalUtils.yellow('○')} $courseId: $courseName ${TerminalUtils.yellow('(pending)')}');
            }
          }
        }

        // Show courses to cancel (registered but not in current timetable)
        final coursesToCancel = succeededCourses
            .where((courseId) => !timetableCourseIds.contains(courseId))
            .toList();

        if (coursesToCancel.isNotEmpty) {
          print('\n${TerminalUtils.bold('Courses to Cancel')}:');
          for (final courseId in coursesToCancel) {
            print('  ${TerminalUtils.red('✗')} Course ID: $courseId ${TerminalUtils.red('(registered but removed from timetable)')}');
          }
        }
      }
    }

    // Show summary
    final succeededCourses = registration['succeededCourses'] as List?;
    final failedCourses = registration['failedCourses'] as List?;
    final canceledCourses = registration['canceledCourses'] as List?;

    if (succeededCourses != null && succeededCourses.isNotEmpty) {
      print('\n${TerminalUtils.green('✓ Total Registered')} (${succeededCourses.length}): ${succeededCourses.join(', ')}');
    }

    if (failedCourses != null && failedCourses.isNotEmpty) {
      print('${TerminalUtils.red('✗ Total Failed')} (${failedCourses.length}): ${failedCourses.join(', ')}');
    }

    if (canceledCourses != null && canceledCourses.isNotEmpty) {
      print('${TerminalUtils.gray('⊗ Total Canceled')} (${canceledCourses.length}): ${canceledCourses.join(', ')}');
    }

    // Show history (steps)
    final steps = registration['steps'] as List?;
    if (steps != null && steps.isNotEmpty) {
      print('\n${TerminalUtils.bold('Registration History')} (${steps.length} submission${steps.length > 1 ? 's' : ''}):');
      var stepNum = 1;
      for (final step in steps) {
        final s = step as Map<String, dynamic>;
        final succeededList = s['succeededCourses'] as List?;
        final failedList = s['failedCourses'] as List?;
        final canceledList = s['canceledCourses'] as List?;

        print('  ${TerminalUtils.gray('Step $stepNum:')}');

        if (succeededList != null && succeededList.isNotEmpty) {
          print('    ${TerminalUtils.green('SUCCESS')}: ${succeededList.join(', ')}');
        }
        if (failedList != null && failedList.isNotEmpty) {
          print('    ${TerminalUtils.red('FAILED')}: ${failedList.join(', ')}');
        }
        if (canceledList != null && canceledList.isNotEmpty) {
          print('    ${TerminalUtils.gray('CANCELED')}: ${canceledList.join(', ')}');
        }

        stepNum++;
      }
    }
  }

  void _printHelp() {
    print('''
Registration Commands:

  start <scenarioId> [--manual]                 Start registration (auto-launches interactive mode)
  resume <registrationId> [--manual]            Resume an existing registration session
  interactive                                   Re-open interactive UI to mark courses
  mark <courseId> <SUCCESS|FAILED|CANCELED>     Mark a course result (manual mode only)
  unmark <courseId>                             Unmark a course (manual mode only)
  status                                         Show current session status
  submit                                         Submit marked courses to backend (manual mode only)
  get <registrationId>                          Get registration details
  list                                           List all registrations
  complete <registrationId>                     Complete a registration
  cancel <registrationId>                       Cancel a registration
  delete-all                                     Delete all registrations

Status types:
  SUCCESS   - Successfully registered a course
  FAILED    - Tried to register but failed
  CANCELED  - Previously registered, now canceled

Interactive UI Instructions:
  - Press number keys (1-N) to cycle course status
  - Status cycles: PENDING → SUCCESS → FAILED → CANCELED → PENDING
  - Press 'D' to submit and continue to next scenario, 'Q' to pause

Default Workflow (Interactive - Recommended):
  1. uniplan registration start 1           # Launches interactive UI automatically
  2. [Press number keys to cycle statuses, e.g., 1, 1, 2, 3, 3]
  3. [Press 'D' to submit results]
  4. [System navigates to next scenario automatically]
  5. [Repeat steps 2-4 until all scenarios are done]
  6. [Choose 'complete' when satisfied with results]

Manual Workflow (for scripting):
  1. uniplan registration start 1 --manual  # Start in manual mode
  2. uniplan registration mark 101 SUCCESS  # Mark course 101 as success
  3. uniplan registration mark 102 FAILED   # Mark course 102 as failed
  4. uniplan registration status            # Check current marks
  5. uniplan registration submit            # Submit to backend
  6. uniplan registration complete 1        # Complete registration

Resume workflow (after CLI restart):
  1. uniplan registration list              # Find your IN_PROGRESS registration
  2. uniplan registration resume 1          # Resume registration with ID 1
  3. uniplan registration interactive       # Re-open interactive UI
  4. [Press ENTER to confirm and auto-submit]

Examples:
  uniplan registration start 1              # Auto-launches interactive mode
  uniplan registration start 1 --manual     # Manual mode
  uniplan registration resume 1
  uniplan registration interactive          # Re-open interactive UI
  uniplan registration mark 123 SUCCESS     # Manual mode only
  uniplan registration status
  uniplan registration submit               # Manual mode only
  uniplan registration get 1
  uniplan registration complete 1
  uniplan registration delete-all
''');
  }
}
