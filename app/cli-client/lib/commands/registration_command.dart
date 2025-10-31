import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class RegistrationCommand {
  final ApiClient _apiClient = ApiClient();

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
        case 'step':
          await _step(args);
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
        default:
          TerminalUtils.printError('Unknown registration command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _start(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError(
        'Usage: uniplan registration start <scenarioId>',
      );
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Starting registration with scenario $scenarioId...');

    final response = await _apiClient.post(
      Endpoints.registrations,
      body: {'scenarioId': scenarioId},
    );

    final registration = response.json;
    TerminalUtils.printSuccess('Registration started!');
    _printRegistrationDetails(registration);
  }

  Future<void> _step(List<String> args) async {
    if (args.length < 4) {
      TerminalUtils.printError(
        'Usage: uniplan registration step <registrationId> <courseId> <status>',
      );
      TerminalUtils.printInfo('Status: SUCCESS or FAILED');
      return;
    }

    final registrationId = int.tryParse(args[1]);
    final courseId = int.tryParse(args[2]);
    final status = args[3].toUpperCase();

    if (registrationId == null) {
      TerminalUtils.printError('Invalid registration ID: ${args[1]}');
      return;
    }
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[2]}');
      return;
    }
    if (status != 'SUCCESS' && status != 'FAILED') {
      TerminalUtils.printError('Invalid status: ${args[3]} (must be SUCCESS or FAILED)');
      return;
    }

    TerminalUtils.printInfo(
      'Adding step: Course $courseId -> $status...',
    );

    final response = await _apiClient.post(
      Endpoints.registrationSteps(registrationId),
      body: {
        'courseId': courseId,
        'status': status,
      },
    );

    final registration = response.json;

    if (status == 'SUCCESS') {
      TerminalUtils.printSuccess('Course $courseId registered successfully!');
    } else {
      TerminalUtils.printWarning('Course $courseId registration failed!');
    }

    // Show current scenario
    final currentScenario = registration['currentScenario'] as Map<String, dynamic>?;
    if (currentScenario != null) {
      print('\n${TerminalUtils.bold('Current Scenario')}:');
      TerminalUtils.printKeyValue('ID', currentScenario['id'].toString());
      TerminalUtils.printKeyValue('Name', currentScenario['name'].toString());
    }

    // Show succeeded courses
    final succeededCourses = registration['succeededCourses'] as List?;
    if (succeededCourses != null && succeededCourses.isNotEmpty) {
      print('\n${TerminalUtils.bold('Successfully Registered Courses')}:');
      for (final courseId in succeededCourses) {
        print('  - Course ID: $courseId');
      }
    }
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

        final items = timetable['items'] as List?;
        if (items != null && items.isNotEmpty) {
          print('\n${TerminalUtils.bold('Courses in Current Timetable')}:');
          for (final item in items) {
            final i = item as Map<String, dynamic>;
            print('  - Course ID: ${i['courseId']}');
          }
        }
      }
    }

    final succeededCourses = registration['succeededCourses'] as List?;
    if (succeededCourses != null && succeededCourses.isNotEmpty) {
      print('\n${TerminalUtils.bold('Successfully Registered Courses')}:');
      for (final courseId in succeededCourses) {
        print('  - Course ID: $courseId');
      }
    }

    final steps = registration['steps'] as List?;
    if (steps != null && steps.isNotEmpty) {
      print('\n${TerminalUtils.bold('Registration Steps')} (${steps.length}):');
      for (final step in steps) {
        final s = step as Map<String, dynamic>;
        final status = s['status'] == 'SUCCESS'
            ? TerminalUtils.green('SUCCESS')
            : TerminalUtils.red('FAILED');
        print('  ${s['stepOrder']}. Course ${s['courseId']}: $status');
      }
    }
  }

  void _printHelp() {
    print('''
Registration Commands:

  start <scenarioId>                        Start registration with a scenario
  step <registrationId> <courseId> <status> Add a registration step (SUCCESS/FAILED)
  get <registrationId>                      Get registration details
  list                                       List all registrations
  complete <registrationId>                 Complete a registration
  cancel <registrationId>                   Cancel a registration

Examples:
  uniplan registration start 1
  uniplan registration step 1 123 SUCCESS
  uniplan registration step 1 456 FAILED
  uniplan registration get 1
  uniplan registration list
  uniplan registration complete 1
  uniplan registration cancel 1
''');
  }
}
