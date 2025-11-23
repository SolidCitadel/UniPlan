import '../../domain/entities/course.dart';

// Time slot utilities for timetable
class TimeSlot {
  final int day; // 0=월, 1=화, 2=수, 3=목, 4=금
  final double startHour;
  final double duration;

  const TimeSlot({
    required this.day,
    required this.startHour,
    required this.duration,
  });

  double get endHour => startHour + duration;
}


class TimeSlotParser {
  static final _dayCodeMap = {
    'MON': 0,
    'TUE': 1,
    'WED': 2,
    'THU': 3,
    'FRI': 4,
    'SAT': 5,
    'SUN': 6,
  };

  static final _dayMap = {
    '월': 0,
    '화': 1,
    '수': 2,
    '목': 3,
    '금': 4,
  };

  /// Convert ClassTime entity to TimeSlot
  static TimeSlot fromClassTime(ClassTime classTime) {
    final day = _dayCodeMap[classTime.day] ?? 0;
    
    final startParts = classTime.startTime.split(':');
    final endParts = classTime.endTime.split(':');
    
    final startHour = int.parse(startParts[0]) + int.parse(startParts[1]) / 60.0;
    final endHour = int.parse(endParts[0]) + int.parse(endParts[1]) / 60.0;
    
    return TimeSlot(
      day: day,
      startHour: startHour,
      duration: endHour - startHour,
    );
  }

  /// Parse time string like "월 17:00 - 18:50" to TimeSlot
  static List<TimeSlot> parse(String timeString) {
    if (timeString == '-' || timeString.isEmpty) return [];

    final slots = <TimeSlot>[];
    final lines = timeString.split('\n');

    for (final line in lines) {
      final match = RegExp(r'([월화수목금])\s+(\d+):(\d+)\s*-\s*(\d+):(\d+)').firstMatch(line);
      if (match != null) {
        final day = _dayMap[match.group(1)];
        if (day == null) continue;

        final startHour = int.parse(match.group(2)!) + int.parse(match.group(3)!) / 60.0;
        final endHour = int.parse(match.group(4)!) + int.parse(match.group(5)!) / 60.0;
        final duration = endHour - startHour;

        slots.add(TimeSlot(day: day, startHour: startHour, duration: duration));
      }
    }

    return slots;
  }

  /// Check if two time slot lists have conflicts
  static bool hasConflict(List<TimeSlot> slots1, List<TimeSlot> slots2) {
    for (final slot1 in slots1) {
      for (final slot2 in slots2) {
        if (slot1.day == slot2.day) {
          final end1 = slot1.endHour;
          final end2 = slot2.endHour;

          // Check for overlap
          if (!(end1 <= slot2.startHour || end2 <= slot1.startHour)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Format hour for display (9.0 -> "9 AM", 13.5 -> "1:30 PM")
  static String formatHour(double hour) {
    final h = hour.floor();
    final m = ((hour - h) * 60).round();

    if (h == 12) {
      return m == 0 ? '12 PM' : '12:${m.toString().padLeft(2, '0')} PM';
    } else if (h < 12) {
      return m == 0 ? '$h AM' : '$h:${m.toString().padLeft(2, '0')} AM';
    } else {
      final displayHour = h - 12;
      return m == 0 ? '$displayHour PM' : '$displayHour:${m.toString().padLeft(2, '0')} PM';
    }
  }
}
