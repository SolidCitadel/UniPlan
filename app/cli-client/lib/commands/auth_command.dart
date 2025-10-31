import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/token_manager.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class AuthCommand {
  final ApiClient _apiClient = ApiClient();
  final TokenManager _tokenManager = TokenManager();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'login':
          await _login(args);
          break;
        case 'signup':
          await _signup(args);
          break;
        case 'refresh':
          await _refresh();
          break;
        case 'logout':
          await _logout();
          break;
        default:
          TerminalUtils.printError('Unknown auth command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _login(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError('Usage: uniplan auth login <email> <password>');
      return;
    }

    final email = args[1];
    final password = args[2];

    TerminalUtils.printInfo('Logging in as $email...');

    final response = await _apiClient.post(
      Endpoints.authLogin,
      body: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    final json = response.json;
    final accessToken = json['accessToken'] as String;
    final refreshToken = json['refreshToken'] as String;

    await _tokenManager.save(accessToken, refreshToken);

    TerminalUtils.printSuccess('Successfully logged in!');
    TerminalUtils.printKeyValue('Email', email);
  }

  Future<void> _signup(List<String> args) async {
    if (args.length < 4) {
      TerminalUtils.printError(
        'Usage: uniplan auth signup <email> <password> <name>',
      );
      return;
    }

    final email = args[1];
    final password = args[2];
    final name = args[3];

    TerminalUtils.printInfo('Creating account for $email...');

    final response = await _apiClient.post(
      Endpoints.authSignup,
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
      requiresAuth: false,
    );

    final json = response.json;
    final accessToken = json['accessToken'] as String;
    final refreshToken = json['refreshToken'] as String;

    await _tokenManager.save(accessToken, refreshToken);

    TerminalUtils.printSuccess('Account created successfully!');
    TerminalUtils.printKeyValue('Email', email);
    TerminalUtils.printKeyValue('Name', name);
  }

  Future<void> _refresh() async {
    await _tokenManager.load();

    if (_tokenManager.refreshToken == null) {
      TerminalUtils.printError('No refresh token found. Please login first.');
      return;
    }

    TerminalUtils.printInfo('Refreshing access token...');

    final response = await _apiClient.post(
      Endpoints.authRefresh,
      body: {
        'refreshToken': _tokenManager.refreshToken,
      },
      requiresAuth: false,
    );

    final json = response.json;
    final accessToken = json['accessToken'] as String;
    final refreshToken = json['refreshToken'] as String;

    await _tokenManager.save(accessToken, refreshToken);

    TerminalUtils.printSuccess('Access token refreshed successfully!');
  }

  Future<void> _logout() async {
    await _tokenManager.load();

    if (!_tokenManager.isLoggedIn) {
      TerminalUtils.printWarning('Not logged in.');
      return;
    }

    try {
      // Try to call logout endpoint
      await _apiClient.post(Endpoints.authLogout);
    } catch (e) {
      // Ignore errors, we'll clear the token anyway
    }

    await _tokenManager.clear();
    TerminalUtils.printSuccess('Logged out successfully!');
  }

  void _printHelp() {
    print('''
Auth Commands:

  login <email> <password>    Login with email and password
  signup <email> <password> <name>    Create a new account
  refresh                     Refresh access token
  logout                      Logout and clear tokens

Examples:
  uniplan auth login test@test.com password123
  uniplan auth signup new@test.com password123 "John Doe"
  uniplan auth refresh
  uniplan auth logout
''');
  }
}
