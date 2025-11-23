class AuthException implements Exception {
  final String message;
  final Map<String, String>? validationErrors;

  AuthException(this.message, {this.validationErrors});

  @override
  String toString() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      final errors = validationErrors!.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      return '$message ($errors)';
    }
    return message;
  }
}
