// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScenarioDto {

 int get id; String get name; String? get description; int? get parentId; int get timetableId; List<ScenarioDto> get children;
/// Create a copy of ScenarioDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScenarioDtoCopyWith<ScenarioDto> get copyWith => _$ScenarioDtoCopyWithImpl<ScenarioDto>(this as ScenarioDto, _$identity);

  /// Serializes this ScenarioDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScenarioDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentId,timetableId,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'ScenarioDto(id: $id, name: $name, description: $description, parentId: $parentId, timetableId: $timetableId, children: $children)';
}


}

/// @nodoc
abstract mixin class $ScenarioDtoCopyWith<$Res>  {
  factory $ScenarioDtoCopyWith(ScenarioDto value, $Res Function(ScenarioDto) _then) = _$ScenarioDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, int? parentId, int timetableId, List<ScenarioDto> children
});




}
/// @nodoc
class _$ScenarioDtoCopyWithImpl<$Res>
    implements $ScenarioDtoCopyWith<$Res> {
  _$ScenarioDtoCopyWithImpl(this._self, this._then);

  final ScenarioDto _self;
  final $Res Function(ScenarioDto) _then;

/// Create a copy of ScenarioDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentId = freezed,Object? timetableId = null,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ScenarioDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScenarioDto].
extension ScenarioDtoPatterns on ScenarioDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScenarioDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScenarioDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScenarioDto value)  $default,){
final _that = this;
switch (_that) {
case _ScenarioDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScenarioDto value)?  $default,){
final _that = this;
switch (_that) {
case _ScenarioDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  List<ScenarioDto> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScenarioDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  List<ScenarioDto> children)  $default,) {final _that = this;
switch (_that) {
case _ScenarioDto():
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  int? parentId,  int timetableId,  List<ScenarioDto> children)?  $default,) {final _that = this;
switch (_that) {
case _ScenarioDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentId,_that.timetableId,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScenarioDto implements ScenarioDto {
  const _ScenarioDto({required this.id, required this.name, this.description, this.parentId, required this.timetableId, final  List<ScenarioDto> children = const []}): _children = children;
  factory _ScenarioDto.fromJson(Map<String, dynamic> json) => _$ScenarioDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  int? parentId;
@override final  int timetableId;
 final  List<ScenarioDto> _children;
@override@JsonKey() List<ScenarioDto> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of ScenarioDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScenarioDtoCopyWith<_ScenarioDto> get copyWith => __$ScenarioDtoCopyWithImpl<_ScenarioDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScenarioDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScenarioDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentId,timetableId,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'ScenarioDto(id: $id, name: $name, description: $description, parentId: $parentId, timetableId: $timetableId, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ScenarioDtoCopyWith<$Res> implements $ScenarioDtoCopyWith<$Res> {
  factory _$ScenarioDtoCopyWith(_ScenarioDto value, $Res Function(_ScenarioDto) _then) = __$ScenarioDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, int? parentId, int timetableId, List<ScenarioDto> children
});




}
/// @nodoc
class __$ScenarioDtoCopyWithImpl<$Res>
    implements _$ScenarioDtoCopyWith<$Res> {
  __$ScenarioDtoCopyWithImpl(this._self, this._then);

  final _ScenarioDto _self;
  final $Res Function(_ScenarioDto) _then;

/// Create a copy of ScenarioDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentId = freezed,Object? timetableId = null,Object? children = null,}) {
  return _then(_ScenarioDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ScenarioDto>,
  ));
}


}

// dart format on
