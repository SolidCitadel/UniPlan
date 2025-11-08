import 'dart:io';
import 'package:uniplan_cli/utils/terminal_utils.dart';
import 'package:uniplan_cli/utils/simple_menu.dart';

class DebugCommand {
  Future<void> execute(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final subCommand = args[0];

    switch (subCommand) {
      case 'keys':
        await _debugKeys();
        break;
      case 'interactive':
        await _debugInteractive();
        break;
      case 'reset-terminal':
        _resetTerminal();
        break;
      default:
        TerminalUtils.printError('Unknown debug command: $subCommand');
        _printHelp();
    }
  }

  void _resetTerminal() {
    print('Resetting terminal to normal mode...');

    try {
      stdin.echoMode = true;
      stdin.lineMode = true;

      print('Terminal reset complete!');
      print('echoMode: ${stdin.echoMode}');
      print('lineMode: ${stdin.lineMode}');
      print('\nIf keyboard input is still not visible, please restart your terminal.');
    } catch (e) {
      print('Failed to reset terminal: $e');
      print('Please restart your terminal window.');
    }
  }

  Future<void> _debugKeys() async {
    print(TerminalUtils.bold('=== Keyboard Input Debug Mode ==='));
    print('Press any key to see its byte code.');
    print('Press ${TerminalUtils.cyan('ESC')} to exit.\n');

    // Save original settings
    final originalEchoMode = stdin.echoMode;
    final originalLineMode = stdin.lineMode;

    print('Original settings: echoMode=$originalEchoMode, lineMode=$originalLineMode');

    // Enable raw mode
    stdin.echoMode = false;
    stdin.lineMode = false;

    print('After raw mode: echoMode=${stdin.echoMode}, lineMode=${stdin.lineMode}');
    print('\nWaiting for input...\n');

    final keyLog = <int>[];

    try {
      while (true) {
        final key = stdin.readByteSync();
        keyLog.add(key);

        print('Key: $key (0x${key.toRadixString(16).padLeft(2, '0')}) | Log: $keyLog');

        // ESC key to exit
        if (key == 27) {
          // Check if it's just ESC or arrow key sequence
          if (stdin.hasTerminal) {
            // Wait a bit to see if more bytes come
            await Future.delayed(Duration(milliseconds: 50));

            // Read remaining bytes if any (non-blocking)
            while (true) {
              try {
                final nextKey = stdin.readByteSync();
                keyLog.add(nextKey);
                print('  → Next: $nextKey (0x${nextKey.toRadixString(16).padLeft(2, '0')}) | Log: $keyLog');
              } catch (e) {
                break;
              }
            }
          }

          print('\nESC detected. Exiting...');
          break;
        }

        // Show pattern help
        if (keyLog.length >= 3) {
          _analyzePattern(keyLog);
          keyLog.clear();
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Restore terminal
      stdin.echoMode = originalEchoMode;
      stdin.lineMode = originalLineMode;

      print('\nTerminal restored: echoMode=${stdin.echoMode}, lineMode=${stdin.lineMode}');
    }
  }

  void _analyzePattern(List<int> keys) {
    if (keys.length < 2) return;

    print('  → Pattern Analysis:');

    // Check for Windows arrow keys: 224/0 + direction
    if (keys[0] == 224 || keys[0] == 0) {
      if (keys.length >= 2) {
        switch (keys[1]) {
          case 72:
            print('  → Windows: UP ARROW');
            break;
          case 80:
            print('  → Windows: DOWN ARROW');
            break;
          case 75:
            print('  → Windows: LEFT ARROW');
            break;
          case 77:
            print('  → Windows: RIGHT ARROW');
            break;
        }
      }
    }

    // Check for Unix/Linux arrow keys: 27 + 91 + direction
    if (keys[0] == 27 && keys.length >= 3) {
      if (keys[1] == 91) {
        switch (keys[2]) {
          case 65:
            print('  → Unix/Linux: UP ARROW');
            break;
          case 66:
            print('  → Unix/Linux: DOWN ARROW');
            break;
          case 68:
            print('  → Unix/Linux: LEFT ARROW');
            break;
          case 67:
            print('  → Unix/Linux: RIGHT ARROW');
            break;
        }
      }
    }
  }

  Future<void> _debugInteractive() async {
    print(TerminalUtils.bold('=== Interactive Menu Debug Mode ==='));
    print('This will launch the interactive menu with dummy courses.\n');

    final dummyCourses = [
      CourseItem(courseId: 1, courseName: 'Test Course 1', category: 'pending'),
      CourseItem(courseId: 2, courseName: 'Test Course 2', category: 'registered'),
      CourseItem(courseId: 3, courseName: 'Test Course 3 (Failed)', category: 'failed'),
      CourseItem(courseId: 4, courseName: 'Test Course 4', category: 'pending'),
      CourseItem(courseId: 5, courseName: 'Test Course 5 (To Remove)', category: 'toCancel'),
    ];

    final result = await SimpleMenu.selectCourseStatuses(
      courses: dummyCourses,
    );

    print('\nResult: $result');
  }

  void _printHelp() {
    print('''
Debug Commands:

  keys            Debug raw keyboard input (see byte codes for arrow keys)
  interactive     Test interactive menu with dummy data
  reset-terminal  Reset terminal to normal mode (fix echo/line mode)

Usage:
  uniplan debug keys            # Press arrow keys to see byte codes
  uniplan debug interactive     # Test interactive menu
  uniplan debug reset-terminal  # Fix terminal if input is not visible

Examples:
  uniplan debug reset-terminal
  # Resets stdin.echoMode=true, stdin.lineMode=true

  uniplan debug keys
  # Press ↑ key to see: Key: 224 (0xe0) ... Next: 72 (0x48)
  # Press ↓ key to see: Key: 224 (0xe0) ... Next: 80 (0x50)
  # Press ESC to exit
''');
  }
}
