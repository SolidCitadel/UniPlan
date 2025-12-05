// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseDto {

 int get id; int get openingYear; String get semester; int? get targetGrade; String get courseCode; String? get section; String get courseName; String? get professor; int get credits; String? get classroom; String get campus; String? get departmentCode; String? get departmentName; String? get collegeCode; String? get collegeName; List<ClassTimeDto> get classTimes;
/// Create a copy of CourseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDtoCopyWith<CourseDto> get copyWith => _$CourseDtoCopyWithImpl<CourseDto>(this as CourseDto, _$identity);

  /// Serializes this CourseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDto&&(identical(other.id, id) || other.id == id)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.targetGrade, targetGrade) || other.targetGrade == targetGrade)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.departmentCode, departmentCode) || other.departmentCode == departmentCode)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.collegeCode, collegeCode) || other.collegeCode == collegeCode)&&(identical(other.collegeName, collegeName) || other.collegeName == collegeName)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openingYear,semester,targetGrade,courseCode,section,courseName,professor,credits,classroom,campus,departmentCode,departmentName,collegeCode,collegeName,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'CourseDto(id: $id, openingYear: $openingYear, semester: $semester, targetGrade: $targetGrade, courseCode: $courseCode, section: $section, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, departmentCode: $departmentCode, departmentName: $departmentName, collegeCode: $collegeCode, collegeName: $collegeName, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $CourseDtoCopyWith<$Res>  {
  factory $CourseDtoCopyWith(CourseDto value, $Res Function(CourseDto) _then) = _$CourseDtoCopyWithImpl;
@useResult
$Res call({
 int id, int openingYear, String semester, int? targetGrade, String courseCode, String? section, String courseName, String? professor, int credits, String? classroom, String campus, String? departmentCode, String? departmentName, String? collegeCode, String? collegeName, List<ClassTimeDto> classTimes
});




}
/// @nodoc
class _$CourseDtoCopyWithImpl<$Res>
    implements $CourseDtoCopyWith<$Res> {
  _$CourseDtoCopyWithImpl(this._self, this._then);

  final CourseDto _self;
  final $Res Function(CourseDto) _then;

/// Create a copy of CourseDto
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
as List<ClassTimeDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDto].
extension CourseDtoPatterns on CourseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDto value)  $default,){
final _that = this;
switch (_that) {
case _CourseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDto value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTimeDto> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTimeDto> classTimes)  $default,) {final _that = this;
switch (_that) {
case _CourseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int openingYear,  String semester,  int? targetGrade,  String courseCode,  String? section,  String courseName,  String? professor,  int credits,  String? classroom,  String campus,  String? departmentCode,  String? departmentName,  String? collegeCode,  String? collegeName,  List<ClassTimeDto> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _CourseDto() when $default != null:
return $default(_that.id,_that.openingYear,_that.semester,_that.targetGrade,_that.courseCode,_that.section,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.departmentCode,_that.departmentName,_that.collegeCode,_that.collegeName,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseDto implements CourseDto {
  const _CourseDto({required this.id, required this.openingYear, required this.semester, this.targetGrade, required this.courseCode, this.section, required this.courseName, this.professor, required this.credits, this.classroom, required this.campus, this.departmentCode, this.departmentName, this.collegeCode, this.collegeName, final  List<ClassTimeDto> classTimes = const []}): _classTimes = classTimes;
  factory _CourseDto.fromJson(Map<String, dynamic> json) => _$CourseDtoFromJson(json);

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
 final  List<ClassTimeDto> _classTimes;
@override@JsonKey() List<ClassTimeDto> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


/// Create a copy of CourseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDtoCopyWith<_CourseDto> get copyWith => __$CourseDtoCopyWithImpl<_CourseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDto&&(identical(other.id, id) || other.id == id)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.targetGrade, targetGrade) || other.targetGrade == targetGrade)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.departmentCode, departmentCode) || other.departmentCode == departmentCode)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.collegeCode, collegeCode) || other.collegeCode == collegeCode)&&(identical(other.collegeName, collegeName) || other.collegeName == collegeName)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openingYear,semester,targetGrade,courseCode,section,courseName,professor,credits,classroom,campus,departmentCode,departmentName,collegeCode,collegeName,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'CourseDto(id: $id, openingYear: $openingYear, semester: $semester, targetGrade: $targetGrade, courseCode: $courseCode, section: $section, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, departmentCode: $departmentCode, departmentName: $departmentName, collegeCode: $collegeCode, collegeName: $collegeName, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$CourseDtoCopyWith<$Res> implements $CourseDtoCopyWith<$Res> {
  factory _$CourseDtoCopyWith(_CourseDto value, $Res Function(_CourseDto) _then) = __$CourseDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int openingYear, String semester, int? targetGrade, String courseCode, String? section, String courseName, String? professor, int credits, String? classroom, String campus, String? departmentCode, String? departmentName, String? collegeCode, String? collegeName, List<ClassTimeDto> classTimes
});




}
/// @nodoc
class __$CourseDtoCopyWithImpl<$Res>
    implements _$CourseDtoCopyWith<$Res> {
  __$CourseDtoCopyWithImpl(this._self, this._then);

  final _CourseDto _self;
  final $Res Function(_CourseDto) _then;

/// Create a copy of CourseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? openingYear = null,Object? semester = null,Object? targetGrade = freezed,Object? courseCode = null,Object? section = freezed,Object? courseName = null,Object? professor = freezed,Object? credits = null,Object? classroom = freezed,Object? campus = null,Object? departmentCode = freezed,Object? departmentName = freezed,Object? collegeCode = freezed,Object? collegeName = freezed,Object? classTimes = null,}) {
  return _then(_CourseDto(
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
as List<ClassTimeDto>,
  ));
}


}


/// @nodoc
mixin _$ClassTimeDto {

 String get day; String get startTime; String get endTime;
/// Create a copy of ClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassTimeDtoCopyWith<ClassTimeDto> get copyWith => _$ClassTimeDtoCopyWithImpl<ClassTimeDto>(this as ClassTimeDto, _$identity);

  /// Serializes this ClassTimeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassTimeDto&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTimeDto(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $ClassTimeDtoCopyWith<$Res>  {
  factory $ClassTimeDtoCopyWith(ClassTimeDto value, $Res Function(ClassTimeDto) _then) = _$ClassTimeDtoCopyWithImpl;
@useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class _$ClassTimeDtoCopyWithImpl<$Res>
    implements $ClassTimeDtoCopyWith<$Res> {
  _$ClassTimeDtoCopyWithImpl(this._self, this._then);

  final ClassTimeDto _self;
  final $Res Function(ClassTimeDto) _then;

/// Create a copy of ClassTimeDto
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


/// Adds pattern-matching-related methods to [ClassTimeDto].
extension ClassTimeDtoPatterns on ClassTimeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassTimeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassTimeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassTimeDto value)  $default,){
final _that = this;
switch (_that) {
case _ClassTimeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassTimeDto value)?  $default,){
final _that = this;
switch (_that) {
case _ClassTimeDto() when $default != null:
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
case _ClassTimeDto() when $default != null:
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
case _ClassTimeDto():
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
case _ClassTimeDto() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassTimeDto implements ClassTimeDto {
  const _ClassTimeDto({required this.day, required this.startTime, required this.endTime});
  factory _ClassTimeDto.fromJson(Map<String, dynamic> json) => _$ClassTimeDtoFromJson(json);

@override final  String day;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of ClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassTimeDtoCopyWith<_ClassTimeDto> get copyWith => __$ClassTimeDtoCopyWithImpl<_ClassTimeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassTimeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassTimeDto&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTimeDto(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ClassTimeDtoCopyWith<$Res> implements $ClassTimeDtoCopyWith<$Res> {
  factory _$ClassTimeDtoCopyWith(_ClassTimeDto value, $Res Function(_ClassTimeDto) _then) = __$ClassTimeDtoCopyWithImpl;
@override @useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class __$ClassTimeDtoCopyWithImpl<$Res>
    implements _$ClassTimeDtoCopyWith<$Res> {
  __$ClassTimeDtoCopyWithImpl(this._self, this._then);

  final _ClassTimeDto _self;
  final $Res Function(_ClassTimeDto) _then;

/// Create a copy of ClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_ClassTimeDto(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
