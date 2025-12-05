// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Course {

 int get id; int get openingYear; String get semester; int? get targetGrade; String get courseCode; String? get section; String get courseName; String? get professor; int get credits; String? get classroom; String get campus; String? get departmentCode; String? get departmentName; String? get collegeCode; String? get collegeName; List<ClassTime> get classTimes;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, id) || other.id == id)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.targetGrade, targetGrade) || other.targetGrade == targetGrade)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.departmentCode, departmentCode) || other.departmentCode == departmentCode)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.collegeCode, collegeCode) || other.collegeCode == collegeCode)&&(identical(other.collegeName, collegeName) || other.collegeName == collegeName)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openingYear,semester,targetGrade,courseCode,section,courseName,professor,credits,classroom,campus,departmentCode,departmentName,collegeCode,collegeName,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'Course(id: $id, openingYear: $openingYear, semester: $semester, targetGrade: $targetGrade, courseCode: $courseCode, section: $section, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, departmentCode: $departmentCode, departmentName: $departmentName, collegeCode: $collegeCode, collegeName: $collegeName, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
 int id, int openingYear, String semester, int? targetGrade, String courseCode, String? section, String courseName, String? professor, int credits, String? classroom, String campus, String? departmentCode, String? departmentName, String? collegeCode, String? collegeName, List<ClassTime> classTimes
});




}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? openingYear = null,Object? semester = null,Object? targetGrade = freezed,Object? courseCode = null,Object? section = freezed,Object? courseName = null,Object? professor = freezed,Object? credits = null,Object? classroom = freezed,Object? campus = null,Object? departmentCode = freezed,Object? departmentName = freezed,Object? collegeCode = freezed,Object? collegeName = freezed,Object? classTimes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,targetGrade: freezed == targetGrade ? _self.targetGrade : targetGrade // ignore: cast_nullable_to_non_nullable
as int?,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: freezed == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String?,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,departmentCode: freezed == departmentCode ? _self.departmentCode : departmentCode // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,collegeCode: freezed == collegeCode ? _self.collegeCode : collegeCode // ignore: cast_nullable_to_non_nullable
as String?,collegeName: freezed == collegeName ? _self.collegeName : collegeName // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self.classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTime> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.openingYear,_that.semester,_that.targetGrade,_that.courseCode,_that.section,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.departmentCode,_that.departmentName,_that.collegeCode,_that.collegeName,_that.classTimes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTime> classTimes)  $default,) {final _that = this;
switch (_that) {
case _Course():
return $default(_that.id,_that.openingYear,_that.semester,_that.targetGrade,_that.courseCode,_that.section,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.departmentCode,_that.departmentName,_that.collegeCode,_that.collegeName,_that.classTimes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTime> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.openingYear,_that.semester,_that.targetGrade,_that.courseCode,_that.section,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.departmentCode,_that.departmentName,_that.collegeCode,_that.collegeName,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Course implements Course {
  const _Course({required this.id, required this.openingYear, required this.semester, this.targetGrade, required this.courseCode, this.section, required this.courseName, this.professor, required this.credits, this.classroom, required this.campus, this.departmentCode, this.departmentName, this.collegeCode, this.collegeName, final  List<ClassTime> classTimes = const []}): _classTimes = classTimes;
  factory _Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

@override final  int id;
@override final  int openingYear;
@override final  String semester;
@override final  int? targetGrade;
@override final  String courseCode;
@override final  String? section;
@override final  String courseName;
@override final  String? professor;
@override final  int credits;
@override final  String? classroom;
@override final  String campus;
@override final  String? departmentCode;
@override final  String? departmentName;
@override final  String? collegeCode;
@override final  String? collegeName;
 final  List<ClassTime> _classTimes;
@override@JsonKey() List<ClassTime> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.targetGrade, targetGrade) || other.targetGrade == targetGrade)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.departmentCode, departmentCode) || other.departmentCode == departmentCode)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.collegeCode, collegeCode) || other.collegeCode == collegeCode)&&(identical(other.collegeName, collegeName) || other.collegeName == collegeName)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openingYear,semester,targetGrade,courseCode,section,courseName,professor,credits,classroom,campus,departmentCode,departmentName,collegeCode,collegeName,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'Course(id: $id, openingYear: $openingYear, semester: $semester, targetGrade: $targetGrade, courseCode: $courseCode, section: $section, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, departmentCode: $departmentCode, departmentName: $departmentName, collegeCode: $collegeCode, collegeName: $collegeName, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
 int id, int openingYear, String semester, int? targetGrade, String courseCode, String? section, String courseName, String? professor, int credits, String? classroom, String campus, String? departmentCode, String? departmentName, String? collegeCode, String? collegeName, List<ClassTime> classTimes
});




}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? openingYear = null,Object? semester = null,Object? targetGrade = freezed,Object? courseCode = null,Object? section = freezed,Object? courseName = null,Object? professor = freezed,Object? credits = null,Object? classroom = freezed,Object? campus = null,Object? departmentCode = freezed,Object? departmentName = freezed,Object? collegeCode = freezed,Object? collegeName = freezed,Object? classTimes = null,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,targetGrade: freezed == targetGrade ? _self.targetGrade : targetGrade // ignore: cast_nullable_to_non_nullable
as int?,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: freezed == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String?,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,departmentCode: freezed == departmentCode ? _self.departmentCode : departmentCode // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,collegeCode: freezed == collegeCode ? _self.collegeCode : collegeCode // ignore: cast_nullable_to_non_nullable
as String?,collegeName: freezed == collegeName ? _self.collegeName : collegeName // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self._classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,
  ));
}


}


/// @nodoc
mixin _$ClassTime {

 String get day; String get startTime; String get endTime;
/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassTimeCopyWith<ClassTime> get copyWith => _$ClassTimeCopyWithImpl<ClassTime>(this as ClassTime, _$identity);

  /// Serializes this ClassTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassTime&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTime(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $ClassTimeCopyWith<$Res>  {
  factory $ClassTimeCopyWith(ClassTime value, $Res Function(ClassTime) _then) = _$ClassTimeCopyWithImpl;
@useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class _$ClassTimeCopyWithImpl<$Res>
    implements $ClassTimeCopyWith<$Res> {
  _$ClassTimeCopyWithImpl(this._self, this._then);

  final ClassTime _self;
  final $Res Function(ClassTime) _then;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassTime].
extension ClassTimePatterns on ClassTime {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassTime value)  $default,){
final _that = this;
switch (_that) {
case _ClassTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassTime value)?  $default,){
final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String day,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String day,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _ClassTime():
return $default(_that.day,_that.startTime,_that.endTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String day,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassTime implements ClassTime {
  const _ClassTime({required this.day, required this.startTime, required this.endTime});
  factory _ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);

@override final  String day;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassTimeCopyWith<_ClassTime> get copyWith => __$ClassTimeCopyWithImpl<_ClassTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassTime&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTime(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ClassTimeCopyWith<$Res> implements $ClassTimeCopyWith<$Res> {
  factory _$ClassTimeCopyWith(_ClassTime value, $Res Function(_ClassTime) _then) = __$ClassTimeCopyWithImpl;
@override @useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class __$ClassTimeCopyWithImpl<$Res>
    implements _$ClassTimeCopyWith<$Res> {
  __$ClassTimeCopyWithImpl(this._self, this._then);

  final _ClassTime _self;
  final $Res Function(_ClassTime) _then;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_ClassTime(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
