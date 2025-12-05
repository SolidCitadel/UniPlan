// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClassTime _$ClassTimeFromJson(Map<String, dynamic> json) {
  return _ClassTime.fromJson(json);
}

/// @nodoc
mixin _$ClassTime {
  String get day => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this ClassTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassTimeCopyWith<ClassTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassTimeCopyWith<$Res> {
  factory $ClassTimeCopyWith(ClassTime value, $Res Function(ClassTime) then) =
      _$ClassTimeCopyWithImpl<$Res, ClassTime>;
  @useResult
  $Res call({String day, String startTime, String endTime});
}

/// @nodoc
class _$ClassTimeCopyWithImpl<$Res, $Val extends ClassTime>
    implements $ClassTimeCopyWith<$Res> {
  _$ClassTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassTimeImplCopyWith<$Res>
    implements $ClassTimeCopyWith<$Res> {
  factory _$$ClassTimeImplCopyWith(
    _$ClassTimeImpl value,
    $Res Function(_$ClassTimeImpl) then,
  ) = __$$ClassTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String day, String startTime, String endTime});
}

/// @nodoc
class __$$ClassTimeImplCopyWithImpl<$Res>
    extends _$ClassTimeCopyWithImpl<$Res, _$ClassTimeImpl>
    implements _$$ClassTimeImplCopyWith<$Res> {
  __$$ClassTimeImplCopyWithImpl(
    _$ClassTimeImpl _value,
    $Res Function(_$ClassTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(
      _$ClassTimeImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassTimeImpl implements _ClassTime {
  const _$ClassTimeImpl({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory _$ClassTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassTimeImplFromJson(json);

  @override
  final String day;
  @override
  final String startTime;
  @override
  final String endTime;

  @override
  String toString() {
    return 'ClassTime(day: $day, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassTimeImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, day, startTime, endTime);

  /// Create a copy of ClassTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassTimeImplCopyWith<_$ClassTimeImpl> get copyWith =>
      __$$ClassTimeImplCopyWithImpl<_$ClassTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassTimeImplToJson(this);
  }
}

abstract class _ClassTime implements ClassTime {
  const factory _ClassTime({
    required final String day,
    required final String startTime,
    required final String endTime,
  }) = _$ClassTimeImpl;

  factory _ClassTime.fromJson(Map<String, dynamic> json) =
      _$ClassTimeImpl.fromJson;

  @override
  String get day;
  @override
  String get startTime;
  @override
  String get endTime;

  /// Create a copy of ClassTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassTimeImplCopyWith<_$ClassTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimetableItem _$TimetableItemFromJson(Map<String, dynamic> json) {
  return _TimetableItem.fromJson(json);
}

/// @nodoc
mixin _$TimetableItem {
  int get id => throw _privateConstructorUsedError;
  int get courseId => throw _privateConstructorUsedError;
  String? get courseCode => throw _privateConstructorUsedError;
  String? get courseName => throw _privateConstructorUsedError;
  String? get professor => throw _privateConstructorUsedError;
  int? get credits => throw _privateConstructorUsedError;
  String? get classroom => throw _privateConstructorUsedError;
  String? get campus => throw _privateConstructorUsedError;
  List<ClassTime> get classTimes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get addedAt => throw _privateConstructorUsedError;

  /// Serializes this TimetableItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimetableItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimetableItemCopyWith<TimetableItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimetableItemCopyWith<$Res> {
  factory $TimetableItemCopyWith(
    TimetableItem value,
    $Res Function(TimetableItem) then,
  ) = _$TimetableItemCopyWithImpl<$Res, TimetableItem>;
  @useResult
  $Res call({
    int id,
    int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    List<ClassTime> classTimes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? addedAt,
  });
}

/// @nodoc
class _$TimetableItemCopyWithImpl<$Res, $Val extends TimetableItem>
    implements $TimetableItemCopyWith<$Res> {
  _$TimetableItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimetableItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? courseCode = freezed,
    Object? courseName = freezed,
    Object? professor = freezed,
    Object? credits = freezed,
    Object? classroom = freezed,
    Object? campus = freezed,
    Object? classTimes = null,
    Object? addedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as int,
            courseCode: freezed == courseCode
                ? _value.courseCode
                : courseCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            courseName: freezed == courseName
                ? _value.courseName
                : courseName // ignore: cast_nullable_to_non_nullable
                      as String?,
            professor: freezed == professor
                ? _value.professor
                : professor // ignore: cast_nullable_to_non_nullable
                      as String?,
            credits: freezed == credits
                ? _value.credits
                : credits // ignore: cast_nullable_to_non_nullable
                      as int?,
            classroom: freezed == classroom
                ? _value.classroom
                : classroom // ignore: cast_nullable_to_non_nullable
                      as String?,
            campus: freezed == campus
                ? _value.campus
                : campus // ignore: cast_nullable_to_non_nullable
                      as String?,
            classTimes: null == classTimes
                ? _value.classTimes
                : classTimes // ignore: cast_nullable_to_non_nullable
                      as List<ClassTime>,
            addedAt: freezed == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimetableItemImplCopyWith<$Res>
    implements $TimetableItemCopyWith<$Res> {
  factory _$$TimetableItemImplCopyWith(
    _$TimetableItemImpl value,
    $Res Function(_$TimetableItemImpl) then,
  ) = __$$TimetableItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    List<ClassTime> classTimes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? addedAt,
  });
}

/// @nodoc
class __$$TimetableItemImplCopyWithImpl<$Res>
    extends _$TimetableItemCopyWithImpl<$Res, _$TimetableItemImpl>
    implements _$$TimetableItemImplCopyWith<$Res> {
  __$$TimetableItemImplCopyWithImpl(
    _$TimetableItemImpl _value,
    $Res Function(_$TimetableItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimetableItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? courseCode = freezed,
    Object? courseName = freezed,
    Object? professor = freezed,
    Object? credits = freezed,
    Object? classroom = freezed,
    Object? campus = freezed,
    Object? classTimes = null,
    Object? addedAt = freezed,
  }) {
    return _then(
      _$TimetableItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as int,
        courseCode: freezed == courseCode
            ? _value.courseCode
            : courseCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        courseName: freezed == courseName
            ? _value.courseName
            : courseName // ignore: cast_nullable_to_non_nullable
                  as String?,
        professor: freezed == professor
            ? _value.professor
            : professor // ignore: cast_nullable_to_non_nullable
                  as String?,
        credits: freezed == credits
            ? _value.credits
            : credits // ignore: cast_nullable_to_non_nullable
                  as int?,
        classroom: freezed == classroom
            ? _value.classroom
            : classroom // ignore: cast_nullable_to_non_nullable
                  as String?,
        campus: freezed == campus
            ? _value.campus
            : campus // ignore: cast_nullable_to_non_nullable
                  as String?,
        classTimes: null == classTimes
            ? _value._classTimes
            : classTimes // ignore: cast_nullable_to_non_nullable
                  as List<ClassTime>,
        addedAt: freezed == addedAt
            ? _value.addedAt
            : addedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimetableItemImpl implements _TimetableItem {
  const _$TimetableItemImpl({
    required this.id,
    required this.courseId,
    this.courseCode,
    this.courseName,
    this.professor,
    this.credits,
    this.classroom,
    this.campus,
    final List<ClassTime> classTimes = const <ClassTime>[],
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.addedAt,
  }) : _classTimes = classTimes;

  factory _$TimetableItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimetableItemImplFromJson(json);

  @override
  final int id;
  @override
  final int courseId;
  @override
  final String? courseCode;
  @override
  final String? courseName;
  @override
  final String? professor;
  @override
  final int? credits;
  @override
  final String? classroom;
  @override
  final String? campus;
  final List<ClassTime> _classTimes;
  @override
  @JsonKey()
  List<ClassTime> get classTimes {
    if (_classTimes is EqualUnmodifiableListView) return _classTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classTimes);
  }

  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? addedAt;

  @override
  String toString() {
    return 'TimetableItem(id: $id, courseId: $courseId, courseCode: $courseCode, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, classTimes: $classTimes, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimetableItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseCode, courseCode) ||
                other.courseCode == courseCode) &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.professor, professor) ||
                other.professor == professor) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.classroom, classroom) ||
                other.classroom == classroom) &&
            (identical(other.campus, campus) || other.campus == campus) &&
            const DeepCollectionEquality().equals(
              other._classTimes,
              _classTimes,
            ) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    courseId,
    courseCode,
    courseName,
    professor,
    credits,
    classroom,
    campus,
    const DeepCollectionEquality().hash(_classTimes),
    addedAt,
  );

  /// Create a copy of TimetableItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimetableItemImplCopyWith<_$TimetableItemImpl> get copyWith =>
      __$$TimetableItemImplCopyWithImpl<_$TimetableItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimetableItemImplToJson(this);
  }
}

abstract class _TimetableItem implements TimetableItem {
  const factory _TimetableItem({
    required final int id,
    required final int courseId,
    final String? courseCode,
    final String? courseName,
    final String? professor,
    final int? credits,
    final String? classroom,
    final String? campus,
    final List<ClassTime> classTimes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? addedAt,
  }) = _$TimetableItemImpl;

  factory _TimetableItem.fromJson(Map<String, dynamic> json) =
      _$TimetableItemImpl.fromJson;

  @override
  int get id;
  @override
  int get courseId;
  @override
  String? get courseCode;
  @override
  String? get courseName;
  @override
  String? get professor;
  @override
  int? get credits;
  @override
  String? get classroom;
  @override
  String? get campus;
  @override
  List<ClassTime> get classTimes;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get addedAt;

  /// Create a copy of TimetableItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimetableItemImplCopyWith<_$TimetableItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimetableCourse _$TimetableCourseFromJson(Map<String, dynamic> json) {
  return _TimetableCourse.fromJson(json);
}

/// @nodoc
mixin _$TimetableCourse {
  int get courseId => throw _privateConstructorUsedError;
  String? get courseCode => throw _privateConstructorUsedError;
  String? get courseName => throw _privateConstructorUsedError;
  String? get professor => throw _privateConstructorUsedError;
  int? get credits => throw _privateConstructorUsedError;
  String? get classroom => throw _privateConstructorUsedError;
  String? get campus => throw _privateConstructorUsedError;
  List<ClassTime> get classTimes => throw _privateConstructorUsedError;

  /// Serializes this TimetableCourse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimetableCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimetableCourseCopyWith<TimetableCourse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimetableCourseCopyWith<$Res> {
  factory $TimetableCourseCopyWith(
    TimetableCourse value,
    $Res Function(TimetableCourse) then,
  ) = _$TimetableCourseCopyWithImpl<$Res, TimetableCourse>;
  @useResult
  $Res call({
    int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    List<ClassTime> classTimes,
  });
}

/// @nodoc
class _$TimetableCourseCopyWithImpl<$Res, $Val extends TimetableCourse>
    implements $TimetableCourseCopyWith<$Res> {
  _$TimetableCourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimetableCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? courseCode = freezed,
    Object? courseName = freezed,
    Object? professor = freezed,
    Object? credits = freezed,
    Object? classroom = freezed,
    Object? campus = freezed,
    Object? classTimes = null,
  }) {
    return _then(
      _value.copyWith(
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as int,
            courseCode: freezed == courseCode
                ? _value.courseCode
                : courseCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            courseName: freezed == courseName
                ? _value.courseName
                : courseName // ignore: cast_nullable_to_non_nullable
                      as String?,
            professor: freezed == professor
                ? _value.professor
                : professor // ignore: cast_nullable_to_non_nullable
                      as String?,
            credits: freezed == credits
                ? _value.credits
                : credits // ignore: cast_nullable_to_non_nullable
                      as int?,
            classroom: freezed == classroom
                ? _value.classroom
                : classroom // ignore: cast_nullable_to_non_nullable
                      as String?,
            campus: freezed == campus
                ? _value.campus
                : campus // ignore: cast_nullable_to_non_nullable
                      as String?,
            classTimes: null == classTimes
                ? _value.classTimes
                : classTimes // ignore: cast_nullable_to_non_nullable
                      as List<ClassTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimetableCourseImplCopyWith<$Res>
    implements $TimetableCourseCopyWith<$Res> {
  factory _$$TimetableCourseImplCopyWith(
    _$TimetableCourseImpl value,
    $Res Function(_$TimetableCourseImpl) then,
  ) = __$$TimetableCourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int courseId,
    String? courseCode,
    String? courseName,
    String? professor,
    int? credits,
    String? classroom,
    String? campus,
    List<ClassTime> classTimes,
  });
}

/// @nodoc
class __$$TimetableCourseImplCopyWithImpl<$Res>
    extends _$TimetableCourseCopyWithImpl<$Res, _$TimetableCourseImpl>
    implements _$$TimetableCourseImplCopyWith<$Res> {
  __$$TimetableCourseImplCopyWithImpl(
    _$TimetableCourseImpl _value,
    $Res Function(_$TimetableCourseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimetableCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? courseCode = freezed,
    Object? courseName = freezed,
    Object? professor = freezed,
    Object? credits = freezed,
    Object? classroom = freezed,
    Object? campus = freezed,
    Object? classTimes = null,
  }) {
    return _then(
      _$TimetableCourseImpl(
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as int,
        courseCode: freezed == courseCode
            ? _value.courseCode
            : courseCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        courseName: freezed == courseName
            ? _value.courseName
            : courseName // ignore: cast_nullable_to_non_nullable
                  as String?,
        professor: freezed == professor
            ? _value.professor
            : professor // ignore: cast_nullable_to_non_nullable
                  as String?,
        credits: freezed == credits
            ? _value.credits
            : credits // ignore: cast_nullable_to_non_nullable
                  as int?,
        classroom: freezed == classroom
            ? _value.classroom
            : classroom // ignore: cast_nullable_to_non_nullable
                  as String?,
        campus: freezed == campus
            ? _value.campus
            : campus // ignore: cast_nullable_to_non_nullable
                  as String?,
        classTimes: null == classTimes
            ? _value._classTimes
            : classTimes // ignore: cast_nullable_to_non_nullable
                  as List<ClassTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimetableCourseImpl implements _TimetableCourse {
  const _$TimetableCourseImpl({
    required this.courseId,
    this.courseCode,
    this.courseName,
    this.professor,
    this.credits,
    this.classroom,
    this.campus,
    final List<ClassTime> classTimes = const <ClassTime>[],
  }) : _classTimes = classTimes;

  factory _$TimetableCourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimetableCourseImplFromJson(json);

  @override
  final int courseId;
  @override
  final String? courseCode;
  @override
  final String? courseName;
  @override
  final String? professor;
  @override
  final int? credits;
  @override
  final String? classroom;
  @override
  final String? campus;
  final List<ClassTime> _classTimes;
  @override
  @JsonKey()
  List<ClassTime> get classTimes {
    if (_classTimes is EqualUnmodifiableListView) return _classTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classTimes);
  }

  @override
  String toString() {
    return 'TimetableCourse(courseId: $courseId, courseCode: $courseCode, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, classTimes: $classTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimetableCourseImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseCode, courseCode) ||
                other.courseCode == courseCode) &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.professor, professor) ||
                other.professor == professor) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.classroom, classroom) ||
                other.classroom == classroom) &&
            (identical(other.campus, campus) || other.campus == campus) &&
            const DeepCollectionEquality().equals(
              other._classTimes,
              _classTimes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    courseId,
    courseCode,
    courseName,
    professor,
    credits,
    classroom,
    campus,
    const DeepCollectionEquality().hash(_classTimes),
  );

  /// Create a copy of TimetableCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimetableCourseImplCopyWith<_$TimetableCourseImpl> get copyWith =>
      __$$TimetableCourseImplCopyWithImpl<_$TimetableCourseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimetableCourseImplToJson(this);
  }
}

abstract class _TimetableCourse implements TimetableCourse {
  const factory _TimetableCourse({
    required final int courseId,
    final String? courseCode,
    final String? courseName,
    final String? professor,
    final int? credits,
    final String? classroom,
    final String? campus,
    final List<ClassTime> classTimes,
  }) = _$TimetableCourseImpl;

  factory _TimetableCourse.fromJson(Map<String, dynamic> json) =
      _$TimetableCourseImpl.fromJson;

  @override
  int get courseId;
  @override
  String? get courseCode;
  @override
  String? get courseName;
  @override
  String? get professor;
  @override
  int? get credits;
  @override
  String? get classroom;
  @override
  String? get campus;
  @override
  List<ClassTime> get classTimes;

  /// Create a copy of TimetableCourse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimetableCourseImplCopyWith<_$TimetableCourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Timetable _$TimetableFromJson(Map<String, dynamic> json) {
  return _Timetable.fromJson(json);
}

/// @nodoc
mixin _$Timetable {
  int get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get openingYear => throw _privateConstructorUsedError;
  String get semester => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<TimetableItem> get items => throw _privateConstructorUsedError;
  List<TimetableCourse> get excludedCourses =>
      throw _privateConstructorUsedError;

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimetableCopyWith<Timetable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimetableCopyWith<$Res> {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) then) =
      _$TimetableCopyWithImpl<$Res, Timetable>;
  @useResult
  $Res call({
    int id,
    int? userId,
    String name,
    int openingYear,
    String semester,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? updatedAt,
    List<TimetableItem> items,
    List<TimetableCourse> excludedCourses,
  });
}

/// @nodoc
class _$TimetableCopyWithImpl<$Res, $Val extends Timetable>
    implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? openingYear = null,
    Object? semester = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? excludedCourses = null,
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
            openingYear: null == openingYear
                ? _value.openingYear
                : openingYear // ignore: cast_nullable_to_non_nullable
                      as int,
            semester: null == semester
                ? _value.semester
                : semester // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<TimetableItem>,
            excludedCourses: null == excludedCourses
                ? _value.excludedCourses
                : excludedCourses // ignore: cast_nullable_to_non_nullable
                      as List<TimetableCourse>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimetableImplCopyWith<$Res>
    implements $TimetableCopyWith<$Res> {
  factory _$$TimetableImplCopyWith(
    _$TimetableImpl value,
    $Res Function(_$TimetableImpl) then,
  ) = __$$TimetableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int? userId,
    String name,
    int openingYear,
    String semester,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? updatedAt,
    List<TimetableItem> items,
    List<TimetableCourse> excludedCourses,
  });
}

/// @nodoc
class __$$TimetableImplCopyWithImpl<$Res>
    extends _$TimetableCopyWithImpl<$Res, _$TimetableImpl>
    implements _$$TimetableImplCopyWith<$Res> {
  __$$TimetableImplCopyWithImpl(
    _$TimetableImpl _value,
    $Res Function(_$TimetableImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? openingYear = null,
    Object? semester = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? excludedCourses = null,
  }) {
    return _then(
      _$TimetableImpl(
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
        openingYear: null == openingYear
            ? _value.openingYear
            : openingYear // ignore: cast_nullable_to_non_nullable
                  as int,
        semester: null == semester
            ? _value.semester
            : semester // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<TimetableItem>,
        excludedCourses: null == excludedCourses
            ? _value._excludedCourses
            : excludedCourses // ignore: cast_nullable_to_non_nullable
                  as List<TimetableCourse>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimetableImpl implements _Timetable {
  const _$TimetableImpl({
    required this.id,
    this.userId,
    required this.name,
    required this.openingYear,
    required this.semester,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.updatedAt,
    final List<TimetableItem> items = const <TimetableItem>[],
    final List<TimetableCourse> excludedCourses = const <TimetableCourse>[],
  }) : _items = items,
       _excludedCourses = excludedCourses;

  factory _$TimetableImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimetableImplFromJson(json);

  @override
  final int id;
  @override
  final int? userId;
  @override
  final String name;
  @override
  final int openingYear;
  @override
  final String semester;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime? updatedAt;
  final List<TimetableItem> _items;
  @override
  @JsonKey()
  List<TimetableItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<TimetableCourse> _excludedCourses;
  @override
  @JsonKey()
  List<TimetableCourse> get excludedCourses {
    if (_excludedCourses is EqualUnmodifiableListView) return _excludedCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludedCourses);
  }

  @override
  String toString() {
    return 'Timetable(id: $id, userId: $userId, name: $name, openingYear: $openingYear, semester: $semester, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, excludedCourses: $excludedCourses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimetableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.openingYear, openingYear) ||
                other.openingYear == openingYear) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._excludedCourses,
              _excludedCourses,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    openingYear,
    semester,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_excludedCourses),
  );

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimetableImplCopyWith<_$TimetableImpl> get copyWith =>
      __$$TimetableImplCopyWithImpl<_$TimetableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimetableImplToJson(this);
  }
}

abstract class _Timetable implements Timetable {
  const factory _Timetable({
    required final int id,
    final int? userId,
    required final String name,
    required final int openingYear,
    required final String semester,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    final DateTime? updatedAt,
    final List<TimetableItem> items,
    final List<TimetableCourse> excludedCourses,
  }) = _$TimetableImpl;

  factory _Timetable.fromJson(Map<String, dynamic> json) =
      _$TimetableImpl.fromJson;

  @override
  int get id;
  @override
  int? get userId;
  @override
  String get name;
  @override
  int get openingYear;
  @override
  String get semester;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? get updatedAt;
  @override
  List<TimetableItem> get items;
  @override
  List<TimetableCourse> get excludedCourses;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimetableImplCopyWith<_$TimetableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
