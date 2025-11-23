// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishlistItem {

 int get id; int get courseId; String get courseName; String get professor; int get priority; String? get classroom; List<ClassTime> get classTimes;
/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistItemCopyWith<WishlistItem> get copyWith => _$WishlistItemCopyWithImpl<WishlistItem>(this as WishlistItem, _$identity);

  /// Serializes this WishlistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,priority,classroom,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'WishlistItem(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, priority: $priority, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $WishlistItemCopyWith<$Res>  {
  factory $WishlistItemCopyWith(WishlistItem value, $Res Function(WishlistItem) _then) = _$WishlistItemCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String courseName, String professor, int priority, String? classroom, List<ClassTime> classTimes
});




}
/// @nodoc
class _$WishlistItemCopyWithImpl<$Res>
    implements $WishlistItemCopyWith<$Res> {
  _$WishlistItemCopyWithImpl(this._self, this._then);

  final WishlistItem _self;
  final $Res Function(WishlistItem) _then;

/// Create a copy of WishlistItem
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
as List<ClassTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistItem].
extension WishlistItemPatterns on WishlistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistItem value)  $default,){
final _that = this;
switch (_that) {
case _WishlistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistItem value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<ClassTime> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<ClassTime> classTimes)  $default,) {final _that = this;
switch (_that) {
case _WishlistItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String courseName,  String professor,  int priority,  String? classroom,  List<ClassTime> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.priority,_that.classroom,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishlistItem implements WishlistItem {
  const _WishlistItem({required this.id, required this.courseId, required this.courseName, required this.professor, required this.priority, this.classroom, final  List<ClassTime> classTimes = const []}): _classTimes = classTimes;
  factory _WishlistItem.fromJson(Map<String, dynamic> json) => _$WishlistItemFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String courseName;
@override final  String professor;
@override final  int priority;
@override final  String? classroom;
 final  List<ClassTime> _classTimes;
@override@JsonKey() List<ClassTime> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistItemCopyWith<_WishlistItem> get copyWith => __$WishlistItemCopyWithImpl<_WishlistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishlistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,priority,classroom,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'WishlistItem(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, priority: $priority, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$WishlistItemCopyWith<$Res> implements $WishlistItemCopyWith<$Res> {
  factory _$WishlistItemCopyWith(_WishlistItem value, $Res Function(_WishlistItem) _then) = __$WishlistItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String courseName, String professor, int priority, String? classroom, List<ClassTime> classTimes
});




}
/// @nodoc
class __$WishlistItemCopyWithImpl<$Res>
    implements _$WishlistItemCopyWith<$Res> {
  __$WishlistItemCopyWithImpl(this._self, this._then);

  final _WishlistItem _self;
  final $Res Function(_WishlistItem) _then;

/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? priority = null,Object? classroom = freezed,Object? classTimes = null,}) {
  return _then(_WishlistItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
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
