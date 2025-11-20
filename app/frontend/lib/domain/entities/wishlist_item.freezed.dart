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

 String get id; Course get course; int get priority; bool get isSelected;
/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistItemCopyWith<WishlistItem> get copyWith => _$WishlistItemCopyWithImpl<WishlistItem>(this as WishlistItem, _$identity);

  /// Serializes this WishlistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.course, course) || other.course == course)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,course,priority,isSelected);

@override
String toString() {
  return 'WishlistItem(id: $id, course: $course, priority: $priority, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $WishlistItemCopyWith<$Res>  {
  factory $WishlistItemCopyWith(WishlistItem value, $Res Function(WishlistItem) _then) = _$WishlistItemCopyWithImpl;
@useResult
$Res call({
 String id, Course course, int priority, bool isSelected
});


$CourseCopyWith<$Res> get course;

}
/// @nodoc
class _$WishlistItemCopyWithImpl<$Res>
    implements $WishlistItemCopyWith<$Res> {
  _$WishlistItemCopyWithImpl(this._self, this._then);

  final WishlistItem _self;
  final $Res Function(WishlistItem) _then;

/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? course = null,Object? priority = null,Object? isSelected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as Course,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCopyWith<$Res> get course {
  
  return $CourseCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Course course,  int priority,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
return $default(_that.id,_that.course,_that.priority,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Course course,  int priority,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _WishlistItem():
return $default(_that.id,_that.course,_that.priority,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Course course,  int priority,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _WishlistItem() when $default != null:
return $default(_that.id,_that.course,_that.priority,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishlistItem implements WishlistItem {
  const _WishlistItem({required this.id, required this.course, required this.priority, this.isSelected = false});
  factory _WishlistItem.fromJson(Map<String, dynamic> json) => _$WishlistItemFromJson(json);

@override final  String id;
@override final  Course course;
@override final  int priority;
@override@JsonKey() final  bool isSelected;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.course, course) || other.course == course)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,course,priority,isSelected);

@override
String toString() {
  return 'WishlistItem(id: $id, course: $course, priority: $priority, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$WishlistItemCopyWith<$Res> implements $WishlistItemCopyWith<$Res> {
  factory _$WishlistItemCopyWith(_WishlistItem value, $Res Function(_WishlistItem) _then) = __$WishlistItemCopyWithImpl;
@override @useResult
$Res call({
 String id, Course course, int priority, bool isSelected
});


@override $CourseCopyWith<$Res> get course;

}
/// @nodoc
class __$WishlistItemCopyWithImpl<$Res>
    implements _$WishlistItemCopyWith<$Res> {
  __$WishlistItemCopyWithImpl(this._self, this._then);

  final _WishlistItem _self;
  final $Res Function(_WishlistItem) _then;

/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? course = null,Object? priority = null,Object? isSelected = null,}) {
  return _then(_WishlistItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as Course,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WishlistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCopyWith<$Res> get course {
  
  return $CourseCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}

// dart format on
