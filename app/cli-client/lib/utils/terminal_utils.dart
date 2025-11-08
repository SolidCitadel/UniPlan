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

  /// Calculate display width of a string (CJK characters count as 2, others as 1)
  static int displayWidth(String text) {
    var width = 0;
    for (var i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      // CJK Unified Ideographs, Hangul, Hiragana, Katakana, etc.
      if ((code >= 0x1100 && code <= 0x11FF) ||   // Hangul Jamo
          (code >= 0x2E80 && code <= 0x9FFF) ||   // CJK
          (code >= 0xAC00 && code <= 0xD7AF) ||   // Hangul Syllables
          (code >= 0xFF00 && code <= 0xFFEF)) {   // Fullwidth Forms
        width += 2;
      } else {
        width += 1;
      }
    }
    return width;
  }

  /// Pad string to target display width (considering CJK characters)
  static String padToWidth(String text, int targetWidth) {
    final currentWidth = displayWidth(text);
    if (currentWidth >= targetWidth) {
      return text;
    }
    final padding = ' ' * (targetWidth - currentWidth);
    return text + padding;
  }

  static void printTable(
    List<Map<String, String>> rows,
    List<String> headers, {
    Map<String, int>? minWidths,
  }) {
    if (rows.isEmpty) {
      print(gray('No data to display.'));
      return;
    }

    // Calculate column widths using display width (CJK-aware)
    final widths = <String, int>{};
    for (final header in headers) {
      widths[header] = displayWidth(header);
    }

    for (final row in rows) {
      for (final header in headers) {
        final value = row[header] ?? '';
        final valueWidth = displayWidth(value);
        if (valueWidth > widths[header]!) {
          widths[header] = valueWidth;
        }
      }
    }

    // Apply minimum widths
    if (minWidths != null) {
      minWidths.forEach((header, minWidth) {
        if (widths.containsKey(header) && widths[header]! < minWidth) {
          widths[header] = minWidth;
        }
      });
    }

    // Print header
    final headerParts = headers.map((h) => padToWidth(h, widths[h]!)).toList();
    final headerLine = headerParts.join(' | ');
    print(bold(headerLine));
    print(bold('-' * displayWidth(headerLine)));

    // Print rows
    for (final row in rows) {
      final rowParts = headers
          .map((h) => padToWidth(row[h] ?? '', widths[h]!))
          .toList();
      final line = rowParts.join(' | ');
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
