// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Scenario _$ScenarioFromJson(Map<String, dynamic> json) {
  return _Scenario.fromJson(json);
}

/// @nodoc
mixin _$Scenario {
  int get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'parentScenarioId')
  int? get parentScenarioId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds => throw _privateConstructorUsedError;
  int? get orderIndex => throw _privateConstructorUsedError;
  Timetable get timetable => throw _privateConstructorUsedError;
  List<Scenario> get childScenarios => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Scenario to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScenarioCopyWith<Scenario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioCopyWith<$Res> {
  factory $ScenarioCopyWith(Scenario value, $Res Function(Scenario) then) =
      _$ScenarioCopyWithImpl<$Res, Scenario>;
  @useResult
  $Res call({
    int id,
    int? userId,
    String name,
    String? description,
    @JsonKey(name: 'parentScenarioId') int? parentScenarioId,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> failedCourseIds,
    int? orderIndex,
    Timetable timetable,
    List<Scenario> childScenarios,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? updatedAt,
  });

  $TimetableCopyWith<$Res> get timetable;
}

/// @nodoc
class _$ScenarioCopyWithImpl<$Res, $Val extends Scenario>
    implements $ScenarioCopyWith<$Res> {
  _$ScenarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? parentScenarioId = freezed,
    Object? failedCourseIds = null,
    Object? orderIndex = freezed,
    Object? timetable = null,
    Object? childScenarios = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentScenarioId: freezed == parentScenarioId
                ? _value.parentScenarioId
                : parentScenarioId // ignore: cast_nullable_to_non_nullable
                      as int?,
            failedCourseIds: null == failedCourseIds
                ? _value.failedCourseIds
                : failedCourseIds // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
            orderIndex: freezed == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
            timetable: null == timetable
                ? _value.timetable
                : timetable // ignore: cast_nullable_to_non_nullable
                      as Timetable,
            childScenarios: null == childScenarios
                ? _value.childScenarios
                : childScenarios // ignore: cast_nullable_to_non_nullable
                      as List<Scenario>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimetableCopyWith<$Res> get timetable {
    return $TimetableCopyWith<$Res>(_value.timetable, (value) {
      return _then(_value.copyWith(timetable: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScenarioImplCopyWith<$Res>
    implements $ScenarioCopyWith<$Res> {
  factory _$$ScenarioImplCopyWith(
    _$ScenarioImpl value,
    $Res Function(_$ScenarioImpl) then,
  ) = __$$ScenarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int? userId,
    String name,
    String? description,
    @JsonKey(name: 'parentScenarioId') int? parentScenarioId,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> failedCourseIds,
    int? orderIndex,
    Timetable timetable,
    List<Scenario> childScenarios,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? updatedAt,
  });

  @override
  $TimetableCopyWith<$Res> get timetable;
}

/// @nodoc
class __$$ScenarioImplCopyWithImpl<$Res>
    extends _$ScenarioCopyWithImpl<$Res, _$ScenarioImpl>
    implements _$$ScenarioImplCopyWith<$Res> {
  __$$ScenarioImplCopyWithImpl(
    _$ScenarioImpl _value,
    $Res Function(_$ScenarioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? parentScenarioId = freezed,
    Object? failedCourseIds = null,
    Object? orderIndex = freezed,
    Object? timetable = null,
    Object? childScenarios = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ScenarioImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentScenarioId: freezed == parentScenarioId
            ? _value.parentScenarioId
            : parentScenarioId // ignore: cast_nullable_to_non_nullable
                  as int?,
        failedCourseIds: null == failedCourseIds
            ? _value._failedCourseIds
            : failedCourseIds // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
        orderIndex: freezed == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
        timetable: null == timetable
            ? _value.timetable
            : timetable // ignore: cast_nullable_to_non_nullable
                  as Timetable,
        childScenarios: null == childScenarios
            ? _value._childScenarios
            : childScenarios // ignore: cast_nullable_to_non_nullable
                  as List<Scenario>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioImpl implements _Scenario {
  const _$ScenarioImpl({
    required this.id,
    this.userId,
    required this.name,
    this.description,
    @JsonKey(name: 'parentScenarioId') this.parentScenarioId,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> failedCourseIds = const <int>{},
    this.orderIndex,
    required this.timetable,
    final List<Scenario> childScenarios = const <Scenario>[],
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.updatedAt,
  }) : _failedCourseIds = failedCourseIds,
       _childScenarios = childScenarios;

  factory _$ScenarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioImplFromJson(json);

  @override
  final int id;
  @override
  final int? userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'parentScenarioId')
  final int? parentScenarioId;
  final Set<int> _failedCourseIds;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds {
    if (_failedCourseIds is EqualUnmodifiableSetView) return _failedCourseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_failedCourseIds);
  }

  @override
  final int? orderIndex;
  @override
  final Timetable timetable;
  final List<Scenario> _childScenarios;
  @override
  @JsonKey()
  List<Scenario> get childScenarios {
    if (_childScenarios is EqualUnmodifiableListView) return _childScenarios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childScenarios);
  }

  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Scenario(id: $id, userId: $userId, name: $name, description: $description, parentScenarioId: $parentScenarioId, failedCourseIds: $failedCourseIds, orderIndex: $orderIndex, timetable: $timetable, childScenarios: $childScenarios, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentScenarioId, parentScenarioId) ||
                other.parentScenarioId == parentScenarioId) &&
            const DeepCollectionEquality().equals(
              other._failedCourseIds,
              _failedCourseIds,
            ) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.timetable, timetable) ||
                other.timetable == timetable) &&
            const DeepCollectionEquality().equals(
              other._childScenarios,
              _childScenarios,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    description,
    parentScenarioId,
    const DeepCollectionEquality().hash(_failedCourseIds),
    orderIndex,
    timetable,
    const DeepCollectionEquality().hash(_childScenarios),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      __$$ScenarioImplCopyWithImpl<_$ScenarioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioImplToJson(this);
  }
}

abstract class _Scenario implements Scenario {
  const factory _Scenario({
    required final int id,
    final int? userId,
    required final String name,
    final String? description,
    @JsonKey(name: 'parentScenarioId') final int? parentScenarioId,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> failedCourseIds,
    final int? orderIndex,
    required final Timetable timetable,
    final List<Scenario> childScenarios,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? updatedAt,
  }) = _$ScenarioImpl;

  factory _Scenario.fromJson(Map<String, dynamic> json) =
      _$ScenarioImpl.fromJson;

  @override
  int get id;
  @override
  int? get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'parentScenarioId')
  int? get parentScenarioId;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds;
  @override
  int? get orderIndex;
  @override
  Timetable get timetable;
  @override
  List<Scenario> get childScenarios;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get updatedAt;

  /// Create a copy of Scenario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
