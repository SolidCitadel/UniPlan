import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

enum TerminalColor {
  green,
  red,
  yellow,
  blue,
  cyan,
  gray,
  white,
}

class TerminalUtils {
  static final AnsiPen green = AnsiPen()..green();
  static final AnsiPen red = AnsiPen()..red();
  static final AnsiPen yellow = AnsiPen()..yellow();
  static final AnsiPen blue = AnsiPen()..blue();
  static final AnsiPen cyan = AnsiPen()..cyan();
  static final AnsiPen gray = AnsiPen()..gray();
  static final AnsiPen bold = AnsiPen()..white(bold: true);

  /// Colorize text with the given color
  static String colorize(String text, TerminalColor color, {bool bold = false}) {
    // ANSI color codes
    const codes = {
      TerminalColor.green: '32',
      TerminalColor.red: '31',
      TerminalColor.yellow: '33',
      TerminalColor.blue: '34',
      TerminalColor.cyan: '36',
      TerminalColor.gray: '90',
      TerminalColor.white: '37',
    };

    final colorCode = codes[color] ?? '37';
    final boldCode = bold ? '1;' : '';

    return '\x1B[${boldCode}${colorCode}m$text\x1B[0m';
  }

  static void clearScreen() {
    if (Platform.isWindows) {
      // Windows cmd.exe
      print('\x1B[2J\x1B[0;0H');
    } else {
      // Unix-like systems
      print('\x1B[2J\x1B[H');
    }
  }

  static void printSuccess(String message) {
    print(green(message));
  }

  static void printError(String message) {
    print(red('ERROR: $message'));
  }

  static void printWarning(String message) {
    print(yellow('WARNING: $message'));
  }

  static void printInfo(String message) {
    print(cyan(message));
  }

  static void printHeader(String message) {
    print(bold('\n$message'));
    print(bold('=' * message.length));
  }

  static void printSubHeader(String message) {
    print(bold('\n$message'));
  }

  static void printKeyValue(String key, String value) {
    print('${bold(key)}: $value');
  }

  static void printTable(List<Map<String, String>> rows, List<String> headers) {
    if (rows.isEmpty) {
      print(gray('No data to display.'));
      return;
    }

    // Calculate column widths
    final widths = <String, int>{};
    for (final header in headers) {
      widths[header] = header.length;
    }

    for (final row in rows) {
      for (final header in headers) {
        final value = row[header] ?? '';
        if (value.length > widths[header]!) {
          widths[header] = value.length;
        }
      }
    }

    // Print header
    final headerLine = headers
        .map((h) => h.padRight(widths[h]!))
        .join(' | ');
    print(bold(headerLine));
    print(bold('-' * headerLine.length));

    // Print rows
    for (final row in rows) {
      final line = headers
          .map((h) => (row[h] ?? '').padRight(widths[h]!))
          .join(' | ');
      print(line);
    }
  }

  static void printJson(Map<String, dynamic> json, {int indent = 0}) {
    json.forEach((key, value) {
      final prefix = '  ' * indent;
      if (value is Map) {
        print('$prefix${bold(key)}:');
        printJson(value as Map<String, dynamic>, indent: indent + 1);
      } else if (value is List) {
        print('$prefix${bold(key)}:');
        for (var i = 0; i < value.length; i++) {
          if (value[i] is Map) {
            print('$prefix  [$i]:');
            printJson(value[i] as Map<String, dynamic>, indent: indent + 2);
          } else {
            print('$prefix  - ${value[i]}');
          }
        }
      } else {
        print('$prefix${bold(key)}: $value');
      }
    });
  }
}
