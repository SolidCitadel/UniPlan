import 'package:uniplan_cli/api/api_client.dart';
import 'package:uniplan_cli/api/endpoints.dart';
import 'package:uniplan_cli/utils/terminal_utils.dart';

class WishlistCommand {
  final ApiClient _apiClient = ApiClient();

  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    try {
      switch (subCommand) {
        case 'add':
          await _add(args);
          break;
        case 'list':
          await _list();
          break;
        case 'remove':
          await _remove(args);
          break;
        case 'check':
          await _check(args);
          break;
        default:
          TerminalUtils.printError('Unknown wishlist command: $subCommand');
          _printHelp();
      }
    } on ApiException catch (e) {
      TerminalUtils.printError(e.toString());
    } catch (e) {
      TerminalUtils.printError('Unexpected error: $e');
    }
  }

  Future<void> _add(List<String> args) async {
    if (args.length < 3) {
      TerminalUtils.printError('Usage: uniplan wishlist add <courseId> <priority>');
      TerminalUtils.printInfo('Priority must be between 1 and 5');
      TerminalUtils.printInfo('Example: uniplan wishlist add 123 1');
      return;
    }

    final courseId = int.tryParse(args[1]);
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[1]}');
      return;
    }

    final priority = int.tryParse(args[2]);
    if (priority == null) {
      TerminalUtils.printError('Invalid priority: ${args[2]}');
      return;
    }

    if (priority < 1 || priority > 5) {
      TerminalUtils.printError('Priority must be between 1 and 5');
      return;
    }

    TerminalUtils.printInfo('Adding course $courseId to wishlist with priority $priority...');

    final response = await _apiClient.post(
      Endpoints.wishlist,
      body: {
        'courseId': courseId,
        'priority': priority,
      },
    );

    final item = response.json;
    TerminalUtils.printSuccess('Course added to wishlist!');
    TerminalUtils.printKeyValue('Course ID', item['courseId'].toString());
    TerminalUtils.printKeyValue('Priority', item['priority'].toString());
    if (item.containsKey('createdAt')) {
      TerminalUtils.printKeyValue('Added At', item['createdAt'].toString());
    }
  }

  Future<void> _list() async {
    TerminalUtils.printInfo('Fetching wishlist...');

    final response = await _apiClient.get(Endpoints.wishlist);
    final items = response.jsonList;

    if (items.isEmpty) {
      TerminalUtils.printWarning('Your wishlist is empty.');
      return;
    }

    TerminalUtils.printHeader('My Wishlist (${items.length})');

    final rows = items.map((item) {
      final i = item as Map<String, dynamic>;
      return {
        'ID': i['id']?.toString() ?? '',
        'Course ID': i['courseId']?.toString() ?? '',
        'Priority': i['priority']?.toString() ?? '',
        'Added At': i['createdAt']?.toString() ?? '',
      };
    }).toList();

    TerminalUtils.printTable(rows, ['ID', 'Course ID', 'Priority', 'Added At']);
  }

  Future<void> _remove(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan wishlist remove <courseId>');
      return;
    }

    final courseId = int.tryParse(args[1]);
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[1]}');
      return;
    }

    TerminalUtils.printInfo('Removing course $courseId from wishlist...');

    await _apiClient.delete(Endpoints.wishlistRemove(courseId));

    TerminalUtils.printSuccess('Course removed from wishlist!');
  }

  Future<void> _check(List<String> args) async {
    if (args.length < 2) {
      TerminalUtils.printError('Usage: uniplan wishlist check <courseId>');
      return;
    }

    final courseId = int.tryParse(args[1]);
    if (courseId == null) {
      TerminalUtils.printError('Invalid course ID: ${args[1]}');
      return;
    }

    final response = await _apiClient.get(Endpoints.wishlistCheck(courseId));
    final isInWishlist = response.json as bool;

    if (isInWishlist) {
      TerminalUtils.printSuccess('Course $courseId is in your wishlist.');
    } else {
      TerminalUtils.printWarning('Course $courseId is NOT in your wishlist.');
    }
  }

  void _printHelp() {
    print('''
Wishlist Commands:

  add <courseId> <priority>    Add a course to wishlist with priority (1-5)
  list                         Show all wishlist items
  remove <courseId>            Remove a course from wishlist
  check <courseId>             Check if a course is in wishlist

Priority Levels:
  1 - Highest priority (must-have course)
  2 - High priority
  3 - Medium priority
  4 - Low priority
  5 - Lowest priority (backup option)

Examples:
  uniplan wishlist add 123 1        # Add course 123 with highest priority
  uniplan wishlist add 456 3        # Add course 456 with medium priority
  uniplan wishlist list
  uniplan wishlist remove 123
  uniplan wishlist check 123
''');
  }
}
