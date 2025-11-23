// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimetableDto {

 int get id; String get name; int get openingYear; String get semester; List<TimetableItemDto> get items;
/// Create a copy of TimetableDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableDtoCopyWith<TimetableDto> get copyWith => _$TimetableDtoCopyWithImpl<TimetableDto>(this as TimetableDto, _$identity);

  /// Serializes this TimetableDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,openingYear,semester,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TimetableDto(id: $id, name: $name, openingYear: $openingYear, semester: $semester, items: $items)';
}


}

/// @nodoc
abstract mixin class $TimetableDtoCopyWith<$Res>  {
  factory $TimetableDtoCopyWith(TimetableDto value, $Res Function(TimetableDto) _then) = _$TimetableDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, int openingYear, String semester, List<TimetableItemDto> items
});




}
/// @nodoc
class _$TimetableDtoCopyWithImpl<$Res>
    implements $TimetableDtoCopyWith<$Res> {
  _$TimetableDtoCopyWithImpl(this._self, this._then);

  final TimetableDto _self;
  final $Res Function(TimetableDto) _then;

/// Create a copy of TimetableDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableDto].
extension TimetableDtoPatterns on TimetableDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableDto value)  $default,){
final _that = this;
switch (_that) {
case _TimetableDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int openingYear,  String semester,  List<TimetableItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableDto() when $default != null:
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int openingYear,  String semester,  List<TimetableItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _TimetableDto():
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int openingYear,  String semester,  List<TimetableItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _TimetableDto() when $default != null:
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableDto implements TimetableDto {
  const _TimetableDto({required this.id, required this.name, required this.openingYear, required this.semester, final  List<TimetableItemDto> items = const []}): _items = items;
  factory _TimetableDto.fromJson(Map<String, dynamic> json) => _$TimetableDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  int openingYear;
@override final  String semester;
 final  List<TimetableItemDto> _items;
@override@JsonKey() List<TimetableItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TimetableDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableDtoCopyWith<_TimetableDto> get copyWith => __$TimetableDtoCopyWithImpl<_TimetableDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,openingYear,semester,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TimetableDto(id: $id, name: $name, openingYear: $openingYear, semester: $semester, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TimetableDtoCopyWith<$Res> implements $TimetableDtoCopyWith<$Res> {
  factory _$TimetableDtoCopyWith(_TimetableDto value, $Res Function(_TimetableDto) _then) = __$TimetableDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int openingYear, String semester, List<TimetableItemDto> items
});




}
/// @nodoc
class __$TimetableDtoCopyWithImpl<$Res>
    implements _$TimetableDtoCopyWith<$Res> {
  __$TimetableDtoCopyWithImpl(this._self, this._then);

  final _TimetableDto _self;
  final $Res Function(_TimetableDto) _then;

/// Create a copy of TimetableDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? items = null,}) {
  return _then(_TimetableDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItemDto>,
  ));
}


}


/// @nodoc
mixin _$TimetableItemDto {

 int get id; int get courseId; String get courseName; String get professor; List<ClassTimeDto> get classTimes;
/// Create a copy of TimetableItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableItemDtoCopyWith<TimetableItemDto> get copyWith => _$TimetableItemDtoCopyWithImpl<TimetableItemDto>(this as TimetableItemDto, _$identity);

  /// Serializes this TimetableItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'TimetableItemDto(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $TimetableItemDtoCopyWith<$Res>  {
  factory $TimetableItemDtoCopyWith(TimetableItemDto value, $Res Function(TimetableItemDto) _then) = _$TimetableItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String courseName, String professor, List<ClassTimeDto> classTimes
});




}
/// @nodoc
class _$TimetableItemDtoCopyWithImpl<$Res>
    implements $TimetableItemDtoCopyWith<$Res> {
  _$TimetableItemDtoCopyWithImpl(this._self, this._then);

  final TimetableItemDto _self;
  final $Res Function(TimetableItemDto) _then;

/// Create a copy of TimetableItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? classTimes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,classTimes: null == classTimes ? _self.classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTimeDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableItemDto].
extension TimetableItemDtoPatterns on TimetableItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableItemDto value)  $default,){
final _that = this;
switch (_that) {
case _TimetableItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  List<ClassTimeDto> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableItemDto() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  List<ClassTimeDto> classTimes)  $default,) {final _that = this;
switch (_that) {
case _TimetableItemDto():
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String courseName,  String professor,  List<ClassTimeDto> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _TimetableItemDto() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableItemDto implements TimetableItemDto {
  const _TimetableItemDto({required this.id, required this.courseId, required this.courseName, required this.professor, final  List<ClassTimeDto> classTimes = const []}): _classTimes = classTimes;
  factory _TimetableItemDto.fromJson(Map<String, dynamic> json) => _$TimetableItemDtoFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String courseName;
@override final  String professor;
 final  List<ClassTimeDto> _classTimes;
@override@JsonKey() List<ClassTimeDto> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


/// Create a copy of TimetableItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableItemDtoCopyWith<_TimetableItemDto> get copyWith => __$TimetableItemDtoCopyWithImpl<_TimetableItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'TimetableItemDto(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$TimetableItemDtoCopyWith<$Res> implements $TimetableItemDtoCopyWith<$Res> {
  factory _$TimetableItemDtoCopyWith(_TimetableItemDto value, $Res Function(_TimetableItemDto) _then) = __$TimetableItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String courseName, String professor, List<ClassTimeDto> classTimes
});




}
/// @nodoc
class __$TimetableItemDtoCopyWithImpl<$Res>
    implements _$TimetableItemDtoCopyWith<$Res> {
  __$TimetableItemDtoCopyWithImpl(this._self, this._then);

  final _TimetableItemDto _self;
  final $Res Function(_TimetableItemDto) _then;

/// Create a copy of TimetableItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? classTimes = null,}) {
  return _then(_TimetableItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,classTimes: null == classTimes ? _self._classTimes : classTimes // ignore: cast_nullable_to_non_nullable
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
