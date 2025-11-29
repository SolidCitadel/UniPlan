// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Scenario {

 int get id; String get name; String? get description; int? get parentId; int get timetableId; Timetable get timetable; List<int> get failedCourseIds; List<Scenario> get children;
/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScenarioCopyWith<Scenario> get copyWith => _$ScenarioCopyWithImpl<Scenario>(this as Scenario, _$identity);

  /// Serializes this Scenario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Scenario&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&(identical(other.timetable, timetable) || other.timetable == timetable)&&const DeepCollectionEquality().equals(other.failedCourseIds, failedCourseIds)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentId,timetableId,timetable,const DeepCollectionEquality().hash(failedCourseIds),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'Scenario(id: $id, name: $name, description: $description, parentId: $parentId, timetableId: $timetableId, timetable: $timetable, failedCourseIds: $failedCourseIds, children: $children)';
}


}

/// @nodoc
abstract mixin class $ScenarioCopyWith<$Res>  {
  factory $ScenarioCopyWith(Scenario value, $Res Function(Scenario) _then) = _$ScenarioCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, int? parentId, int timetableId, Timetable timetable, List<int> failedCourseIds, List<Scenario> children
});


$TimetableCopyWith<$Res> get timetable;

}
/// @nodoc
class _$ScenarioCopyWithImpl<$Res>
    implements $ScenarioCopyWith<$Res> {
  _$ScenarioCopyWithImpl(this._self, this._then);

  final Scenario _self;
  final $Res Function(Scenario) _then;

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentId = freezed,Object? timetableId = null,Object? timetable = null,Object? failedCourseIds = null,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as int,timetable: null == timetable ? _self.timetable : timetable // ignore: cast_nullable_to_non_nullable
as Timetable,failedCourseIds: null == failedCourseIds ? _self.failedCourseIds : failedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<Scenario>,
  ));
}
/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableCopyWith<$Res> get timetable {
  
  return $TimetableCopyWith<$Res>(_self.timetable, (value) {
    return _then(_self.copyWith(timetable: value));
  });
}
}


/// Adds pattern-matching-related methods to [Scenario].
extension ScenarioPatterns on Scenario {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Scenario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Scenario() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Scenario value)  $default,){
final _that = this;
switch (_that) {
case _Scenario():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Scenario value)?  $default,){
final _that = this;
switch (_that) {
case _Scenario() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  Timetable timetable,  List<int> failedCourseIds,  List<Scenario> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Scenario() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.timetable,_that.failedCourseIds,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  Timetable timetable,  List<int> failedCourseIds,  List<Scenario> children)  $default,) {final _that = this;
switch (_that) {
case _Scenario():
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.timetable,_that.failedCourseIds,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  Timetable timetable,  List<int> failedCourseIds,  List<Scenario> children)?  $default,) {final _that = this;
switch (_that) {
case _Scenario() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.timetable,_that.failedCourseIds,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Scenario implements Scenario {
  const _Scenario({required this.id, required this.name, this.description, this.parentId, required this.timetableId, required this.timetable, final  List<int> failedCourseIds = const [], final  List<Scenario> children = const []}): _failedCourseIds = failedCourseIds,_children = children;
  factory _Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  int? parentId;
@override final  int timetableId;
@override final  Timetable timetable;
 final  List<int> _failedCourseIds;
@override@JsonKey() List<int> get failedCourseIds {
  if (_failedCourseIds is EqualUnmodifiableListView) return _failedCourseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedCourseIds);
}

 final  List<Scenario> _children;
@override@JsonKey() List<Scenario> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScenarioCopyWith<_Scenario> get copyWith => __$ScenarioCopyWithImpl<_Scenario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScenarioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scenario&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&(identical(other.timetable, timetable) || other.timetable == timetable)&&const DeepCollectionEquality().equals(other._failedCourseIds, _failedCourseIds)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentId,timetableId,timetable,const DeepCollectionEquality().hash(_failedCourseIds),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'Scenario(id: $id, name: $name, description: $description, parentId: $parentId, timetableId: $timetableId, timetable: $timetable, failedCourseIds: $failedCourseIds, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ScenarioCopyWith<$Res> implements $ScenarioCopyWith<$Res> {
  factory _$ScenarioCopyWith(_Scenario value, $Res Function(_Scenario) _then) = __$ScenarioCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, int? parentId, int timetableId, Timetable timetable, List<int> failedCourseIds, List<Scenario> children
});


@override $TimetableCopyWith<$Res> get timetable;

}
/// @nodoc
class __$ScenarioCopyWithImpl<$Res>
    implements _$ScenarioCopyWith<$Res> {
  __$ScenarioCopyWithImpl(this._self, this._then);

  final _Scenario _self;
  final $Res Function(_Scenario) _then;

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentId = freezed,Object? timetableId = null,Object? timetable = null,Object? failedCourseIds = null,Object? children = null,}) {
  return _then(_Scenario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as int,timetable: null == timetable ? _self.timetable : timetable // ignore: cast_nullable_to_non_nullable
as Timetable,failedCourseIds: null == failedCourseIds ? _self._failedCourseIds : failedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<Scenario>,
  ));
}

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableCopyWith<$Res> get timetable {
  
  return $TimetableCopyWith<$Res>(_self.timetable, (value) {
    return _then(_self.copyWith(timetable: value));
  });
}
}

// dart format on
