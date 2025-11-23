// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Course _$CourseFromJson(Map<String, dynamic> json) => _Course(
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
  notes: json['notes'] as String?,
  departmentCode: json['departmentCode'] as String?,
  departmentName: json['departmentName'] as String?,
  collegeCode: json['collegeCode'] as String?,
  collegeName: json['collegeName'] as String?,
  courseTypeCode: json['courseTypeCode'] as String?,
  courseTypeName: json['courseTypeName'] as String?,
  classTimes:
      (json['classTimes'] as List<dynamic>?)
          ?.map((e) => ClassTime.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CourseToJson(_Course instance) => <String, dynamic>{
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
  'notes': instance.notes,
  'departmentCode': instance.departmentCode,
  'departmentName': instance.departmentName,
  'collegeCode': instance.collegeCode,
  'collegeName': instance.collegeName,
  'courseTypeCode': instance.courseTypeCode,
  'courseTypeName': instance.courseTypeName,
  'classTimes': instance.classTimes,
};

_ClassTime _$ClassTimeFromJson(Map<String, dynamic> json) => _ClassTime(
  day: json['day'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$ClassTimeToJson(_ClassTime instance) =>
    <String, dynamic>{
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
