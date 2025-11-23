// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageEnvelope<T> {

 List<T> get content; int get totalElements; int get totalPages; int get size; int get number;
/// Create a copy of PageEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageEnvelopeCopyWith<T, PageEnvelope<T>> get copyWith => _$PageEnvelopeCopyWithImpl<T, PageEnvelope<T>>(this as PageEnvelope<T>, _$identity);

  /// Serializes this PageEnvelope to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageEnvelope<T>&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.size, size) || other.size == size)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),totalElements,totalPages,size,number);

@override
String toString() {
  return 'PageEnvelope<$T>(content: $content, totalElements: $totalElements, totalPages: $totalPages, size: $size, number: $number)';
}


}

/// @nodoc
abstract mixin class $PageEnvelopeCopyWith<T,$Res>  {
  factory $PageEnvelopeCopyWith(PageEnvelope<T> value, $Res Function(PageEnvelope<T>) _then) = _$PageEnvelopeCopyWithImpl;
@useResult
$Res call({
 List<T> content, int totalElements, int totalPages, int size, int number
});




}
/// @nodoc
class _$PageEnvelopeCopyWithImpl<T,$Res>
    implements $PageEnvelopeCopyWith<T, $Res> {
  _$PageEnvelopeCopyWithImpl(this._self, this._then);

  final PageEnvelope<T> _self;
  final $Res Function(PageEnvelope<T>) _then;

/// Create a copy of PageEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? totalElements = null,Object? totalPages = null,Object? size = null,Object? number = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<T>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PageEnvelope].
extension PageEnvelopePatterns<T> on PageEnvelope<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageEnvelope<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageEnvelope<T> value)  $default,){
final _that = this;
switch (_that) {
case _PageEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageEnvelope<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PageEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> content,  int totalElements,  int totalPages,  int size,  int number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageEnvelope() when $default != null:
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> content,  int totalElements,  int totalPages,  int size,  int number)  $default,) {final _that = this;
switch (_that) {
case _PageEnvelope():
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> content,  int totalElements,  int totalPages,  int size,  int number)?  $default,) {final _that = this;
switch (_that) {
case _PageEnvelope() when $default != null:
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PageEnvelope<T> implements PageEnvelope<T> {
  const _PageEnvelope({required final  List<T> content, required this.totalElements, required this.totalPages, required this.size, required this.number}): _content = content;
  factory _PageEnvelope.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PageEnvelopeFromJson(json,fromJsonT);

 final  List<T> _content;
@override List<T> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override final  int totalElements;
@override final  int totalPages;
@override final  int size;
@override final  int number;

/// Create a copy of PageEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageEnvelopeCopyWith<T, _PageEnvelope<T>> get copyWith => __$PageEnvelopeCopyWithImpl<T, _PageEnvelope<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PageEnvelopeToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageEnvelope<T>&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.size, size) || other.size == size)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),totalElements,totalPages,size,number);

@override
String toString() {
  return 'PageEnvelope<$T>(content: $content, totalElements: $totalElements, totalPages: $totalPages, size: $size, number: $number)';
}


}

/// @nodoc
abstract mixin class _$PageEnvelopeCopyWith<T,$Res> implements $PageEnvelopeCopyWith<T, $Res> {
  factory _$PageEnvelopeCopyWith(_PageEnvelope<T> value, $Res Function(_PageEnvelope<T>) _then) = __$PageEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 List<T> content, int totalElements, int totalPages, int size, int number
});




}
/// @nodoc
class __$PageEnvelopeCopyWithImpl<T,$Res>
    implements _$PageEnvelopeCopyWith<T, $Res> {
  __$PageEnvelopeCopyWithImpl(this._self, this._then);

  final _PageEnvelope<T> _self;
  final $Res Function(_PageEnvelope<T>) _then;

/// Create a copy of PageEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? totalElements = null,Object? totalPages = null,Object? size = null,Object? number = null,}) {
  return _then(_PageEnvelope<T>(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<T>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
