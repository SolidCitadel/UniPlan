import 'package:freezed_annotation/freezed_annotation.dart';
import 'course.dart';

part 'timetable.freezed.dart';
part 'timetable.g.dart';

@freezed
class Timetable with _$Timetable {
  const factory Timetable({
    required String id,
    required String name,
    required List<Course> courses,
    String? parentId, // For decision tree structure
    @Default([]) List<String> childIds, // For decision tree structure
  }) = _Timetable;

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}
