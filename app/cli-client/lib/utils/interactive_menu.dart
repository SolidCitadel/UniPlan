import 'dart:io';
import 'terminal_utils.dart';

/// Interactive menu for selecting and marking course statuses
class InteractiveMenu {
  /// Display interactive menu for course status selection
  /// Returns a map of courseId -> status (SUCCESS/FAILED/CANCELED)
  static Future<Map<int, String>> selectCourseStatuses({
    required List<CourseItem> courses,
    Map<int, String>? initialMarks,
    bool debug = false,
  }) async {
    final marks = <int, String>{...?initialMarks};
    var selectedIndex = 0;
    final keyLog = <int>[];

    // Save original terminal settings
    final originalEchoMode = stdin.echoMode;
    final originalLineMode = stdin.lineMode;

    if (debug) {
      print('DEBUG: Original echoMode=$originalEchoMode, lineMode=$originalLineMode');
      print('DEBUG: Press any key to see its byte code...\n');
    }

    // Enable raw mode
    stdin.echoMode = false;
    stdin.lineMode = false;

    try {
      while (true) {
        if (!debug) {
          _renderScreen(courses, marks, selectedIndex);
        }

        final key = stdin.readByteSync();

        if (debug) {
          keyLog.add(key);
          print('Key pressed: $key (0x${key.toRadixString(16)}) - Log: $keyLog');
          if (key == 13 || key == 10) {
            print('\nDEBUG: Enter pressed. Key log: $keyLog');
            break;
          }
          continue;
        }

        // Handle arrow keys (different on Windows vs Unix)
        if (key == 27) {
          // Unix/Linux: ESC [ A/B/C/D
          if (stdin.readByteSync() == 91) {
            final arrowKey = stdin.readByteSync();
            if (arrowKey == 65) {
              // Up arrow
              selectedIndex = (selectedIndex - 1) % courses.length;
              if (selectedIndex < 0) selectedIndex = courses.length - 1;
            } else if (arrowKey == 66) {
              // Down arrow
              selectedIndex = (selectedIndex + 1) % courses.length;
            }
          }
        } else if (key == 224 || key == 0) {
          // Windows: 224/0 followed by 72/80 for up/down
          final arrowKey = stdin.readByteSync();
          if (arrowKey == 72) {
            // Up arrow (Windows)
            selectedIndex = (selectedIndex - 1) % courses.length;
            if (selectedIndex < 0) selectedIndex = courses.length - 1;
          } else if (arrowKey == 80) {
            // Down arrow (Windows)
            selectedIndex = (selectedIndex + 1) % courses.length;
          }
        } else if (key == 32) {
          // Space - toggle status
          final courseId = courses[selectedIndex].courseId;
          final currentStatus = marks[courseId];

          if (currentStatus == null) {
            marks[courseId] = 'SUCCESS';
          } else if (currentStatus == 'SUCCESS') {
            marks[courseId] = 'FAILED';
          } else if (currentStatus == 'FAILED') {
            marks[courseId] = 'CANCELED';
          } else {
            marks.remove(courseId);
          }
        } else if (key == 13 || key == 10) {
          // Enter - confirm and exit
          break;
        } else if (key == 113 || key == 81) {
          // q or Q - quit without saving
          _restoreTerminal(originalEchoMode, originalLineMode);
          _clearScreen();
          return {};
        } else if (key == 3) {
          // Ctrl+C - quit without saving
          _restoreTerminal(originalEchoMode, originalLineMode);
          _clearScreen();
          print('\nInterrupted by user.');
          return {};
        }
      }
    } catch (e) {
      // Always restore terminal on error
      _restoreTerminal(originalEchoMode, originalLineMode);
      _clearScreen();
      print('Error in interactive menu: $e');
      rethrow;
    } finally {
      // Restore terminal mode
      _restoreTerminal(originalEchoMode, originalLineMode);

      if (debug) {
        print('DEBUG: Terminal restored. echoMode=$originalEchoMode, lineMode=$originalLineMode');
        print('DEBUG: Current echoMode=${stdin.echoMode}, lineMode=${stdin.lineMode}');
      }
    }

    if (!debug) {
      _clearScreen();
    }
    return marks;
  }

  static void _restoreTerminal(bool echoMode, bool lineMode) {
    try {
      stdin.echoMode = echoMode;
      stdin.lineMode = lineMode;
    } catch (e) {
      // Ignore errors during restoration
      print('\nWarning: Failed to restore terminal mode. Run "reset" command if keyboard input is not visible.');
    }
  }

  static void _renderScreen(
    List<CourseItem> courses,
    Map<int, String> marks,
    int selectedIndex,
  ) {
    _clearScreen();

    print(TerminalUtils.bold('=== Interactive Course Status Selection ==='));
    print('Use ${TerminalUtils.cyan('↑/↓')} to navigate, ${TerminalUtils.cyan('SPACE')} to change status, ${TerminalUtils.cyan('ENTER')} to confirm, ${TerminalUtils.cyan('Q')} or ${TerminalUtils.cyan('Ctrl+C')} to quit');
    print(TerminalUtils.gray('If keyboard input is not visible after exit, run: reset\n'));

    for (var i = 0; i < courses.length; i++) {
      final course = courses[i];
      final isSelected = i == selectedIndex;
      final status = marks[course.courseId];

      // Selection indicator
      final indicator = isSelected ? '→ ' : '  ';

      // Status display
      String statusDisplay;
      if (status == 'SUCCESS') {
        statusDisplay = TerminalUtils.colorize('SUCCESS ', TerminalColor.green, bold: true);
      } else if (status == 'FAILED') {
        statusDisplay = TerminalUtils.colorize('FAILED  ', TerminalColor.red, bold: true);
      } else if (status == 'CANCELED') {
        statusDisplay = TerminalUtils.colorize('CANCELED', TerminalColor.red, bold: true);
      } else {
        statusDisplay = TerminalUtils.colorize('PENDING ', TerminalColor.gray);
      }

      // Highlight selected row
      if (isSelected) {
        print(TerminalUtils.colorize(
          '$indicator[$statusDisplay] ${course.courseName} (ID: ${course.courseId})',
          TerminalColor.cyan,
        ));
      } else {
        print('$indicator[$statusDisplay] ${course.courseName} (ID: ${course.courseId})');
      }
    }

    print('\n${TerminalUtils.gray('Status cycle: PENDING → SUCCESS → FAILED → CANCELED → PENDING')}');

    // Show summary
    final successCount = marks.values.where((s) => s == 'SUCCESS').length;
    final failedCount = marks.values.where((s) => s == 'FAILED').length;
    final canceledCount = marks.values.where((s) => s == 'CANCELED').length;

    print('\nSummary: ${TerminalUtils.green('✓ $successCount')} / ${TerminalUtils.red('✗ $failedCount')} / ${TerminalUtils.gray('⊗ $canceledCount')}');
  }

  static void _clearScreen() {
    if (Platform.isWindows) {
      print('\x1B[2J\x1B[0;0H');
    } else {
      print('\x1B[2J\x1B[H');
    }
  }
}

/// Course item for interactive menu
class CourseItem {
  final int courseId;
  final String courseName;

  CourseItem({
    required this.courseId,
    required this.courseName,
  });
}
