import 'dart:io';
import 'terminal_utils.dart';

/// Simple number-based menu for course status selection (Windows-compatible)
class SimpleMenu {
  /// Display simple number-based menu for course status selection
  /// Returns a map of courseId -> status (SUCCESS/FAILED/CANCELED)
  static Future<Map<int, String>> selectCourseStatuses({
    required List<CourseItem> courses,
    Map<int, String>? initialMarks,
    Map<String, String>? contextInfo,
  }) async {
    final marks = <int, String>{...?initialMarks};

    // Create a map of index -> CourseItem for quick lookup
    final coursesByIndex = <int, CourseItem>{};
    for (var i = 0; i < courses.length; i++) {
      coursesByIndex[i + 1] = courses[i];
    }

    // Save original terminal settings
    final originalEchoMode = stdin.echoMode;
    final originalLineMode = stdin.lineMode;

    // Enable raw mode for single-key input
    try {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } catch (e) {
      TerminalUtils.printError('Failed to set terminal raw mode: $e');
      return marks;
    }

    try {
      while (true) {
        _renderScreen(courses, marks, contextInfo);

        final key = stdin.readByteSync();

        // 'd' key (100) - done
        if (key == 100 || key == 68) {
          break;
        }

        // 'q' key (113) - quit
        if (key == 113 || key == 81) {
          _restoreTerminal(originalEchoMode, originalLineMode);
          TerminalUtils.clearScreen();
          return {};
        }

        // Number keys: 1-9 (49-57)
        if (key >= 49 && key <= 57) {
          final index = key - 48; // '1' = 49, so 49 - 48 = 1
          final course = coursesByIndex[index];
          if (course != null) {
            _cycleStatus(marks, course.courseId, course.category);
          }
        }

        // Enter key (just refresh screen)
        if (key == 13 || key == 10) {
          continue;
        }
      }
    } catch (e) {
      _restoreTerminal(originalEchoMode, originalLineMode);
      TerminalUtils.clearScreen();
      TerminalUtils.printError('Error in menu: $e');
      return {};
    } finally {
      // Always restore terminal mode
      _restoreTerminal(originalEchoMode, originalLineMode);
    }

    TerminalUtils.clearScreen();
    return marks;
  }

  static void _restoreTerminal(bool echoMode, bool lineMode) {
    // Only restore if values are different to avoid Windows error
    try {
      if (stdin.echoMode != echoMode) {
        stdin.echoMode = echoMode;
      }
    } catch (e) {
      // Ignore echo mode errors
    }

    try {
      if (stdin.lineMode != lineMode) {
        stdin.lineMode = lineMode;
      }
    } catch (e) {
      // Ignore line mode errors
    }
  }

  static void _cycleStatus(Map<int, String> marks, int courseId, String category) {
    final currentStatus = marks[courseId];

    switch (category) {
      case 'registered':
        // Registered courses: SUCCESS ↔ (keep registered, no change allowed)
        // User shouldn't change already registered courses in current timetable
        break;

      case 'pending':
        // Pending courses: PENDING → SUCCESS → FAILED → PENDING
        switch (currentStatus) {
          case null:
          case 'PENDING':
            marks[courseId] = 'SUCCESS';
            break;
          case 'SUCCESS':
            marks[courseId] = 'FAILED';
            break;
          case 'FAILED':
            marks.remove(courseId); // Back to PENDING
            break;
          default:
            marks.remove(courseId);
        }
        break;

      case 'failed':
        // Failed courses: FAILED → SUCCESS → FAILED
        switch (currentStatus) {
          case 'FAILED':
            marks[courseId] = 'SUCCESS';
            break;
          case 'SUCCESS':
            marks[courseId] = 'FAILED';
            break;
          default:
            marks[courseId] = 'FAILED';
        }
        break;

      case 'toCancel':
        // Courses to cancel: SUCCESS → CANCELED → SUCCESS
        switch (currentStatus) {
          case 'SUCCESS':
            marks[courseId] = 'CANCELED';
            break;
          case 'CANCELED':
            marks[courseId] = 'SUCCESS';
            break;
          default:
            marks[courseId] = 'SUCCESS';
        }
        break;
    }
  }

  static void _renderScreen(
    List<CourseItem> courses,
    Map<int, String> marks,
    Map<String, String>? contextInfo,
  ) {
    TerminalUtils.clearScreen();

    print(TerminalUtils.bold('=== Course Registration ==='));

    // Show context information
    if (contextInfo != null) {
      print('${TerminalUtils.gray('Registration ID')}: ${contextInfo['registrationId']}');
      print('${TerminalUtils.gray('Scenario')}: ${TerminalUtils.bold(contextInfo['scenarioName'] ?? '')}');
      print('${TerminalUtils.gray('Timetable')}: ${TerminalUtils.bold(contextInfo['timetableName'] ?? '')}');

      final succeeded = int.tryParse(contextInfo['totalSucceeded'] ?? '0') ?? 0;
      final failed = int.tryParse(contextInfo['totalFailed'] ?? '0') ?? 0;
      final canceled = int.tryParse(contextInfo['totalCanceled'] ?? '0') ?? 0;

      print('${TerminalUtils.gray('Total')}: ${TerminalUtils.green('✓ $succeeded')} / ${TerminalUtils.red('✗ $failed')} / ${TerminalUtils.gray('⊗ $canceled')}');
      print('');
    }

    print('Press number keys to cycle status, ${TerminalUtils.cyan('D')} to submit, ${TerminalUtils.cyan('Q')} to quit\n');

    // Group courses by category
    final registered = <int, CourseItem>{};
    final pending = <int, CourseItem>{};
    final failed = <int, CourseItem>{};
    final toCancel = <int, CourseItem>{};

    for (var i = 0; i < courses.length; i++) {
      final course = courses[i];
      final index = i + 1;

      switch (course.category) {
        case 'registered':
          registered[index] = course;
          break;
        case 'pending':
          pending[index] = course;
          break;
        case 'failed':
          failed[index] = course;
          break;
        case 'toCancel':
          toCancel[index] = course;
          break;
      }
    }

    // Display registered courses
    if (registered.isNotEmpty) {
      print(TerminalUtils.green('✓ Registered Courses:') + TerminalUtils.gray(' (no changes needed)'));
      for (final entry in registered.entries) {
        final index = entry.key;
        final course = entry.value;
        final status = marks[course.courseId] ?? 'SUCCESS';
        final statusDisplay = _getStatusDisplay(status);
        print('  $index. [$statusDisplay] ${course.courseName}');
      }
      print('');
    }

    // Display pending courses
    if (pending.isNotEmpty) {
      print(TerminalUtils.yellow('○ Courses to Register:') + TerminalUtils.gray(' (PENDING → SUCCESS → FAILED)'));
      for (final entry in pending.entries) {
        final index = entry.key;
        final course = entry.value;
        final status = marks[course.courseId] ?? 'PENDING';
        final statusDisplay = _getStatusDisplay(status);
        print('  $index. [$statusDisplay] ${course.courseName}');
      }
      print('');
    }

    // Display failed courses
    if (failed.isNotEmpty) {
      print(TerminalUtils.red('✗ Failed Courses:') + TerminalUtils.gray(' (FAILED ↔ SUCCESS)'));
      for (final entry in failed.entries) {
        final index = entry.key;
        final course = entry.value;
        final status = marks[course.courseId] ?? 'FAILED';
        final statusDisplay = _getStatusDisplay(status);
        print('  $index. [$statusDisplay] ${course.courseName}');
      }
      print('');
    }

    // Display courses to cancel (emphasized in red)
    if (toCancel.isNotEmpty) {
      print(TerminalUtils.colorize('⊗ Courses to Cancel:', TerminalColor.red, bold: true) + TerminalUtils.gray(' (SUCCESS ↔ CANCELED)'));
      for (final entry in toCancel.entries) {
        final index = entry.key;
        final course = entry.value;
        final status = marks[course.courseId] ?? 'SUCCESS';
        final statusDisplay = _getStatusDisplay(status);
        print('  $index. [$statusDisplay] ${TerminalUtils.colorize(course.courseName, TerminalColor.red)}');
      }
      print('');
    }

    print(TerminalUtils.gray('Press number key to cycle status for that course'));
  }

  static String _getStatusDisplay(String status) {
    switch (status) {
      case 'SUCCESS':
        return TerminalUtils.colorize('SUCCESS ', TerminalColor.green, bold: true);
      case 'FAILED':
        return TerminalUtils.colorize('FAILED  ', TerminalColor.red, bold: true);
      case 'CANCELED':
        return TerminalUtils.colorize('CANCELED', TerminalColor.red, bold: true);
      default:
        return TerminalUtils.colorize('PENDING ', TerminalColor.gray);
    }
  }
}

/// Course item for menu
class CourseItem {
  final int courseId;
  final String courseName;
  final String category; // 'registered', 'pending', 'failed', 'toCancel'

  CourseItem({
    required this.courseId,
    required this.courseName,
    required this.category,
  });
}
