// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Registration {

 int get id; int get userId; Scenario get startScenario; Scenario get currentScenario; RegistrationStatus get status; List<int> get succeededCourses; List<int> get failedCourses; List<int> get canceledCourses; List<RegistrationStep> get steps;
/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationCopyWith<Registration> get copyWith => _$RegistrationCopyWithImpl<Registration>(this as Registration, _$identity);

  /// Serializes this Registration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Registration&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startScenario, startScenario) || other.startScenario == startScenario)&&(identical(other.currentScenario, currentScenario) || other.currentScenario == currentScenario)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.succeededCourses, succeededCourses)&&const DeepCollectionEquality().equals(other.failedCourses, failedCourses)&&const DeepCollectionEquality().equals(other.canceledCourses, canceledCourses)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startScenario,currentScenario,status,const DeepCollectionEquality().hash(succeededCourses),const DeepCollectionEquality().hash(failedCourses),const DeepCollectionEquality().hash(canceledCourses),const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'Registration(id: $id, userId: $userId, startScenario: $startScenario, currentScenario: $currentScenario, status: $status, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $RegistrationCopyWith<$Res>  {
  factory $RegistrationCopyWith(Registration value, $Res Function(Registration) _then) = _$RegistrationCopyWithImpl;
@useResult
$Res call({
 int id, int userId, Scenario startScenario, Scenario currentScenario, RegistrationStatus status, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, List<RegistrationStep> steps
});


$ScenarioCopyWith<$Res> get startScenario;$ScenarioCopyWith<$Res> get currentScenario;

}
/// @nodoc
class _$RegistrationCopyWithImpl<$Res>
    implements $RegistrationCopyWith<$Res> {
  _$RegistrationCopyWithImpl(this._self, this._then);

  final Registration _self;
  final $Res Function(Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startScenario = null,Object? currentScenario = null,Object? status = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? steps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,startScenario: null == startScenario ? _self.startScenario : startScenario // ignore: cast_nullable_to_non_nullable
as Scenario,currentScenario: null == currentScenario ? _self.currentScenario : currentScenario // ignore: cast_nullable_to_non_nullable
as Scenario,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,succeededCourses: null == succeededCourses ? _self.succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self.failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self.canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RegistrationStep>,
  ));
}
/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioCopyWith<$Res> get startScenario {
  
  return $ScenarioCopyWith<$Res>(_self.startScenario, (value) {
    return _then(_self.copyWith(startScenario: value));
  });
}/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioCopyWith<$Res> get currentScenario {
  
  return $ScenarioCopyWith<$Res>(_self.currentScenario, (value) {
    return _then(_self.copyWith(currentScenario: value));
  });
}
}


/// Adds pattern-matching-related methods to [Registration].
extension RegistrationPatterns on Registration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Registration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Registration value)  $default,){
final _that = this;
switch (_that) {
case _Registration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Registration value)?  $default,){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  Scenario startScenario,  Scenario currentScenario,  RegistrationStatus status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  Scenario startScenario,  Scenario currentScenario,  RegistrationStatus status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStep> steps)  $default,) {final _that = this;
switch (_that) {
case _Registration():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  Scenario startScenario,  Scenario currentScenario,  RegistrationStatus status,  List<int> succeededCourses,  List<int> failedCourses,  List<int> canceledCourses,  List<RegistrationStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
return $default(_that.id,_that.userId,_that.startScenario,_that.currentScenario,_that.status,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Registration implements Registration {
  const _Registration({required this.id, required this.userId, required this.startScenario, required this.currentScenario, required this.status, required final  List<int> succeededCourses, required final  List<int> failedCourses, required final  List<int> canceledCourses, final  List<RegistrationStep> steps = const []}): _succeededCourses = succeededCourses,_failedCourses = failedCourses,_canceledCourses = canceledCourses,_steps = steps;
  factory _Registration.fromJson(Map<String, dynamic> json) => _$RegistrationFromJson(json);

@override final  int id;
@override final  int userId;
@override final  Scenario startScenario;
@override final  Scenario currentScenario;
@override final  RegistrationStatus status;
 final  List<int> _succeededCourses;
@override List<int> get succeededCourses {
  if (_succeededCourses is EqualUnmodifiableListView) return _succeededCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_succeededCourses);
}

 final  List<int> _failedCourses;
@override List<int> get failedCourses {
  if (_failedCourses is EqualUnmodifiableListView) return _failedCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedCourses);
}

 final  List<int> _canceledCourses;
@override List<int> get canceledCourses {
  if (_canceledCourses is EqualUnmodifiableListView) return _canceledCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canceledCourses);
}

 final  List<RegistrationStep> _steps;
@override@JsonKey() List<RegistrationStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationCopyWith<_Registration> get copyWith => __$RegistrationCopyWithImpl<_Registration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Registration&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startScenario, startScenario) || other.startScenario == startScenario)&&(identical(other.currentScenario, currentScenario) || other.currentScenario == currentScenario)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._succeededCourses, _succeededCourses)&&const DeepCollectionEquality().equals(other._failedCourses, _failedCourses)&&const DeepCollectionEquality().equals(other._canceledCourses, _canceledCourses)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startScenario,currentScenario,status,const DeepCollectionEquality().hash(_succeededCourses),const DeepCollectionEquality().hash(_failedCourses),const DeepCollectionEquality().hash(_canceledCourses),const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'Registration(id: $id, userId: $userId, startScenario: $startScenario, currentScenario: $currentScenario, status: $status, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$RegistrationCopyWith<$Res> implements $RegistrationCopyWith<$Res> {
  factory _$RegistrationCopyWith(_Registration value, $Res Function(_Registration) _then) = __$RegistrationCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, Scenario startScenario, Scenario currentScenario, RegistrationStatus status, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, List<RegistrationStep> steps
});


@override $ScenarioCopyWith<$Res> get startScenario;@override $ScenarioCopyWith<$Res> get currentScenario;

}
/// @nodoc
class __$RegistrationCopyWithImpl<$Res>
    implements _$RegistrationCopyWith<$Res> {
  __$RegistrationCopyWithImpl(this._self, this._then);

  final _Registration _self;
  final $Res Function(_Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startScenario = null,Object? currentScenario = null,Object? status = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? steps = null,}) {
  return _then(_Registration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,startScenario: null == startScenario ? _self.startScenario : startScenario // ignore: cast_nullable_to_non_nullable
as Scenario,currentScenario: null == currentScenario ? _self.currentScenario : currentScenario // ignore: cast_nullable_to_non_nullable
as Scenario,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,succeededCourses: null == succeededCourses ? _self._succeededCourses : succeededCourses // ignore: cast_nullable_to_non_nullable
as List<int>,failedCourses: null == failedCourses ? _self._failedCourses : failedCourses // ignore: cast_nullable_to_non_nullable
as List<int>,canceledCourses: null == canceledCourses ? _self._canceledCourses : canceledCourses // ignore: cast_nullable_to_non_nullable
as List<int>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RegistrationStep>,
  ));
}

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioCopyWith<$Res> get startScenario {
  
  return $ScenarioCopyWith<$Res>(_self.startScenario, (value) {
    return _then(_self.copyWith(startScenario: value));
  });
}/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenarioCopyWith<$Res> get currentScenario {
  
  return $ScenarioCopyWith<$Res>(_self.currentScenario, (value) {
    return _then(_self.copyWith(currentScenario: value));
  });
}
}


/// @nodoc
mixin _$RegistrationStep {

 int get id; int get scenarioId; String get scenarioName; List<int> get succeededCourses; List<int> get failedCourses; List<int> get canceledCourses; int? get nextScenarioId; String? get nextScenarioName; String? get notes;
/// Create a copy of RegistrationStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationStepCopyWith<RegistrationStep> get copyWith => _$RegistrationStepCopyWithImpl<RegistrationStep>(this as RegistrationStep, _$identity);

  /// Serializes this RegistrationStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationStep&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&const DeepCollectionEquality().equals(other.succeededCourses, succeededCourses)&&const DeepCollectionEquality().equals(other.failedCourses, failedCourses)&&const DeepCollectionEquality().equals(other.canceledCourses, canceledCourses)&&(identical(other.nextScenarioId, nextScenarioId) || other.nextScenarioId == nextScenarioId)&&(identical(other.nextScenarioName, nextScenarioName) || other.nextScenarioName == nextScenarioName)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,const DeepCollectionEquality().hash(succeededCourses),const DeepCollectionEquality().hash(failedCourses),const DeepCollectionEquality().hash(canceledCourses),nextScenarioId,nextScenarioName,notes);

@override
String toString() {
  return 'RegistrationStep(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, nextScenarioId: $nextScenarioId, nextScenarioName: $nextScenarioName, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RegistrationStepCopyWith<$Res>  {
  factory $RegistrationStepCopyWith(RegistrationStep value, $Res Function(RegistrationStep) _then) = _$RegistrationStepCopyWithImpl;
@useResult
$Res call({
 int id, int scenarioId, String scenarioName, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, int? nextScenarioId, String? nextScenarioName, String? notes
});




}
/// @nodoc
class _$RegistrationStepCopyWithImpl<$Res>
    implements $RegistrationStepCopyWith<$Res> {
  _$RegistrationStepCopyWithImpl(this._self, this._then);

  final RegistrationStep _self;
  final $Res Function(RegistrationStep) _then;

/// Create a copy of RegistrationStep
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


/// Adds pattern-matching-related methods to [RegistrationStep].
extension RegistrationStepPatterns on RegistrationStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationStep value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationStep value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationStep() when $default != null:
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
case _RegistrationStep() when $default != null:
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
case _RegistrationStep():
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
case _RegistrationStep() when $default != null:
return $default(_that.id,_that.scenarioId,_that.scenarioName,_that.succeededCourses,_that.failedCourses,_that.canceledCourses,_that.nextScenarioId,_that.nextScenarioName,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationStep implements RegistrationStep {
  const _RegistrationStep({required this.id, required this.scenarioId, required this.scenarioName, final  List<int> succeededCourses = const [], final  List<int> failedCourses = const [], final  List<int> canceledCourses = const [], this.nextScenarioId, this.nextScenarioName, this.notes}): _succeededCourses = succeededCourses,_failedCourses = failedCourses,_canceledCourses = canceledCourses;
  factory _RegistrationStep.fromJson(Map<String, dynamic> json) => _$RegistrationStepFromJson(json);

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

/// Create a copy of RegistrationStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationStepCopyWith<_RegistrationStep> get copyWith => __$RegistrationStepCopyWithImpl<_RegistrationStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationStep&&(identical(other.id, id) || other.id == id)&&(identical(other.scenarioId, scenarioId) || other.scenarioId == scenarioId)&&(identical(other.scenarioName, scenarioName) || other.scenarioName == scenarioName)&&const DeepCollectionEquality().equals(other._succeededCourses, _succeededCourses)&&const DeepCollectionEquality().equals(other._failedCourses, _failedCourses)&&const DeepCollectionEquality().equals(other._canceledCourses, _canceledCourses)&&(identical(other.nextScenarioId, nextScenarioId) || other.nextScenarioId == nextScenarioId)&&(identical(other.nextScenarioName, nextScenarioName) || other.nextScenarioName == nextScenarioName)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scenarioId,scenarioName,const DeepCollectionEquality().hash(_succeededCourses),const DeepCollectionEquality().hash(_failedCourses),const DeepCollectionEquality().hash(_canceledCourses),nextScenarioId,nextScenarioName,notes);

@override
String toString() {
  return 'RegistrationStep(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, nextScenarioId: $nextScenarioId, nextScenarioName: $nextScenarioName, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RegistrationStepCopyWith<$Res> implements $RegistrationStepCopyWith<$Res> {
  factory _$RegistrationStepCopyWith(_RegistrationStep value, $Res Function(_RegistrationStep) _then) = __$RegistrationStepCopyWithImpl;
@override @useResult
$Res call({
 int id, int scenarioId, String scenarioName, List<int> succeededCourses, List<int> failedCourses, List<int> canceledCourses, int? nextScenarioId, String? nextScenarioName, String? notes
});




}
/// @nodoc
class __$RegistrationStepCopyWithImpl<$Res>
    implements _$RegistrationStepCopyWith<$Res> {
  __$RegistrationStepCopyWithImpl(this._self, this._then);

  final _RegistrationStep _self;
  final $Res Function(_RegistrationStep) _then;

/// Create a copy of RegistrationStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scenarioId = null,Object? scenarioName = null,Object? succeededCourses = null,Object? failedCourses = null,Object? canceledCourses = null,Object? nextScenarioId = freezed,Object? nextScenarioName = freezed,Object? notes = freezed,}) {
  return _then(_RegistrationStep(
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
