import 'dart:convert';
import 'terminal_utils.dart';

class OutputFormatter {
  static void printHttpRequest(
    String method,
    String url, {
    Map<String, String>? headers,
    String? body,
  }) {
    TerminalUtils.printSubHeader('HTTP REQUEST');
    TerminalUtils.printKeyValue('Method', method);
    TerminalUtils.printKeyValue('URL', url);

    if (headers != null && headers.isNotEmpty) {
      print('\n${TerminalUtils.bold('Headers')}:');
      headers.forEach((key, value) {
        // Mask sensitive headers
        final displayValue = key.toLowerCase() == 'authorization'
            ? '${value.substring(0, 20)}...'
            : value;
        print('  $key: $displayValue');
      });
    }

    if (body != null && body.isNotEmpty) {
      print('\n${TerminalUtils.bold('Body')}:');
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
    TerminalUtils.printSubHeader('HTTP RESPONSE');

    final statusColor = statusCode >= 200 && statusCode < 300
        ? TerminalUtils.green
        : TerminalUtils.red;
    print('${TerminalUtils.bold('Status')}: ${statusColor('$statusCode')}');

    if (headers != null && headers.isNotEmpty) {
      print('\n${TerminalUtils.bold('Headers')}:');
      headers.forEach((key, value) {
        print('  $key: $value');
      });
    }

    if (body != null && body.isNotEmpty) {
      print('\n${TerminalUtils.bold('Body')}:');
      try {
        final json = jsonDecode(body);
        print(JsonEncoder.withIndent('  ').convert(json));
      } catch (e) {
        print(body);
      }
    }
    print('');
  }

  static void printApiError(int statusCode, String message) {
    TerminalUtils.printError('HTTP $statusCode: $message');
  }
}
