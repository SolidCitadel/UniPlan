// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateTimetableRequest _$CreateTimetableRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateTimetableRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTimetableRequest {
  String get name => throw _privateConstructorUsedError;
  int get openingYear => throw _privateConstructorUsedError;
  String get semester => throw _privateConstructorUsedError;

  /// Serializes this CreateTimetableRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTimetableRequestCopyWith<CreateTimetableRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTimetableRequestCopyWith<$Res> {
  factory $CreateTimetableRequestCopyWith(
    CreateTimetableRequest value,
    $Res Function(CreateTimetableRequest) then,
  ) = _$CreateTimetableRequestCopyWithImpl<$Res, CreateTimetableRequest>;
  @useResult
  $Res call({String name, int openingYear, String semester});
}

/// @nodoc
class _$CreateTimetableRequestCopyWithImpl<
  $Res,
  $Val extends CreateTimetableRequest
>
    implements $CreateTimetableRequestCopyWith<$Res> {
  _$CreateTimetableRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? openingYear = null,
    Object? semester = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            openingYear: null == openingYear
                ? _value.openingYear
                : openingYear // ignore: cast_nullable_to_non_nullable
                      as int,
            semester: null == semester
                ? _value.semester
                : semester // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateTimetableRequestImplCopyWith<$Res>
    implements $CreateTimetableRequestCopyWith<$Res> {
  factory _$$CreateTimetableRequestImplCopyWith(
    _$CreateTimetableRequestImpl value,
    $Res Function(_$CreateTimetableRequestImpl) then,
  ) = __$$CreateTimetableRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int openingYear, String semester});
}

/// @nodoc
class __$$CreateTimetableRequestImplCopyWithImpl<$Res>
    extends
        _$CreateTimetableRequestCopyWithImpl<$Res, _$CreateTimetableRequestImpl>
    implements _$$CreateTimetableRequestImplCopyWith<$Res> {
  __$$CreateTimetableRequestImplCopyWithImpl(
    _$CreateTimetableRequestImpl _value,
    $Res Function(_$CreateTimetableRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? openingYear = null,
    Object? semester = null,
  }) {
    return _then(
      _$CreateTimetableRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        openingYear: null == openingYear
            ? _value.openingYear
            : openingYear // ignore: cast_nullable_to_non_nullable
                  as int,
        semester: null == semester
            ? _value.semester
            : semester // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTimetableRequestImpl implements _CreateTimetableRequest {
  const _$CreateTimetableRequestImpl({
    required this.name,
    required this.openingYear,
    required this.semester,
  });

  factory _$CreateTimetableRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTimetableRequestImplFromJson(json);

  @override
  final String name;
  @override
  final int openingYear;
  @override
  final String semester;

  @override
  String toString() {
    return 'CreateTimetableRequest(name: $name, openingYear: $openingYear, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTimetableRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.openingYear, openingYear) ||
                other.openingYear == openingYear) &&
            (identical(other.semester, semester) ||
                other.semester == semester));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, openingYear, semester);

  /// Create a copy of CreateTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTimetableRequestImplCopyWith<_$CreateTimetableRequestImpl>
  get copyWith =>
      __$$CreateTimetableRequestImplCopyWithImpl<_$CreateTimetableRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTimetableRequestImplToJson(this);
  }
}

abstract class _CreateTimetableRequest implements CreateTimetableRequest {
  const factory _CreateTimetableRequest({
    required final String name,
    required final int openingYear,
    required final String semester,
  }) = _$CreateTimetableRequestImpl;

  factory _CreateTimetableRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTimetableRequestImpl.fromJson;

  @override
  String get name;
  @override
  int get openingYear;
  @override
  String get semester;

  /// Create a copy of CreateTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTimetableRequestImplCopyWith<_$CreateTimetableRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateAlternativeTimetableRequest _$CreateAlternativeTimetableRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateAlternativeTimetableRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateAlternativeTimetableRequest {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get excludedCourseIds => throw _privateConstructorUsedError;

  /// Serializes this CreateAlternativeTimetableRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateAlternativeTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAlternativeTimetableRequestCopyWith<CreateAlternativeTimetableRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAlternativeTimetableRequestCopyWith<$Res> {
  factory $CreateAlternativeTimetableRequestCopyWith(
    CreateAlternativeTimetableRequest value,
    $Res Function(CreateAlternativeTimetableRequest) then,
  ) =
      _$CreateAlternativeTimetableRequestCopyWithImpl<
        $Res,
        CreateAlternativeTimetableRequest
      >;
  @useResult
  $Res call({
    String name,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> excludedCourseIds,
  });
}

/// @nodoc
class _$CreateAlternativeTimetableRequestCopyWithImpl<
  $Res,
  $Val extends CreateAlternativeTimetableRequest
>
    implements $CreateAlternativeTimetableRequestCopyWith<$Res> {
  _$CreateAlternativeTimetableRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAlternativeTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? excludedCourseIds = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            excludedCourseIds: null == excludedCourseIds
                ? _value.excludedCourseIds
                : excludedCourseIds // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateAlternativeTimetableRequestImplCopyWith<$Res>
    implements $CreateAlternativeTimetableRequestCopyWith<$Res> {
  factory _$$CreateAlternativeTimetableRequestImplCopyWith(
    _$CreateAlternativeTimetableRequestImpl value,
    $Res Function(_$CreateAlternativeTimetableRequestImpl) then,
  ) = __$$CreateAlternativeTimetableRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> excludedCourseIds,
  });
}

/// @nodoc
class __$$CreateAlternativeTimetableRequestImplCopyWithImpl<$Res>
    extends
        _$CreateAlternativeTimetableRequestCopyWithImpl<
          $Res,
          _$CreateAlternativeTimetableRequestImpl
        >
    implements _$$CreateAlternativeTimetableRequestImplCopyWith<$Res> {
  __$$CreateAlternativeTimetableRequestImplCopyWithImpl(
    _$CreateAlternativeTimetableRequestImpl _value,
    $Res Function(_$CreateAlternativeTimetableRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateAlternativeTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? excludedCourseIds = null}) {
    return _then(
      _$CreateAlternativeTimetableRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        excludedCourseIds: null == excludedCourseIds
            ? _value._excludedCourseIds
            : excludedCourseIds // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateAlternativeTimetableRequestImpl
    implements _CreateAlternativeTimetableRequest {
  const _$CreateAlternativeTimetableRequestImpl({
    required this.name,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> excludedCourseIds = const <int>{},
  }) : _excludedCourseIds = excludedCourseIds;

  factory _$CreateAlternativeTimetableRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateAlternativeTimetableRequestImplFromJson(json);

  @override
  final String name;
  final Set<int> _excludedCourseIds;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get excludedCourseIds {
    if (_excludedCourseIds is EqualUnmodifiableSetView)
      return _excludedCourseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_excludedCourseIds);
  }

  @override
  String toString() {
    return 'CreateAlternativeTimetableRequest(name: $name, excludedCourseIds: $excludedCourseIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAlternativeTimetableRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._excludedCourseIds,
              _excludedCourseIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_excludedCourseIds),
  );

  /// Create a copy of CreateAlternativeTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAlternativeTimetableRequestImplCopyWith<
    _$CreateAlternativeTimetableRequestImpl
  >
  get copyWith =>
      __$$CreateAlternativeTimetableRequestImplCopyWithImpl<
        _$CreateAlternativeTimetableRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateAlternativeTimetableRequestImplToJson(this);
  }
}

abstract class _CreateAlternativeTimetableRequest
    implements CreateAlternativeTimetableRequest {
  const factory _CreateAlternativeTimetableRequest({
    required final String name,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> excludedCourseIds,
  }) = _$CreateAlternativeTimetableRequestImpl;

  factory _CreateAlternativeTimetableRequest.fromJson(
    Map<String, dynamic> json,
  ) = _$CreateAlternativeTimetableRequestImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get excludedCourseIds;

  /// Create a copy of CreateAlternativeTimetableRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAlternativeTimetableRequestImplCopyWith<
    _$CreateAlternativeTimetableRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

CreateScenarioRequest _$CreateScenarioRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateScenarioRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateScenarioRequest {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CreateTimetableRequest? get timetableRequest =>
      throw _privateConstructorUsedError;
  int? get existingTimetableId => throw _privateConstructorUsedError;

  /// Serializes this CreateScenarioRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateScenarioRequestCopyWith<CreateScenarioRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateScenarioRequestCopyWith<$Res> {
  factory $CreateScenarioRequestCopyWith(
    CreateScenarioRequest value,
    $Res Function(CreateScenarioRequest) then,
  ) = _$CreateScenarioRequestCopyWithImpl<$Res, CreateScenarioRequest>;
  @useResult
  $Res call({
    String name,
    String? description,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
  });

  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest;
}

/// @nodoc
class _$CreateScenarioRequestCopyWithImpl<
  $Res,
  $Val extends CreateScenarioRequest
>
    implements $CreateScenarioRequestCopyWith<$Res> {
  _$CreateScenarioRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? timetableRequest = freezed,
    Object? existingTimetableId = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            timetableRequest: freezed == timetableRequest
                ? _value.timetableRequest
                : timetableRequest // ignore: cast_nullable_to_non_nullable
                      as CreateTimetableRequest?,
            existingTimetableId: freezed == existingTimetableId
                ? _value.existingTimetableId
                : existingTimetableId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest {
    if (_value.timetableRequest == null) {
      return null;
    }

    return $CreateTimetableRequestCopyWith<$Res>(_value.timetableRequest!, (
      value,
    ) {
      return _then(_value.copyWith(timetableRequest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateScenarioRequestImplCopyWith<$Res>
    implements $CreateScenarioRequestCopyWith<$Res> {
  factory _$$CreateScenarioRequestImplCopyWith(
    _$CreateScenarioRequestImpl value,
    $Res Function(_$CreateScenarioRequestImpl) then,
  ) = __$$CreateScenarioRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? description,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
  });

  @override
  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest;
}

/// @nodoc
class __$$CreateScenarioRequestImplCopyWithImpl<$Res>
    extends
        _$CreateScenarioRequestCopyWithImpl<$Res, _$CreateScenarioRequestImpl>
    implements _$$CreateScenarioRequestImplCopyWith<$Res> {
  __$$CreateScenarioRequestImplCopyWithImpl(
    _$CreateScenarioRequestImpl _value,
    $Res Function(_$CreateScenarioRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? timetableRequest = freezed,
    Object? existingTimetableId = freezed,
  }) {
    return _then(
      _$CreateScenarioRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        timetableRequest: freezed == timetableRequest
            ? _value.timetableRequest
            : timetableRequest // ignore: cast_nullable_to_non_nullable
                  as CreateTimetableRequest?,
        existingTimetableId: freezed == existingTimetableId
            ? _value.existingTimetableId
            : existingTimetableId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateScenarioRequestImpl implements _CreateScenarioRequest {
  const _$CreateScenarioRequestImpl({
    required this.name,
    this.description,
    this.timetableRequest,
    this.existingTimetableId,
  });

  factory _$CreateScenarioRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateScenarioRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? description;
  @override
  final CreateTimetableRequest? timetableRequest;
  @override
  final int? existingTimetableId;

  @override
  String toString() {
    return 'CreateScenarioRequest(name: $name, description: $description, timetableRequest: $timetableRequest, existingTimetableId: $existingTimetableId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateScenarioRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timetableRequest, timetableRequest) ||
                other.timetableRequest == timetableRequest) &&
            (identical(other.existingTimetableId, existingTimetableId) ||
                other.existingTimetableId == existingTimetableId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    timetableRequest,
    existingTimetableId,
  );

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateScenarioRequestImplCopyWith<_$CreateScenarioRequestImpl>
  get copyWith =>
      __$$CreateScenarioRequestImplCopyWithImpl<_$CreateScenarioRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateScenarioRequestImplToJson(this);
  }
}

abstract class _CreateScenarioRequest implements CreateScenarioRequest {
  const factory _CreateScenarioRequest({
    required final String name,
    final String? description,
    final CreateTimetableRequest? timetableRequest,
    final int? existingTimetableId,
  }) = _$CreateScenarioRequestImpl;

  factory _CreateScenarioRequest.fromJson(Map<String, dynamic> json) =
      _$CreateScenarioRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get description;
  @override
  CreateTimetableRequest? get timetableRequest;
  @override
  int? get existingTimetableId;

  /// Create a copy of CreateScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateScenarioRequestImplCopyWith<_$CreateScenarioRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateAlternativeScenarioRequest _$CreateAlternativeScenarioRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateAlternativeScenarioRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateAlternativeScenarioRequest {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds => throw _privateConstructorUsedError;
  CreateTimetableRequest? get timetableRequest =>
      throw _privateConstructorUsedError;
  int? get existingTimetableId => throw _privateConstructorUsedError;
  int? get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this CreateAlternativeScenarioRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAlternativeScenarioRequestCopyWith<CreateAlternativeScenarioRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAlternativeScenarioRequestCopyWith<$Res> {
  factory $CreateAlternativeScenarioRequestCopyWith(
    CreateAlternativeScenarioRequest value,
    $Res Function(CreateAlternativeScenarioRequest) then,
  ) =
      _$CreateAlternativeScenarioRequestCopyWithImpl<
        $Res,
        CreateAlternativeScenarioRequest
      >;
  @useResult
  $Res call({
    String name,
    String? description,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> failedCourseIds,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
    int? orderIndex,
  });

  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest;
}

/// @nodoc
class _$CreateAlternativeScenarioRequestCopyWithImpl<
  $Res,
  $Val extends CreateAlternativeScenarioRequest
>
    implements $CreateAlternativeScenarioRequestCopyWith<$Res> {
  _$CreateAlternativeScenarioRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? failedCourseIds = null,
    Object? timetableRequest = freezed,
    Object? existingTimetableId = freezed,
    Object? orderIndex = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            failedCourseIds: null == failedCourseIds
                ? _value.failedCourseIds
                : failedCourseIds // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
            timetableRequest: freezed == timetableRequest
                ? _value.timetableRequest
                : timetableRequest // ignore: cast_nullable_to_non_nullable
                      as CreateTimetableRequest?,
            existingTimetableId: freezed == existingTimetableId
                ? _value.existingTimetableId
                : existingTimetableId // ignore: cast_nullable_to_non_nullable
                      as int?,
            orderIndex: freezed == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest {
    if (_value.timetableRequest == null) {
      return null;
    }

    return $CreateTimetableRequestCopyWith<$Res>(_value.timetableRequest!, (
      value,
    ) {
      return _then(_value.copyWith(timetableRequest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateAlternativeScenarioRequestImplCopyWith<$Res>
    implements $CreateAlternativeScenarioRequestCopyWith<$Res> {
  factory _$$CreateAlternativeScenarioRequestImplCopyWith(
    _$CreateAlternativeScenarioRequestImpl value,
    $Res Function(_$CreateAlternativeScenarioRequestImpl) then,
  ) = __$$CreateAlternativeScenarioRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? description,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    Set<int> failedCourseIds,
    CreateTimetableRequest? timetableRequest,
    int? existingTimetableId,
    int? orderIndex,
  });

  @override
  $CreateTimetableRequestCopyWith<$Res>? get timetableRequest;
}

/// @nodoc
class __$$CreateAlternativeScenarioRequestImplCopyWithImpl<$Res>
    extends
        _$CreateAlternativeScenarioRequestCopyWithImpl<
          $Res,
          _$CreateAlternativeScenarioRequestImpl
        >
    implements _$$CreateAlternativeScenarioRequestImplCopyWith<$Res> {
  __$$CreateAlternativeScenarioRequestImplCopyWithImpl(
    _$CreateAlternativeScenarioRequestImpl _value,
    $Res Function(_$CreateAlternativeScenarioRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? failedCourseIds = null,
    Object? timetableRequest = freezed,
    Object? existingTimetableId = freezed,
    Object? orderIndex = freezed,
  }) {
    return _then(
      _$CreateAlternativeScenarioRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        failedCourseIds: null == failedCourseIds
            ? _value._failedCourseIds
            : failedCourseIds // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
        timetableRequest: freezed == timetableRequest
            ? _value.timetableRequest
            : timetableRequest // ignore: cast_nullable_to_non_nullable
                  as CreateTimetableRequest?,
        existingTimetableId: freezed == existingTimetableId
            ? _value.existingTimetableId
            : existingTimetableId // ignore: cast_nullable_to_non_nullable
                  as int?,
        orderIndex: freezed == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateAlternativeScenarioRequestImpl
    implements _CreateAlternativeScenarioRequest {
  const _$CreateAlternativeScenarioRequestImpl({
    required this.name,
    this.description,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> failedCourseIds = const <int>{},
    this.timetableRequest,
    this.existingTimetableId,
    this.orderIndex,
  }) : _failedCourseIds = failedCourseIds;

  factory _$CreateAlternativeScenarioRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateAlternativeScenarioRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? description;
  final Set<int> _failedCourseIds;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds {
    if (_failedCourseIds is EqualUnmodifiableSetView) return _failedCourseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_failedCourseIds);
  }

  @override
  final CreateTimetableRequest? timetableRequest;
  @override
  final int? existingTimetableId;
  @override
  final int? orderIndex;

  @override
  String toString() {
    return 'CreateAlternativeScenarioRequest(name: $name, description: $description, failedCourseIds: $failedCourseIds, timetableRequest: $timetableRequest, existingTimetableId: $existingTimetableId, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAlternativeScenarioRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._failedCourseIds,
              _failedCourseIds,
            ) &&
            (identical(other.timetableRequest, timetableRequest) ||
                other.timetableRequest == timetableRequest) &&
            (identical(other.existingTimetableId, existingTimetableId) ||
                other.existingTimetableId == existingTimetableId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    const DeepCollectionEquality().hash(_failedCourseIds),
    timetableRequest,
    existingTimetableId,
    orderIndex,
  );

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAlternativeScenarioRequestImplCopyWith<
    _$CreateAlternativeScenarioRequestImpl
  >
  get copyWith =>
      __$$CreateAlternativeScenarioRequestImplCopyWithImpl<
        _$CreateAlternativeScenarioRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateAlternativeScenarioRequestImplToJson(this);
  }
}

abstract class _CreateAlternativeScenarioRequest
    implements CreateAlternativeScenarioRequest {
  const factory _CreateAlternativeScenarioRequest({
    required final String name,
    final String? description,
    @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
    final Set<int> failedCourseIds,
    final CreateTimetableRequest? timetableRequest,
    final int? existingTimetableId,
    final int? orderIndex,
  }) = _$CreateAlternativeScenarioRequestImpl;

  factory _CreateAlternativeScenarioRequest.fromJson(
    Map<String, dynamic> json,
  ) = _$CreateAlternativeScenarioRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: intSetFromJson, toJson: intSetToJson)
  Set<int> get failedCourseIds;
  @override
  CreateTimetableRequest? get timetableRequest;
  @override
  int? get existingTimetableId;
  @override
  int? get orderIndex;

  /// Create a copy of CreateAlternativeScenarioRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAlternativeScenarioRequestImplCopyWith<
    _$CreateAlternativeScenarioRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

StartRegistrationRequest _$StartRegistrationRequestFromJson(
  Map<String, dynamic> json,
) {
  return _StartRegistrationRequest.fromJson(json);
}

/// @nodoc
mixin _$StartRegistrationRequest {
  int get scenarioId => throw _privateConstructorUsedError;

  /// Serializes this StartRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartRegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartRegistrationRequestCopyWith<StartRegistrationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartRegistrationRequestCopyWith<$Res> {
  factory $StartRegistrationRequestCopyWith(
    StartRegistrationRequest value,
    $Res Function(StartRegistrationRequest) then,
  ) = _$StartRegistrationRequestCopyWithImpl<$Res, StartRegistrationRequest>;
  @useResult
  $Res call({int scenarioId});
}

/// @nodoc
class _$StartRegistrationRequestCopyWithImpl<
  $Res,
  $Val extends StartRegistrationRequest
>
    implements $StartRegistrationRequestCopyWith<$Res> {
  _$StartRegistrationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartRegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scenarioId = null}) {
    return _then(
      _value.copyWith(
            scenarioId: null == scenarioId
                ? _value.scenarioId
                : scenarioId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartRegistrationRequestImplCopyWith<$Res>
    implements $StartRegistrationRequestCopyWith<$Res> {
  factory _$$StartRegistrationRequestImplCopyWith(
    _$StartRegistrationRequestImpl value,
    $Res Function(_$StartRegistrationRequestImpl) then,
  ) = __$$StartRegistrationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int scenarioId});
}

/// @nodoc
class __$$StartRegistrationRequestImplCopyWithImpl<$Res>
    extends
        _$StartRegistrationRequestCopyWithImpl<
          $Res,
          _$StartRegistrationRequestImpl
        >
    implements _$$StartRegistrationRequestImplCopyWith<$Res> {
  __$$StartRegistrationRequestImplCopyWithImpl(
    _$StartRegistrationRequestImpl _value,
    $Res Function(_$StartRegistrationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartRegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scenarioId = null}) {
    return _then(
      _$StartRegistrationRequestImpl(
        scenarioId: null == scenarioId
            ? _value.scenarioId
            : scenarioId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartRegistrationRequestImpl implements _StartRegistrationRequest {
  const _$StartRegistrationRequestImpl({required this.scenarioId});

  factory _$StartRegistrationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartRegistrationRequestImplFromJson(json);

  @override
  final int scenarioId;

  @override
  String toString() {
    return 'StartRegistrationRequest(scenarioId: $scenarioId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartRegistrationRequestImpl &&
            (identical(other.scenarioId, scenarioId) ||
                other.scenarioId == scenarioId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, scenarioId);

  /// Create a copy of StartRegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartRegistrationRequestImplCopyWith<_$StartRegistrationRequestImpl>
  get copyWith =>
      __$$StartRegistrationRequestImplCopyWithImpl<
        _$StartRegistrationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartRegistrationRequestImplToJson(this);
  }
}

abstract class _StartRegistrationRequest implements StartRegistrationRequest {
  const factory _StartRegistrationRequest({required final int scenarioId}) =
      _$StartRegistrationRequestImpl;

  factory _StartRegistrationRequest.fromJson(Map<String, dynamic> json) =
      _$StartRegistrationRequestImpl.fromJson;

  @override
  int get scenarioId;

  /// Create a copy of StartRegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartRegistrationRequestImplCopyWith<_$StartRegistrationRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
