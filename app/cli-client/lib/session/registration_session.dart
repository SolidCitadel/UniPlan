/// Registration session management for batch course marking
class RegistrationSession {
  int? _registrationId;
  final Map<int, String> _markedCourses = {};

  bool get isActive => _registrationId != null;
  int? get registrationId => _registrationId;
  Map<int, String> get markedCourses => Map.unmodifiable(_markedCourses);

  /// Start a new registration session
  void start(int registrationId) {
    _registrationId = registrationId;
    _markedCourses.clear();
  }

  /// Mark a course with result
  void mark(int courseId, String status) {
    if (!isActive) {
      throw StateError('No active registration session. Use "registration start <scenarioId>" first.');
    }
    if (status != 'SUCCESS' && status != 'FAILED' && status != 'CANCELED') {
      throw ArgumentError('Status must be SUCCESS, FAILED, or CANCELED');
    }
    _markedCourses[courseId] = status;
  }

  /// Unmark a course
  void unmark(int courseId) {
    if (!isActive) {
      throw StateError('No active registration session.');
    }
    _markedCourses.remove(courseId);
  }

  /// Get submit data for API
  Map<String, dynamic> getSubmitData() {
    if (!isActive) {
      throw StateError('No active registration session.');
    }

    final succeededCourses = <int>[];
    final failedCourses = <int>[];
    final canceledCourses = <int>[];

    _markedCourses.forEach((courseId, status) {
      if (status == 'SUCCESS') {
        succeededCourses.add(courseId);
      } else if (status == 'FAILED') {
        failedCourses.add(courseId);
      } else if (status == 'CANCELED') {
        canceledCourses.add(courseId);
      }
    });

    return {
      'succeededCourses': succeededCourses,
      'failedCourses': failedCourses,
      'canceledCourses': canceledCourses,
    };
  }

  /// Clear all marks (but keep session active)
  void clearMarks() {
    _markedCourses.clear();
  }

  /// End the session completely
  void end() {
    _registrationId = null;
    _markedCourses.clear();
  }

  /// Get summary of current marks
  String getSummary() {
    if (!isActive) {
      return 'No active registration session.';
    }

    if (_markedCourses.isEmpty) {
      return 'No courses marked yet.';
    }

    final buffer = StringBuffer();
    buffer.writeln('Marked Courses:');

    final succeeded = <int>[];
    final failed = <int>[];
    final canceled = <int>[];

    _markedCourses.forEach((courseId, status) {
      if (status == 'SUCCESS') {
        succeeded.add(courseId);
      } else if (status == 'FAILED') {
        failed.add(courseId);
      } else if (status == 'CANCELED') {
        canceled.add(courseId);
      }
    });

    if (succeeded.isNotEmpty) {
      buffer.writeln('  SUCCESS: ${succeeded.join(', ')}');
    }
    if (failed.isNotEmpty) {
      buffer.writeln('  FAILED: ${failed.join(', ')}');
    }
    if (canceled.isNotEmpty) {
      buffer.writeln('  CANCELED: ${canceled.join(', ')}');
    }

    return buffer.toString();
  }
}
