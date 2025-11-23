// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishlistItemDto {

 int get id; int get courseId; String get courseName; String get professor; int get priority; String? get classroom; List<WishlistClassTimeDto> get classTimes;
/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistItemDtoCopyWith<WishlistItemDto> get copyWith => _$WishlistItemDtoCopyWithImpl<WishlistItemDto>(this as WishlistItemDto, _$identity);

  /// Serializes this WishlistItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,priority,classroom,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'WishlistItemDto(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, priority: $priority, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $WishlistItemDtoCopyWith<$Res>  {
  factory $WishlistItemDtoCopyWith(WishlistItemDto value, $Res Function(WishlistItemDto) _then) = _$WishlistItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String courseName, String professor, int priority, String? classroom, List<WishlistClassTimeDto> classTimes
});




}
/// @nodoc
class _$WishlistItemDtoCopyWithImpl<$Res>
    implements $WishlistItemDtoCopyWith<$Res> {
  _$WishlistItemDtoCopyWithImpl(this._self, this._then);

  final WishlistItemDto _self;
  final $Res Function(WishlistItemDto) _then;

/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? priority = null,Object? classroom = freezed,Object? classTimes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self.classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<WishlistClassTimeDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistItemDto].
extension WishlistItemDtoPatterns on WishlistItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistItemDto value)  $default,){
final _that = this;
switch (_that) {
case _WishlistItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<WishlistClassTimeDto> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.priority,_that.classroom,_that.classTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<WishlistClassTimeDto> classTimes)  $default,) {final _that = this;
switch (_that) {
case _WishlistItemDto():
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.priority,_that.classroom,_that.classTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<WishlistClassTimeDto> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.priority,_that.classroom,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishlistItemDto implements WishlistItemDto {
  const _WishlistItemDto({required this.id, required this.courseId, required this.courseName, required this.professor, required this.priority, this.classroom, final  List<WishlistClassTimeDto> classTimes = const []}): _classTimes = classTimes;
  factory _WishlistItemDto.fromJson(Map<String, dynamic> json) => _$WishlistItemDtoFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String courseName;
@override final  String professor;
@override final  int priority;
@override final  String? classroom;
 final  List<WishlistClassTimeDto> _classTimes;
@override@JsonKey() List<WishlistClassTimeDto> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistItemDtoCopyWith<_WishlistItemDto> get copyWith => __$WishlistItemDtoCopyWithImpl<_WishlistItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishlistItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,priority,classroom,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'WishlistItemDto(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, priority: $priority, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$WishlistItemDtoCopyWith<$Res> implements $WishlistItemDtoCopyWith<$Res> {
  factory _$WishlistItemDtoCopyWith(_WishlistItemDto value, $Res Function(_WishlistItemDto) _then) = __$WishlistItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String courseName, String professor, int priority, String? classroom, List<WishlistClassTimeDto> classTimes
});




}
/// @nodoc
class __$WishlistItemDtoCopyWithImpl<$Res>
    implements _$WishlistItemDtoCopyWith<$Res> {
  __$WishlistItemDtoCopyWithImpl(this._self, this._then);

  final _WishlistItemDto _self;
  final $Res Function(_WishlistItemDto) _then;

/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? priority = null,Object? classroom = freezed,Object? classTimes = null,}) {
  return _then(_WishlistItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self._classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<WishlistClassTimeDto>,
  ));
}


}


/// @nodoc
mixin _$WishlistClassTimeDto {

 String get day; String get startTime; String get endTime;
/// Create a copy of WishlistClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistClassTimeDtoCopyWith<WishlistClassTimeDto> get copyWith => _$WishlistClassTimeDtoCopyWithImpl<WishlistClassTimeDto>(this as WishlistClassTimeDto, _$identity);

  /// Serializes this WishlistClassTimeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistClassTimeDto&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'WishlistClassTimeDto(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $WishlistClassTimeDtoCopyWith<$Res>  {
  factory $WishlistClassTimeDtoCopyWith(WishlistClassTimeDto value, $Res Function(WishlistClassTimeDto) _then) = _$WishlistClassTimeDtoCopyWithImpl;
@useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class _$WishlistClassTimeDtoCopyWithImpl<$Res>
    implements $WishlistClassTimeDtoCopyWith<$Res> {
  _$WishlistClassTimeDtoCopyWithImpl(this._self, this._then);

  final WishlistClassTimeDto _self;
  final $Res Function(WishlistClassTimeDto) _then;

/// Create a copy of WishlistClassTimeDto
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


/// Adds pattern-matching-related methods to [WishlistClassTimeDto].
extension WishlistClassTimeDtoPatterns on WishlistClassTimeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistClassTimeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistClassTimeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistClassTimeDto value)  $default,){
final _that = this;
switch (_that) {
case _WishlistClassTimeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistClassTimeDto value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistClassTimeDto() when $default != null:
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
case _WishlistClassTimeDto() when $default != null:
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
case _WishlistClassTimeDto():
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
case _WishlistClassTimeDto() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishlistClassTimeDto implements WishlistClassTimeDto {
  const _WishlistClassTimeDto({required this.day, required this.startTime, required this.endTime});
  factory _WishlistClassTimeDto.fromJson(Map<String, dynamic> json) => _$WishlistClassTimeDtoFromJson(json);

@override final  String day;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of WishlistClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistClassTimeDtoCopyWith<_WishlistClassTimeDto> get copyWith => __$WishlistClassTimeDtoCopyWithImpl<_WishlistClassTimeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishlistClassTimeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistClassTimeDto&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'WishlistClassTimeDto(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$WishlistClassTimeDtoCopyWith<$Res> implements $WishlistClassTimeDtoCopyWith<$Res> {
  factory _$WishlistClassTimeDtoCopyWith(_WishlistClassTimeDto value, $Res Function(_WishlistClassTimeDto) _then) = __$WishlistClassTimeDtoCopyWithImpl;
@override @useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class __$WishlistClassTimeDtoCopyWithImpl<$Res>
    implements _$WishlistClassTimeDtoCopyWith<$Res> {
  __$WishlistClassTimeDtoCopyWithImpl(this._self, this._then);

  final _WishlistClassTimeDto _self;
  final $Res Function(_WishlistClassTimeDto) _then;

/// Create a copy of WishlistClassTimeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_WishlistClassTimeDto(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
