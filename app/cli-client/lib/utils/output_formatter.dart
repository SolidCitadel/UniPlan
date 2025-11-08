import 'dart:io';
import 'dart:convert';
import 'terminal_utils.dart';

class OutputFormatter {
  static String _getSeparator(String label) {
    // Get terminal width, default to 80 if unavailable
    final width = stdout.hasTerminal ? stdout.terminalColumns : 80;
    final totalPadding = width - label.length;
    final leftPadding = totalPadding ~/ 2;
    final rightPadding = totalPadding - leftPadding;

    return '=' * leftPadding + label + '=' * rightPadding;
  }

  static void printHttpRequest(
    String method,
    String url, {
    Map<String, String>? headers,
    String? body,
  }) {
    print('');
    print(TerminalUtils.cyan(_getSeparator(' HTTP Request ')));
    print('$method $url');

    // Only show Authorization header if present
    if (headers != null && headers.containsKey('Authorization')) {
      final auth = headers['Authorization']!;
      final displayAuth = auth.length > 30
          ? '${auth.substring(0, 30)}...'
          : auth;
      print(TerminalUtils.gray('Authorization: $displayAuth'));
    }

    if (body != null && body.isNotEmpty) {
      try {
        final json = jsonDecode(body);
        final prettyJson = JsonEncoder.withIndent('  ').convert(json);

        // Truncate if more than 20 lines
        final lines = prettyJson.split('\n');
        if (lines.length > 20) {
          print(lines.take(20).join('\n'));
          print(TerminalUtils.gray('... (${lines.length - 20} more lines omitted)'));
        } else {
          print(prettyJson);
        }
      } catch (e) {
        // Not JSON, print as is (also truncate if too long)
        final lines = body.split('\n');
        if (lines.length > 20) {
          print(lines.take(20).join('\n'));
          print(TerminalUtils.gray('... (${lines.length - 20} more lines omitted)'));
        } else {
          print(body);
        }
      }
    }
  }

  static void printHttpResponse(
    int statusCode,
    String? body, {
    Map<String, String>? headers,
  }) {
    print('');
    print(TerminalUtils.cyan(_getSeparator(' HTTP Response ')));

    final statusColor = statusCode >= 200 && statusCode < 300
        ? TerminalUtils.green
        : TerminalUtils.red;
    print(statusColor('$statusCode'));

    if (body != null && body.isNotEmpty) {
      try {
        final json = jsonDecode(body);
        final prettyJson = JsonEncoder.withIndent('  ').convert(json);

        // Truncate if more than 20 lines
        final lines = prettyJson.split('\n');
        if (lines.length > 20) {
          print(lines.take(20).join('\n'));
          print(TerminalUtils.gray('... (${lines.length - 20} more lines omitted)'));
        } else {
          print(prettyJson);
        }
      } catch (e) {
        // Not JSON, print as is (also truncate if too long)
        final lines = body.split('\n');
        if (lines.length > 20) {
          print(lines.take(20).join('\n'));
          print(TerminalUtils.gray('... (${lines.length - 20} more lines omitted)'));
        } else {
          print(body);
        }
      }
    }

    print('');
    print(TerminalUtils.cyan(_getSeparator(' Result ')));
  }

  static void printApiError(int statusCode, String message) {
    TerminalUtils.printError('HTTP $statusCode: $message');
  }
}
