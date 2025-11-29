// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegistrationDto {

 int get id; int get userId; ScenarioDto get startScenario; ScenarioDto get currentScenario; RegistrationStatusDto get status; List<int> get succeededCourses; List<int> get failedCourses; List<int> get canceledCourses; List<RegistrationStepDto> get steps;
/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationDtoCopyWith<RegistrationDto> get copyWith => _$RegistrationDtoCopyWithImpl<RegistrationDto>(this as RegistrationDto, _$identity);

  /// Serializes this RegistrationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startScenario, startScenario) || other.startScenario == startScenario)&&(identical(other.currentScenario, currentScenario) || other.currentScenario == currentScenario)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.succeededCourses, succeededCourses)&&const DeepCollectionEquality().equals(other.failedCourses, failedCourses)&&const DeepCollectionEquality().equals(other.canceledCourses, canceledCourses)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startScenario,currentScenario,status,const DeepCollectionEquality().hash(succeededCourses),const DeepCollectionEquality().hash(failedCourses),const DeepCollectionEquality().hash(canceledCourses),const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'RegistrationDto(id: $id, userId: $userId, startScenario: $startScenario, currentScenario: $currentScenario, status: $status, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $RegistrationDtoCopyWith<$Res>  {
  factory $RegistrationDtoCopyWith(RegistrationDto value, $Res Function(RegistrationDto) _then) = _$RegistrationDtoCopyWithImpl;
@useResult
$Res call({
 int id, int userId, ScenarioDto startScenario, ScenarioDto currentScenario, RegistrationStatusDto status, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, List<RegistrationStepDto> steps
});


$ScenarioDtoCopyWith<$Res> get startScenario;$ScenarioDtoCopyWith<$Res> get currentScenario;

}
/// @nodoc
class _$RegistrationDtoCopyWithImpl<$Res>
    implements $RegistrationDtoCopyWith<$Res> {
  _$RegistrationDtoCopyWithImpl(this._self, this._then);

  final RegistrationDto _self;
  final $Res Function(RegistrationDto) _then;

/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startScenario = null,Object? currentScenario = null,Object? status = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? steps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,startScenario: null == startScenario ? _self.startScenario : startScenario // ignore: cast_nullable_to_non_nullable
as ScenarioDto,currentScenario: null == currentScenario ? _self.currentScenario : currentScenario // ignore: cast_nullable_to_non_nullable
as ScenarioDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatusDto,succeededCourses: null == succeededCourses ? _self.succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self.failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self.canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RegistrationStepDto>,
  ));
}
/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioDtoCopyWith<$Res> get startScenario {
  
  return $ScenarioDtoCopyWith<$Res>(_self.startScenario, (value) {
    return _then(_self.copyWith(startScenario: value));
  });
}/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioDtoCopyWith<$Res> get currentScenario {
  
  return $ScenarioDtoCopyWith<$Res>(_self.currentScenario, (value) {
    return _then(_self.copyWith(currentScenario: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegistrationDto].
extension RegistrationDtoPatterns on RegistrationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationDto value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationDto value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  ScenarioDto startScenario,  ScenarioDto currentScenario,  RegistrationStatusDto status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStepDto> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationDto() when $default != null:
return $default(_that.id,_that.userId,_that.startScenario,_that.currentScenario,_that.status,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  ScenarioDto startScenario,  ScenarioDto currentScenario,  RegistrationStatusDto status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStepDto> steps)  $default,) {final _that = this;
switch (_that) {
case _RegistrationDto():
return $default(_that.id,_that.userId,_that.startScenario,_that.currentScenario,_that.status,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  ScenarioDto startScenario,  ScenarioDto currentScenario,  RegistrationStatusDto status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStepDto> steps)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationDto() when $default != null:
return $default(_that.id,_that.userId,_that.startScenario,_that.currentScenario,_that.status,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationDto implements RegistrationDto {
  const _RegistrationDto({required this.id, required this.userId, required this.startScenario, required this.currentScenario, required this.status, final  List<int> succeededCourses = const [], final  List<int> failedCourses = const [], final  List<int> canceledCourses = const [], final  List<RegistrationStepDto> steps = const []}): _succeededCourses = succeededCourses,_failedCourses = failedCourses,_canceledCourses = canceledCourses,_steps = steps;
  factory _RegistrationDto.fromJson(Map<String, dynamic> json) => _$RegistrationDtoFromJson(json);

@override final  int id;
@override final  int userId;
@override final  ScenarioDto startScenario;
@override final  ScenarioDto currentScenario;
@override final  RegistrationStatusDto status;
 final  List<int> _succeededCourses;
@override@JsonKey() List<int> get succeededCourses {
  if (_succeededCourses is EqualUnmodifiableListView) return _succeededCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_succeededCourses);
}

 final  List<int> _failedCourses;
@override@JsonKey() List<int> get failedCourses {
  if (_failedCourses is EqualUnmodifiableListView) return _failedCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedCourses);
}

 final  List<int> _canceledCourses;
@override@JsonKey() List<int> get canceledCourses {
  if (_canceledCourses is EqualUnmodifiableListView) return _canceledCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canceledCourses);
}

 final  List<RegistrationStepDto> _steps;
@override@JsonKey() List<RegistrationStepDto> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationDtoCopyWith<_RegistrationDto> get copyWith => __$RegistrationDtoCopyWithImpl<_RegistrationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startScenario, startScenario) || other.startScenario == startScenario)&&(identical(other.currentScenario, currentScenario) || other.currentScenario == currentScenario)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._succeededCourses, _succeededCourses)&&const DeepCollectionEquality().equals(other._failedCourses, _failedCourses)&&const DeepCollectionEquality().equals(other._canceledCourses, _canceledCourses)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startScenario,currentScenario,status,const DeepCollectionEquality().hash(_succeededCourses),const DeepCollectionEquality().hash(_failedCourses),const DeepCollectionEquality().hash(_canceledCourses),const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'RegistrationDto(id: $id, userId: $userId, startScenario: $startScenario, currentScenario: $currentScenario, status: $status, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$RegistrationDtoCopyWith<$Res> implements $RegistrationDtoCopyWith<$Res> {
  factory _$RegistrationDtoCopyWith(_RegistrationDto value, $Res Function(_RegistrationDto) _then) = __$RegistrationDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, ScenarioDto startScenario, ScenarioDto currentScenario, RegistrationStatusDto status, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, List<RegistrationStepDto> steps
});


@override $ScenarioDtoCopyWith<$Res> get startScenario;@override $ScenarioDtoCopyWith<$Res> get currentScenario;

}
/// @nodoc
class __$RegistrationDtoCopyWithImpl<$Res>
    implements _$RegistrationDtoCopyWith<$Res> {
  __$RegistrationDtoCopyWithImpl(this._self, this._then);

  final _RegistrationDto _self;
  final $Res Function(_RegistrationDto) _then;

/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startScenario = null,Object? currentScenario = null,Object? status = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? steps = null,}) {
  return _then(_RegistrationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,startScenario: null == startScenario ? _self.startScenario : startScenario // ignore: cast_nullable_to_non_nullable
as ScenarioDto,currentScenario: null == currentScenario ? _self.currentScenario : currentScenario // ignore: cast_nullable_to_non_nullable
as ScenarioDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatusDto,succeededCourses: null == succeededCourses ? _self._succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self._failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self._canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RegistrationStepDto>,
  ));
}

/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioDtoCopyWith<$Res> get startScenario {
  
  return $ScenarioDtoCopyWith<$Res>(_self.startScenario, (value) {
    return _then(_self.copyWith(startScenario: value));
  });
}/// Create a copy of RegistrationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioDtoCopyWith<$Res> get currentScenario {
  
  return $ScenarioDtoCopyWith<$Res>(_self.currentScenario, (value) {
    return _then(_self.copyWith(currentScenario: value));
  });
}
}


/// @nodoc
mixin _$RegistrationStepDto {

 int get id; int get scenarioId; String get scenarioName; List<int> get succeededCourses; List<int> get failedCourses; List<int> get canceledCourses; int? get nextScenarioId; String? get nextScenarioName; String? get notes;
/// Create a copy of RegistrationStepDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationStepDtoCopyWith<RegistrationStepDto> get copyWith => _$RegistrationStepDtoCopyWithImpl<RegistrationStepDto>(this as RegistrationStepDto, _$identity);

  /// Serializes this RegistrationStepDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationStepDto&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&const DeepCollectionEquality().equals(other.succeededCourses, succeededCourses)&&const DeepCollectionEquality().equals(other.failedCourses, failedCourses)&&const DeepCollectionEquality().equals(other.canceledCourses, canceledCourses)&&(identical(other.nextScenarioId, nextScenarioId) || other.nextScenarioId == nextScenarioId)&&(identical(other.nextScenarioName, nextScenarioName) || other.nextScenarioName == nextScenarioName)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,const DeepCollectionEquality().hash(succeededCourses),const DeepCollectionEquality().hash(failedCourses),const DeepCollectionEquality().hash(canceledCourses),nextScenarioId,nextScenarioName,notes);

@override
String toString() {
  return 'RegistrationStepDto(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, nextScenarioId: $nextScenarioId, nextScenarioName: $nextScenarioName, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RegistrationStepDtoCopyWith<$Res>  {
  factory $RegistrationStepDtoCopyWith(RegistrationStepDto value, $Res Function(RegistrationStepDto) _then) = _$RegistrationStepDtoCopyWithImpl;
@useResult
$Res call({
 int id, int scenarioId, String scenarioName, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, int? nextScenarioId, String? nextScenarioName, String? notes
});




}
/// @nodoc
class _$RegistrationStepDtoCopyWithImpl<$Res>
    implements $RegistrationStepDtoCopyWith<$Res> {
  _$RegistrationStepDtoCopyWithImpl(this._self, this._then);

  final RegistrationStepDto _self;
  final $Res Function(RegistrationStepDto) _then;

/// Create a copy of RegistrationStepDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scenarioId = null,Object? scenarioName = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? nextScenarioId = freezed,Object? nextScenarioName = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,scenarioId: null == scenarioId ? _self.scenarioId : scenarioId // ignore: cast_nullable_to_non_nullable
as int,scenarioName: null == scenarioName ? _self.scenarioName : scenarioName // ignore: cast_nullable_to_non_nullable
as String,succeededCourses: null == succeededCourses ? _self.succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self.failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self.canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,nextScenarioId: freezed == nextScenarioId ? _self.nextScenarioId : nextScenarioId // ignore: cast_nullable_to_non_nullable
as int?,nextScenarioName: freezed == nextScenarioName ? _self.nextScenarioName : nextScenarioName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationStepDto].
extension RegistrationStepDtoPatterns on RegistrationStepDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationStepDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationStepDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationStepDto value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationStepDto value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int scenarioId,  String scenarioName,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  int? nextScenarioId,  String? nextScenarioName,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationStepDto() when $default != null:
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.nextScenarioId,_that.nextScenarioName,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int scenarioId,  String scenarioName,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  int? nextScenarioId,  String? nextScenarioName,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepDto():
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.nextScenarioId,_that.nextScenarioName,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int scenarioId,  String scenarioName,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  int? nextScenarioId,  String? nextScenarioName,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepDto() when $default != null:
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.nextScenarioId,_that.nextScenarioName,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationStepDto implements RegistrationStepDto {
  const _RegistrationStepDto({required this.id, required this.scenarioId, required this.scenarioName, final  List<int> succeededCourses = const [], final  List<int> failedCourses = const [], final  List<int> canceledCourses = const [], this.nextScenarioId, this.nextScenarioName, this.notes}): _succeededCourses = succeededCourses,_failedCourses = failedCourses,_canceledCourses = canceledCourses;
  factory _RegistrationStepDto.fromJson(Map<String, dynamic> json) => _$RegistrationStepDtoFromJson(json);

@override final  int id;
@override final  int scenarioId;
@override final  String scenarioName;
 final  List<int> _succeededCourses;
@override@JsonKey() List<int> get succeededCourses {
  if (_succeededCourses is EqualUnmodifiableListView) return _succeededCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_succeededCourses);
}

 final  List<int> _failedCourses;
@override@JsonKey() List<int> get failedCourses {
  if (_failedCourses is EqualUnmodifiableListView) return _failedCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedCourses);
}

 final  List<int> _canceledCourses;
@override@JsonKey() List<int> get canceledCourses {
  if (_canceledCourses is EqualUnmodifiableListView) return _canceledCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canceledCourses);
}

@override final  int? nextScenarioId;
@override final  String? nextScenarioName;
@override final  String? notes;

/// Create a copy of RegistrationStepDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationStepDtoCopyWith<_RegistrationStepDto> get copyWith => __$RegistrationStepDtoCopyWithImpl<_RegistrationStepDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationStepDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationStepDto&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&const DeepCollectionEquality().equals(other._succeededCourses, _succeededCourses)&&const DeepCollectionEquality().equals(other._failedCourses, _failedCourses)&&const DeepCollectionEquality().equals(other._canceledCourses, _canceledCourses)&&(identical(other.nextScenarioId, nextScenarioId) || other.nextScenarioId == nextScenarioId)&&(identical(other.nextScenarioName, nextScenarioName) || other.nextScenarioName == nextScenarioName)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,const DeepCollectionEquality().hash(_succeededCourses),const DeepCollectionEquality().hash(_failedCourses),const DeepCollectionEquality().hash(_canceledCourses),nextScenarioId,nextScenarioName,notes);

@override
String toString() {
  return 'RegistrationStepDto(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, nextScenarioId: $nextScenarioId, nextScenarioName: $nextScenarioName, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RegistrationStepDtoCopyWith<$Res> implements $RegistrationStepDtoCopyWith<$Res> {
  factory _$RegistrationStepDtoCopyWith(_RegistrationStepDto value, $Res Function(_RegistrationStepDto) _then) = __$RegistrationStepDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int scenarioId, String scenarioName, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, int? nextScenarioId, String? nextScenarioName, String? notes
});




}
/// @nodoc
class __$RegistrationStepDtoCopyWithImpl<$Res>
    implements _$RegistrationStepDtoCopyWith<$Res> {
  __$RegistrationStepDtoCopyWithImpl(this._self, this._then);

  final _RegistrationStepDto _self;
  final $Res Function(_RegistrationStepDto) _then;

/// Create a copy of RegistrationStepDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scenarioId = null,Object? scenarioName = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? nextScenarioId = freezed,Object? nextScenarioName = freezed,Object? notes = freezed,}) {
  return _then(_RegistrationStepDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,scenarioId: null == scenarioId ? _self.scenarioId : scenarioId // ignore: cast_nullable_to_non_nullable
as int,scenarioName: null == scenarioName ? _self.scenarioName : scenarioName // ignore: cast_nullable_to_non_nullable
as String,succeededCourses: null == succeededCourses ? _self._succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self._failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self._canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,nextScenarioId: freezed == nextScenarioId ? _self.nextScenarioId : nextScenarioId // ignore: cast_nullable_to_non_nullable
as int?,nextScenarioName: freezed == nextScenarioName ? _self.nextScenarioName : nextScenarioName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
