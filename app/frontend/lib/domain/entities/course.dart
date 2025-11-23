import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
abstract class Course with _$Course {
  const factory Course({
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
    @Default([]) List<ClassTime> classTimes,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
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
