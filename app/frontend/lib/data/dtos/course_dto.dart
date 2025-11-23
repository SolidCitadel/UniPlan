import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_dto.freezed.dart';
part 'course_dto.g.dart';

@freezed
abstract class CourseDto with _$CourseDto {
  const factory CourseDto({
    required int id,
    required int openingYear,
    required String semester,
    required String courseCode,
    String? section,
    required String courseName,
    String? professor,
    required int credits,
    String? classroom,
    required String campus,
    String? departmentCode,
    String? departmentName,
    String? collegeCode,
    String? collegeName,
    @Default([]) List<ClassTimeDto> classTimes,
  }) = _CourseDto;

  factory CourseDto.fromJson(Map<String, dynamic> json) => _$CourseDtoFromJson(json);
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
