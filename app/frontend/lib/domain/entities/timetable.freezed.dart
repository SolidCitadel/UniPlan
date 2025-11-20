// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timetable {

 String get id; String get name; List<Course> get courses; String? get parentId;// For decision tree structure
 List<String> get childIds;
/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableCopyWith<Timetable> get copyWith => _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.courses, courses)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other.childIds, childIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(courses),parentId,const DeepCollectionEquality().hash(childIds));

@override
String toString() {
  return 'Timetable(id: $id, name: $name, courses: $courses, parentId: $parentId, childIds: $childIds)';
}


}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res>  {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) = _$TimetableCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<Course> courses, String? parentId, List<String> childIds
});




}
/// @nodoc
class _$TimetableCopyWithImpl<$Res>
    implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._self, this._then);

  final Timetable _self;
  final $Res Function(Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? courses = null,Object? parentId = freezed,Object? childIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as List<Course>,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Timetable].
extension TimetablePatterns on Timetable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Timetable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Timetable value)  $default,){
final _that = this;
switch (_that) {
case _Timetable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Timetable value)?  $default,){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<Course> courses,  String? parentId,  List<String> childIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.name,_that.courses,_that.parentId,_that.childIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<Course> courses,  String? parentId,  List<String> childIds)  $default,) {final _that = this;
switch (_that) {
case _Timetable():
return $default(_that.id,_that.name,_that.courses,_that.parentId,_that.childIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<Course> courses,  String? parentId,  List<String> childIds)?  $default,) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.name,_that.courses,_that.parentId,_that.childIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Timetable implements Timetable {
  const _Timetable({required this.id, required this.name, required final  List<Course> courses, this.parentId, final  List<String> childIds = const []}): _courses = courses,_childIds = childIds;
  factory _Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);

@override final  String id;
@override final  String name;
 final  List<Course> _courses;
@override List<Course> get courses {
  if (_courses is EqualUnmodifiableListView) return _courses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courses);
}

@override final  String? parentId;
// For decision tree structure
 final  List<String> _childIds;
// For decision tree structure
@override@JsonKey() List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}


/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableCopyWith<_Timetable> get copyWith => __$TimetableCopyWithImpl<_Timetable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._courses, _courses)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other._childIds, _childIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_courses),parentId,const DeepCollectionEquality().hash(_childIds));

@override
String toString() {
  return 'Timetable(id: $id, name: $name, courses: $courses, parentId: $parentId, childIds: $childIds)';
}


}

/// @nodoc
abstract mixin class _$TimetableCopyWith<$Res> implements $TimetableCopyWith<$Res> {
  factory _$TimetableCopyWith(_Timetable value, $Res Function(_Timetable) _then) = __$TimetableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<Course> courses, String? parentId, List<String> childIds
});




}
/// @nodoc
class __$TimetableCopyWithImpl<$Res>
    implements _$TimetableCopyWith<$Res> {
  __$TimetableCopyWithImpl(this._self, this._then);

  final _Timetable _self;
  final $Res Function(_Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? courses = null,Object? parentId = freezed,Object? childIds = null,}) {
  return _then(_Timetable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courses: null == courses ? _self._courses : courses // ignore: cast_nullable_to_non_nullable
as List<Course>,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
