import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_dto.freezed.dart';
part 'timetable_dto.g.dart';

@freezed
abstract class TimetableDto with _$TimetableDto {
  const factory TimetableDto({
    required int id,
    required String name,
    required int openingYear,
    required String semester,
    @Default([]) List<int> excludedCourseIds,
    @Default([]) List<TimetableItemDto> items,
  }) = _TimetableDto;

  factory TimetableDto.fromJson(Map<String, dynamic> json) => _$TimetableDtoFromJson(json);
}

@freezed
abstract class TimetableItemDto with _$TimetableItemDto {
  const factory TimetableItemDto({
    required int id,
    required int courseId,
    required String courseName,
    required String professor,
    String? classroom,
    @Default([]) List<ClassTimeDto> classTimes,
  }) = _TimetableItemDto;

  factory TimetableItemDto.fromJson(Map<String, dynamic> json) => _$TimetableItemDtoFromJson(json);
}

@freezed
abstract class ClassTimeDto with _$ClassTimeDto {
  const factory ClassTimeDto({
    required String day,
    required String startTime,
    required String endTime,
  }) = _ClassTimeDto;

  factory ClassTimeDto.fromJson(Map<String, dynamic> json) => _$ClassTimeDtoFromJson(json);
}
