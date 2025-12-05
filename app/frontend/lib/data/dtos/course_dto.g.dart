// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseDto _$CourseDtoFromJson(Map<String, dynamic> json) => _CourseDto(
  id: (json['id'] as num).toInt(),
  openingYear: (json['openingYear'] as num).toInt(),
  semester: json['semester'] as String,
  targetGrade: (json['targetGrade'] as num?)?.toInt(),
  courseCode: json['courseCode'] as String,
  section: json['section'] as String?,
  courseName: json['courseName'] as String,
  professor: json['professor'] as String?,
  credits: (json['credits'] as num).toInt(),
  classroom: json['classroom'] as String?,
  campus: json['campus'] as String,
  departmentCode: json['departmentCode'] as String?,
  departmentName: json['departmentName'] as String?,
  collegeCode: json['collegeCode'] as String?,
  collegeName: json['collegeName'] as String?,
  classTimes:
      (json['classTimes'] as List<dynamic>?)
          ?.map((e) => ClassTimeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CourseDtoToJson(_CourseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openingYear': instance.openingYear,
      'semester': instance.semester,
      'targetGrade': instance.targetGrade,
      'courseCode': instance.courseCode,
      'section': instance.section,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'credits': instance.credits,
      'classroom': instance.classroom,
      'campus': instance.campus,
      'departmentCode': instance.departmentCode,
      'departmentName': instance.departmentName,
      'collegeCode': instance.collegeCode,
      'collegeName': instance.collegeName,
      'classTimes': instance.classTimes,
    };

_ClassTimeDto _$ClassTimeDtoFromJson(Map<String, dynamic> json) =>
    _ClassTimeDto(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$ClassTimeDtoToJson(_ClassTimeDto instance) =>
    <String, dynamic>{
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
