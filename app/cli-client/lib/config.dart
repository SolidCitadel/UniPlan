import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  String apiUrl = 'http://localhost:8080';
  bool showDetails = false;
  bool clearScreen = false;
  bool autoClear = false;

  String get configDir {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    return path.join(home, '.uniplan');
  }

  String get configFile => path.join(configDir, 'config.json');

  Future<void> load() async {
    try {
      final file = File(configFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        apiUrl = json['apiUrl'] as String? ?? apiUrl;
      }
    } catch (e) {
      // Ignore load errors, use defaults
    }
  }

  Future<void> save() async {
    try {
      final dir = Directory(configDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File(configFile);
      final json = {
        'apiUrl': apiUrl,
      };
      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      // Ignore save errors
    }
  }

  void updateFromArgs(Map<String, dynamic> args) {
    if (args.containsKey('api-url')) {
      apiUrl = args['api-url'] as String;
    }
    showDetails = args['details'] == true;
    clearScreen = args['clear'] == true;
  }
}
