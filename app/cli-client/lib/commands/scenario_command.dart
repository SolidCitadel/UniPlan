import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class ScenarioCommand {
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
          await _list();
          break;
        case 'get':
          await _get(args);
          break;
        case 'tree':
          await _tree(args);
          break;
        case 'navigate':
          await _navigate(args);
          break;
        case 'delete':
          await _delete(args);
          break;
        default:
          TerminalUtils.printError('Unknown scenario command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _create(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan scenario create <name> <timetableId>',
      );
      return;
    }

    final name = args[1];
    final timetableId = int.tryParse(args[2]);

    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[2]}');
      return;
    }

    TerminalUtils.printInfo('Creating root scenario "$name"...');

    final response = await _apiClient.post(
      Endpoints.scenarios,
      body: {
        'name': name,
        'timetableId': timetableId,
      },
    );

    final scenario = response.json;
    TerminalUtils.printSuccess('Root scenario created successfully!');
    _printScenarioSummary(scenario);
  }

  Future<void> _alternative(List<String> args) async {
    if (args.length < 4) {
      TerminalUtils.printError(
        'Usage: uniplan scenario alternative <parentId> <name> <failedCourseId> <timetableId>',
      );
      return;
    }

    final parentId = int.tryParse(args[1]);
    final name = args[2];
    final failedCourseId = int.tryParse(args[3]);
    final timetableId = int.tryParse(args[4]);

    if (parentId == null) {
      TerminalUtils.printError('Invalid parent scenario ID: ${args[1]}');
      return;
    }
    if (failedCourseId == null) {
      TerminalUtils.printError('Invalid failed course ID: ${args[3]}');
      return;
    }
    if (timetableId == null) {
      TerminalUtils.printError('Invalid timetable ID: ${args[4]}');
      return;
    }

    TerminalUtils.printInfo(
      'Creating alternative scenario "$name" (when course $failedCourseId fails)...',
    );

    final response = await _apiClient.post(
      Endpoints.scenarioAlternative(parentId),
      body: {
        'name': name,
        'failedCourseId': failedCourseId,
        'timetableId': timetableId,
      },
    );

    final scenario = response.json;
    TerminalUtils.printSuccess('Alternative scenario created successfully!');
    _printScenarioSummary(scenario);
  }

  Future<void> _list() async {
    TerminalUtils.printInfo('Fetching root scenarios...');

    final response = await _apiClient.get(Endpoints.scenarios);
    final scenarios = response.jsonList;

    if (scenarios.isEmpty) {
      TerminalUtils.printWarning('No scenarios found.');
      return;
    }

    TerminalUtils.printHeader('My Scenarios (${scenarios.length})');

    final rows = scenarios.map((s) {
      final scenario = s as Map<String, dynamic>;
      final timetable = scenario['timetable'] as Map<String, dynamic>?;
      return {
        'ID': scenario['id']?.toString() ?? '',
        'Name': scenario['name']?.toString() ?? '',
        'Timetable': timetable?['name']?.toString() ?? 'N/A',
      };
    }).toList();

    TerminalUtils.printTable(rows, ['ID', 'Name', 'Timetable']);
  }

  Future<void> _get(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan scenario get <scenarioId>');
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Fetching scenario $scenarioId...');

    final response = await _apiClient.get(Endpoints.scenario(scenarioId));
    final scenario = response.json;

    TerminalUtils.printHeader('Scenario Details');
    _printScenarioDetails(scenario);
  }

  Future<void> _tree(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan scenario tree <scenarioId>');
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Fetching scenario tree $scenarioId...');

    final response = await _apiClient.get(Endpoints.scenarioTree(scenarioId));
    final scenario = response.json;

    TerminalUtils.printHeader('Scenario Tree');
    _printScenarioTree(scenario, 0);
  }

  Future<void> _navigate(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError(
        'Usage: uniplan scenario navigate <scenarioId> <failedCourseId>',
      );
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    final failedCourseId = int.tryParse(args[2]);

    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }
    if (failedCourseId == null) {
      TerminalUtils.printError('Invalid failed course ID: ${args[2]}');
      return;
    }

    TerminalUtils.printInfo(
      'Navigating from scenario $scenarioId when course $failedCourseId fails...',
    );

    final response = await _apiClient.post(
      Endpoints.scenarioNavigate(scenarioId),
      body: {'failedCourseId': failedCourseId},
    );

    final nextScenario = response.json;
    TerminalUtils.printSuccess('Next scenario found!');
    TerminalUtils.printSubHeader('Next Scenario');
    _printScenarioSummary(nextScenario);
  }

  Future<void> _delete(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan scenario delete <scenarioId>');
      return;
    }

    final scenarioId = int.tryParse(args[1]);
    if (scenarioId == null) {
      TerminalUtils.printError('Invalid scenario ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Deleting scenario $scenarioId...');

    await _apiClient.delete(Endpoints.scenario(scenarioId));

    TerminalUtils.printSuccess('Scenario deleted successfully!');
  }

  void _printScenarioSummary(Map<String, dynamic> scenario) {
    TerminalUtils.printKeyValue('ID', scenario['id'].toString());
    TerminalUtils.printKeyValue('Name', scenario['name'].toString());
    if (scenario['failedCourseId'] != null) {
      TerminalUtils.printKeyValue(
        'Failed Course ID',
        scenario['failedCourseId'].toString(),
      );
    }
    final timetable = scenario['timetable'] as Map<String, dynamic>?;
    if (timetable != null) {
      TerminalUtils.printKeyValue('Timetable', timetable['name'].toString());
    }
  }

  void _printScenarioDetails(Map<String, dynamic> scenario) {
    _printScenarioSummary(scenario);

    final children = scenario['childScenarios'] as List?;
    if (children != null && children.isNotEmpty) {
      print('\n${TerminalUtils.bold('Alternative Scenarios')} (${children.length}):');
      for (final child in children) {
        final c = child as Map<String, dynamic>;
        print('  - ${c['name']} (ID: ${c['id']})');
      }
    } else {
      print('\n${TerminalUtils.gray('No alternative scenarios.')}');
    }
  }

  void _printScenarioTree(Map<String, dynamic> scenario, int level) {
    final indent = '  ' * level;
    final marker = level == 0 ? '' : '└─ ';

    final failedCourseId = scenario['failedCourseId'];
    final failedInfo = failedCourseId != null ? ' (Course $failedCourseId fails)' : '';

    print('$indent$marker${scenario['name']}$failedInfo (ID: ${scenario['id']})');

    final children = scenario['childScenarios'] as List?;
    if (children != null && children.isNotEmpty) {
      for (final child in children) {
        _printScenarioTree(child as Map<String, dynamic>, level + 1);
      }
    }
  }

  void _printHelp() {
    print('''
Scenario Commands:

  create <name> <timetableId>                   Create a root scenario
  alternative <parentId> <name> <failedCourseId> <timetableId>
                                                 Create an alternative scenario
  list                                           List all root scenarios
  get <scenarioId>                              Get scenario details
  tree <scenarioId>                             Show full scenario tree
  navigate <scenarioId> <failedCourseId>        Navigate to next scenario
  delete <scenarioId>                           Delete a scenario

Examples:
  uniplan scenario create "Plan A" 1
  uniplan scenario alternative 1 "Plan B - CS101 fails" 123 2
  uniplan scenario list
  uniplan scenario get 1
  uniplan scenario tree 1
  uniplan scenario navigate 1 123
  uniplan scenario delete 2
''');
  }
}
