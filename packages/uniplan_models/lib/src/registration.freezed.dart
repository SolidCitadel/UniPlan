// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegistrationStep _$RegistrationStepFromJson(Map<String, dynamic> json) {
  return _RegistrationStep.fromJson(json);
}

/// @nodoc
mixin _$RegistrationStep {
  int get id => throw _privateConstructorUsedError;
  int get scenarioId => throw _privateConstructorUsedError;
  String get scenarioName => throw _privateConstructorUsedError;
  List<int> get succeededCourses => throw _privateConstructorUsedError;
  List<int> get failedCourses => throw _privateConstructorUsedError;
  List<int> get canceledCourses => throw _privateConstructorUsedError;
  int? get nextScenarioId => throw _privateConstructorUsedError;
  String? get nextScenarioName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this RegistrationStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationStepCopyWith<RegistrationStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStepCopyWith<$Res> {
  factory $RegistrationStepCopyWith(
    RegistrationStep value,
    $Res Function(RegistrationStep) then,
  ) = _$RegistrationStepCopyWithImpl<$Res, RegistrationStep>;
  @useResult
  $Res call({
    int id,
    int scenarioId,
    String scenarioName,
    List<int> succeededCourses,
    List<int> failedCourses,
    List<int> canceledCourses,
    int? nextScenarioId,
    String? nextScenarioName,
    String? notes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? timestamp,
  });
}

/// @nodoc
class _$RegistrationStepCopyWithImpl<$Res, $Val extends RegistrationStep>
    implements $RegistrationStepCopyWith<$Res> {
  _$RegistrationStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scenarioId = null,
    Object? scenarioName = null,
    Object? succeededCourses = null,
    Object? failedCourses = null,
    Object? canceledCourses = null,
    Object? nextScenarioId = freezed,
    Object? nextScenarioName = freezed,
    Object? notes = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            scenarioId: null == scenarioId
                ? _value.scenarioId
                : scenarioId // ignore: cast_nullable_to_non_nullable
                      as int,
            scenarioName: null == scenarioName
                ? _value.scenarioName
                : scenarioName // ignore: cast_nullable_to_non_nullable
                      as String,
            succeededCourses: null == succeededCourses
                ? _value.succeededCourses
                : succeededCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            failedCourses: null == failedCourses
                ? _value.failedCourses
                : failedCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            canceledCourses: null == canceledCourses
                ? _value.canceledCourses
                : canceledCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            nextScenarioId: freezed == nextScenarioId
                ? _value.nextScenarioId
                : nextScenarioId // ignore: cast_nullable_to_non_nullable
                      as int?,
            nextScenarioName: freezed == nextScenarioName
                ? _value.nextScenarioName
                : nextScenarioName // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegistrationStepImplCopyWith<$Res>
    implements $RegistrationStepCopyWith<$Res> {
  factory _$$RegistrationStepImplCopyWith(
    _$RegistrationStepImpl value,
    $Res Function(_$RegistrationStepImpl) then,
  ) = __$$RegistrationStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int scenarioId,
    String scenarioName,
    List<int> succeededCourses,
    List<int> failedCourses,
    List<int> canceledCourses,
    int? nextScenarioId,
    String? nextScenarioName,
    String? notes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? timestamp,
  });
}

/// @nodoc
class __$$RegistrationStepImplCopyWithImpl<$Res>
    extends _$RegistrationStepCopyWithImpl<$Res, _$RegistrationStepImpl>
    implements _$$RegistrationStepImplCopyWith<$Res> {
  __$$RegistrationStepImplCopyWithImpl(
    _$RegistrationStepImpl _value,
    $Res Function(_$RegistrationStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scenarioId = null,
    Object? scenarioName = null,
    Object? succeededCourses = null,
    Object? failedCourses = null,
    Object? canceledCourses = null,
    Object? nextScenarioId = freezed,
    Object? nextScenarioName = freezed,
    Object? notes = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _$RegistrationStepImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        scenarioId: null == scenarioId
            ? _value.scenarioId
            : scenarioId // ignore: cast_nullable_to_non_nullable
                  as int,
        scenarioName: null == scenarioName
            ? _value.scenarioName
            : scenarioName // ignore: cast_nullable_to_non_nullable
                  as String,
        succeededCourses: null == succeededCourses
            ? _value._succeededCourses
            : succeededCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        failedCourses: null == failedCourses
            ? _value._failedCourses
            : failedCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        canceledCourses: null == canceledCourses
            ? _value._canceledCourses
            : canceledCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        nextScenarioId: freezed == nextScenarioId
            ? _value.nextScenarioId
            : nextScenarioId // ignore: cast_nullable_to_non_nullable
                  as int?,
        nextScenarioName: freezed == nextScenarioName
            ? _value.nextScenarioName
            : nextScenarioName // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationStepImpl implements _RegistrationStep {
  const _$RegistrationStepImpl({
    required this.id,
    required this.scenarioId,
    required this.scenarioName,
    final List<int> succeededCourses = const <int>[],
    final List<int> failedCourses = const <int>[],
    final List<int> canceledCourses = const <int>[],
    this.nextScenarioId,
    this.nextScenarioName,
    this.notes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.timestamp,
  }) : _succeededCourses = succeededCourses,
       _failedCourses = failedCourses,
       _canceledCourses = canceledCourses;

  factory _$RegistrationStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationStepImplFromJson(json);

  @override
  final int id;
  @override
  final int scenarioId;
  @override
  final String scenarioName;
  final List<int> _succeededCourses;
  @override
  @JsonKey()
  List<int> get succeededCourses {
    if (_succeededCourses is EqualUnmodifiableListView)
      return _succeededCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_succeededCourses);
  }

  final List<int> _failedCourses;
  @override
  @JsonKey()
  List<int> get failedCourses {
    if (_failedCourses is EqualUnmodifiableListView) return _failedCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedCourses);
  }

  final List<int> _canceledCourses;
  @override
  @JsonKey()
  List<int> get canceledCourses {
    if (_canceledCourses is EqualUnmodifiableListView) return _canceledCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_canceledCourses);
  }

  @override
  final int? nextScenarioId;
  @override
  final String? nextScenarioName;
  @override
  final String? notes;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? timestamp;

  @override
  String toString() {
    return 'RegistrationStep(id: $id, scenarioId: $scenarioId, scenarioName: $scenarioName, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, nextScenarioId: $nextScenarioId, nextScenarioName: $nextScenarioName, notes: $notes, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scenarioId, scenarioId) ||
                other.scenarioId == scenarioId) &&
            (identical(other.scenarioName, scenarioName) ||
                other.scenarioName == scenarioName) &&
            const DeepCollectionEquality().equals(
              other._succeededCourses,
              _succeededCourses,
            ) &&
            const DeepCollectionEquality().equals(
              other._failedCourses,
              _failedCourses,
            ) &&
            const DeepCollectionEquality().equals(
              other._canceledCourses,
              _canceledCourses,
            ) &&
            (identical(other.nextScenarioId, nextScenarioId) ||
                other.nextScenarioId == nextScenarioId) &&
            (identical(other.nextScenarioName, nextScenarioName) ||
                other.nextScenarioName == nextScenarioName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    scenarioId,
    scenarioName,
    const DeepCollectionEquality().hash(_succeededCourses),
    const DeepCollectionEquality().hash(_failedCourses),
    const DeepCollectionEquality().hash(_canceledCourses),
    nextScenarioId,
    nextScenarioName,
    notes,
    timestamp,
  );

  /// Create a copy of RegistrationStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationStepImplCopyWith<_$RegistrationStepImpl> get copyWith =>
      __$$RegistrationStepImplCopyWithImpl<_$RegistrationStepImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationStepImplToJson(this);
  }
}

abstract class _RegistrationStep implements RegistrationStep {
  const factory _RegistrationStep({
    required final int id,
    required final int scenarioId,
    required final String scenarioName,
    final List<int> succeededCourses,
    final List<int> failedCourses,
    final List<int> canceledCourses,
    final int? nextScenarioId,
    final String? nextScenarioName,
    final String? notes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? timestamp,
  }) = _$RegistrationStepImpl;

  factory _RegistrationStep.fromJson(Map<String, dynamic> json) =
      _$RegistrationStepImpl.fromJson;

  @override
  int get id;
  @override
  int get scenarioId;
  @override
  String get scenarioName;
  @override
  List<int> get succeededCourses;
  @override
  List<int> get failedCourses;
  @override
  List<int> get canceledCourses;
  @override
  int? get nextScenarioId;
  @override
  String? get nextScenarioName;
  @override
  String? get notes;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get timestamp;

  /// Create a copy of RegistrationStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationStepImplCopyWith<_$RegistrationStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Registration _$RegistrationFromJson(Map<String, dynamic> json) {
  return _Registration.fromJson(json);
}

/// @nodoc
mixin _$Registration {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  Scenario get startScenario => throw _privateConstructorUsedError;
  Scenario get currentScenario => throw _privateConstructorUsedError;
  RegistrationStatus get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<int> get succeededCourses => throw _privateConstructorUsedError;
  List<int> get failedCourses => throw _privateConstructorUsedError;
  List<int> get canceledCourses => throw _privateConstructorUsedError;
  List<RegistrationStep> get steps => throw _privateConstructorUsedError;

  /// Serializes this Registration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationCopyWith<Registration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationCopyWith<$Res> {
  factory $RegistrationCopyWith(
    Registration value,
    $Res Function(Registration) then,
  ) = _$RegistrationCopyWithImpl<$Res, Registration>;
  @useResult
  $Res call({
    int id,
    int userId,
    Scenario startScenario,
    Scenario currentScenario,
    RegistrationStatus status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? startedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? completedAt,
    List<int> succeededCourses,
    List<int> failedCourses,
    List<int> canceledCourses,
    List<RegistrationStep> steps,
  });

  $ScenarioCopyWith<$Res> get startScenario;
  $ScenarioCopyWith<$Res> get currentScenario;
}

/// @nodoc
class _$RegistrationCopyWithImpl<$Res, $Val extends Registration>
    implements $RegistrationCopyWith<$Res> {
  _$RegistrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startScenario = null,
    Object? currentScenario = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? succeededCourses = null,
    Object? failedCourses = null,
    Object? canceledCourses = null,
    Object? steps = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            startScenario: null == startScenario
                ? _value.startScenario
                : startScenario // ignore: cast_nullable_to_non_nullable
                      as Scenario,
            currentScenario: null == currentScenario
                ? _value.currentScenario
                : currentScenario // ignore: cast_nullable_to_non_nullable
                      as Scenario,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RegistrationStatus,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            succeededCourses: null == succeededCourses
                ? _value.succeededCourses
                : succeededCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            failedCourses: null == failedCourses
                ? _value.failedCourses
                : failedCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            canceledCourses: null == canceledCourses
                ? _value.canceledCourses
                : canceledCourses // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<RegistrationStep>,
          )
          as $Val,
    );
  }

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScenarioCopyWith<$Res> get startScenario {
    return $ScenarioCopyWith<$Res>(_value.startScenario, (value) {
      return _then(_value.copyWith(startScenario: value) as $Val);
    });
  }

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScenarioCopyWith<$Res> get currentScenario {
    return $ScenarioCopyWith<$Res>(_value.currentScenario, (value) {
      return _then(_value.copyWith(currentScenario: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationImplCopyWith<$Res>
    implements $RegistrationCopyWith<$Res> {
  factory _$$RegistrationImplCopyWith(
    _$RegistrationImpl value,
    $Res Function(_$RegistrationImpl) then,
  ) = __$$RegistrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int userId,
    Scenario startScenario,
    Scenario currentScenario,
    RegistrationStatus status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? startedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? completedAt,
    List<int> succeededCourses,
    List<int> failedCourses,
    List<int> canceledCourses,
    List<RegistrationStep> steps,
  });

  @override
  $ScenarioCopyWith<$Res> get startScenario;
  @override
  $ScenarioCopyWith<$Res> get currentScenario;
}

/// @nodoc
class __$$RegistrationImplCopyWithImpl<$Res>
    extends _$RegistrationCopyWithImpl<$Res, _$RegistrationImpl>
    implements _$$RegistrationImplCopyWith<$Res> {
  __$$RegistrationImplCopyWithImpl(
    _$RegistrationImpl _value,
    $Res Function(_$RegistrationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startScenario = null,
    Object? currentScenario = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? succeededCourses = null,
    Object? failedCourses = null,
    Object? canceledCourses = null,
    Object? steps = null,
  }) {
    return _then(
      _$RegistrationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        startScenario: null == startScenario
            ? _value.startScenario
            : startScenario // ignore: cast_nullable_to_non_nullable
                  as Scenario,
        currentScenario: null == currentScenario
            ? _value.currentScenario
            : currentScenario // ignore: cast_nullable_to_non_nullable
                  as Scenario,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RegistrationStatus,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        succeededCourses: null == succeededCourses
            ? _value._succeededCourses
            : succeededCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        failedCourses: null == failedCourses
            ? _value._failedCourses
            : failedCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        canceledCourses: null == canceledCourses
            ? _value._canceledCourses
            : canceledCourses // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<RegistrationStep>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationImpl implements _Registration {
  const _$RegistrationImpl({
    required this.id,
    required this.userId,
    required this.startScenario,
    required this.currentScenario,
    required this.status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.startedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    this.completedAt,
    final List<int> succeededCourses = const <int>[],
    final List<int> failedCourses = const <int>[],
    final List<int> canceledCourses = const <int>[],
    final List<RegistrationStep> steps = const <RegistrationStep>[],
  }) : _succeededCourses = succeededCourses,
       _failedCourses = failedCourses,
       _canceledCourses = canceledCourses,
       _steps = steps;

  factory _$RegistrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final Scenario startScenario;
  @override
  final Scenario currentScenario;
  @override
  final RegistrationStatus status;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? startedAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? completedAt;
  final List<int> _succeededCourses;
  @override
  @JsonKey()
  List<int> get succeededCourses {
    if (_succeededCourses is EqualUnmodifiableListView)
      return _succeededCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_succeededCourses);
  }

  final List<int> _failedCourses;
  @override
  @JsonKey()
  List<int> get failedCourses {
    if (_failedCourses is EqualUnmodifiableListView) return _failedCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedCourses);
  }

  final List<int> _canceledCourses;
  @override
  @JsonKey()
  List<int> get canceledCourses {
    if (_canceledCourses is EqualUnmodifiableListView) return _canceledCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_canceledCourses);
  }

  final List<RegistrationStep> _steps;
  @override
  @JsonKey()
  List<RegistrationStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'Registration(id: $id, userId: $userId, startScenario: $startScenario, currentScenario: $currentScenario, status: $status, startedAt: $startedAt, completedAt: $completedAt, succeededCourses: $succeededCourses, failedCourses: $failedCourses, canceledCourses: $canceledCourses, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startScenario, startScenario) ||
                other.startScenario == startScenario) &&
            (identical(other.currentScenario, currentScenario) ||
                other.currentScenario == currentScenario) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(
              other._succeededCourses,
              _succeededCourses,
            ) &&
            const DeepCollectionEquality().equals(
              other._failedCourses,
              _failedCourses,
            ) &&
            const DeepCollectionEquality().equals(
              other._canceledCourses,
              _canceledCourses,
            ) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    startScenario,
    currentScenario,
    status,
    startedAt,
    completedAt,
    const DeepCollectionEquality().hash(_succeededCourses),
    const DeepCollectionEquality().hash(_failedCourses),
    const DeepCollectionEquality().hash(_canceledCourses),
    const DeepCollectionEquality().hash(_steps),
  );

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationImplCopyWith<_$RegistrationImpl> get copyWith =>
      __$$RegistrationImplCopyWithImpl<_$RegistrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationImplToJson(this);
  }
}

abstract class _Registration implements Registration {
  const factory _Registration({
    required final int id,
    required final int userId,
    required final Scenario startScenario,
    required final Scenario currentScenario,
    required final RegistrationStatus status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? startedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? completedAt,
    final List<int> succeededCourses,
    final List<int> failedCourses,
    final List<int> canceledCourses,
    final List<RegistrationStep> steps,
  }) = _$RegistrationImpl;

  factory _Registration.fromJson(Map<String, dynamic> json) =
      _$RegistrationImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  Scenario get startScenario;
  @override
  Scenario get currentScenario;
  @override
  RegistrationStatus get status;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get startedAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get completedAt;
  @override
  List<int> get succeededCourses;
  @override
  List<int> get failedCourses;
  @override
  List<int> get canceledCourses;
  @override
  List<RegistrationStep> get steps;

  /// Create a copy of Registration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationImplCopyWith<_$RegistrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
