import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'timetable.freezed.dart';
part 'timetable.g.dart';

@freezed
class ClassTime with _$ClassTime {
  const factory ClassTime({
    required String day,
    required String startTime,
    required String endTime,
  }) = _ClassTime;

  factory ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);
}

@freezed
class TimetableItem with _$TimetableItem {
  const factory TimetableItem({
    required int id,
    required int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    @Default(<ClassTime>[]) List<ClassTime> classTimes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? addedAt,
  }) = _TimetableItem;

  factory TimetableItem.fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);
}

@freezed
class TimetableCourse with _$TimetableCourse {
  const factory TimetableCourse({
    required int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    @Default(<ClassTime>[]) List<ClassTime> classTimes,
  }) = _TimetableCourse;

  factory TimetableCourse.fromJson(Map<String, dynamic> json) => _$TimetableCourseFromJson(json);
}

@freezed
class Timetable with _$Timetable {
  const factory Timetable({
    required int id,
    int? userId,
    required String name,
    required int openingYear,
    required String semester,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? updatedAt,
    @Default(<TimetableItem>[]) List<TimetableItem> items,
    @Default(<TimetableCourse>[]) List<TimetableCourse> excludedCourses,
  }) = _Timetable;

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}
