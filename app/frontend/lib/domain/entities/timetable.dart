import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable.freezed.dart';
part 'timetable.g.dart';

@freezed
abstract class Timetable with _$Timetable {
  const factory Timetable({
    required int id,
    required String name,
    required int openingYear,
    required String semester,
    @Default([]) List<TimetableItem> items,
  }) = _Timetable;

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}

@freezed
abstract class TimetableItem with _$TimetableItem {
  const factory TimetableItem({
    required int id,
    required int courseId,
    required String courseName,
    required String professor,
    @Default([]) List<ClassTime> classTimes,
  }) = _TimetableItem;

  factory TimetableItem.fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);
}

@freezed
abstract class ClassTime with _$ClassTime {
  const factory ClassTime({
    required String day,
    required String startTime,
    required String endTime,
  }) = _ClassTime;

  factory ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);
}
