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
        print(JsonEncoder.withIndent('  ').convert(json));
      } catch (e) {
        print(body);
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
        print(JsonEncoder.withIndent('  ').convert(json));
      } catch (e) {
        print(body);
      }
    }

    print('');
    print(TerminalUtils.cyan(_getSeparator(' Result ')));
  }

  static void printApiError(int statusCode, String message) {
    TerminalUtils.printError('HTTP $statusCode: $message');
  }
}
