import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class UserCommand {
  final ApiClient _apiClient = ApiClient();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'profile':
          await _profile();
          break;
        default:
          TerminalUtils.printError('Unknown user command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _profile() async {
    TerminalUtils.printInfo('Fetching user profile...');

    final response = await _apiClient.get(Endpoints.userProfile);
    final user = response.json;

    TerminalUtils.printHeader('User Profile');
    TerminalUtils.printKeyValue('User ID', user['id']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Email', user['email']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Name', user['name']?.toString() ?? 'N/A');
    TerminalUtils.printKeyValue('Role', user['role']?.toString() ?? 'N/A');

    if (user['createdAt'] != null) {
      TerminalUtils.printKeyValue('Created At', user['createdAt'].toString());
    }
    if (user['updatedAt'] != null) {
      TerminalUtils.printKeyValue('Updated At', user['updatedAt'].toString());
    }
  }

  void _printHelp() {
    print('''
User Commands:

  profile    Get current user profile

Examples:
  uniplan user profile
''');
  }
}
