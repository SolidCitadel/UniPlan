import 'package:freezed_annotation/freezed_annotation.dart';
import 'course.dart';

part 'timetable.freezed.dart';
part 'timetable.g.dart';

@freezed
abstract class Timetable with _$Timetable {
  const factory Timetable({
    required int id,
    required int userId,
    required String name,
    required int openingYear,
    required String semester,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<TimetableItem> items,
    @Default([]) List<int> excludedCourseIds,
  }) = _Timetable;

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}

@freezed
abstract class TimetableItem with _$TimetableItem {
  const factory TimetableItem({
    required int id,
    required int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    @Default([]) List<ClassTime> classTimes,
    DateTime? addedAt,
  }) = _TimetableItem;

  factory TimetableItem.fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);
}
