// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timetable {

 int get id; int get userId; String get name; int get openingYear; String get semester; DateTime get createdAt; DateTime get updatedAt; List<TimetableItem> get items; List<int> get excludedCourseIds;
/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableCopyWith<Timetable> get copyWith => _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.excludedCourseIds, excludedCourseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,openingYear,semester,createdAt,updatedAt,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(excludedCourseIds));

@override
String toString() {
  return 'Timetable(id: $id, userId: $userId, name: $name, openingYear: $openingYear, semester: $semester, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, excludedCourseIds: $excludedCourseIds)';
}


}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res>  {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) = _$TimetableCopyWithImpl;
@useResult
$Res call({
 int id, int userId, String name, int openingYear, String semester, DateTime createdAt, DateTime updatedAt, List<TimetableItem> items, List<int> excludedCourseIds
});




}
/// @nodoc
class _$TimetableCopyWithImpl<$Res>
    implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._self, this._then);

  final Timetable _self;
  final $Res Function(Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? createdAt = null,Object? updatedAt = null,Object? items = null,Object? excludedCourseIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItem>,excludedCourseIds: null == excludedCourseIds ? _self.excludedCourseIds : excludedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [Timetable].
extension TimetablePatterns on Timetable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Timetable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Timetable value)  $default,){
final _that = this;
switch (_that) {
case _Timetable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Timetable value)?  $default,){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  String name,  int openingYear,  String semester,  DateTime createdAt,  DateTime updatedAt,  List<TimetableItem> items,  List<int> excludedCourseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.openingYear,_that.semester,_that.createdAt,_that.updatedAt,_that.items,_that.excludedCourseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  String name,  int openingYear,  String semester,  DateTime createdAt,  DateTime updatedAt,  List<TimetableItem> items,  List<int> excludedCourseIds)  $default,) {final _that = this;
switch (_that) {
case _Timetable():
return $default(_that.id,_that.userId,_that.name,_that.openingYear,_that.semester,_that.createdAt,_that.updatedAt,_that.items,_that.excludedCourseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  String name,  int openingYear,  String semester,  DateTime createdAt,  DateTime updatedAt,  List<TimetableItem> items,  List<int> excludedCourseIds)?  $default,) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.openingYear,_that.semester,_that.createdAt,_that.updatedAt,_that.items,_that.excludedCourseIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Timetable implements Timetable {
  const _Timetable({required this.id, required this.userId, required this.name, required this.openingYear, required this.semester, required this.createdAt, required this.updatedAt, final  List<TimetableItem> items = const [], final  List<int> excludedCourseIds = const []}): _items = items,_excludedCourseIds = excludedCourseIds;
  factory _Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);

@override final  int id;
@override final  int userId;
@override final  String name;
@override final  int openingYear;
@override final  String semester;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<TimetableItem> _items;
@override@JsonKey() List<TimetableItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<int> _excludedCourseIds;
@override@JsonKey() List<int> get excludedCourseIds {
  if (_excludedCourseIds is EqualUnmodifiableListView) return _excludedCourseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedCourseIds);
}


/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableCopyWith<_Timetable> get copyWith => __$TimetableCopyWithImpl<_Timetable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._excludedCourseIds, _excludedCourseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,openingYear,semester,createdAt,updatedAt,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_excludedCourseIds));

@override
String toString() {
  return 'Timetable(id: $id, userId: $userId, name: $name, openingYear: $openingYear, semester: $semester, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, excludedCourseIds: $excludedCourseIds)';
}


}

/// @nodoc
abstract mixin class _$TimetableCopyWith<$Res> implements $TimetableCopyWith<$Res> {
  factory _$TimetableCopyWith(_Timetable value, $Res Function(_Timetable) _then) = __$TimetableCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, String name, int openingYear, String semester, DateTime createdAt, DateTime updatedAt, List<TimetableItem> items, List<int> excludedCourseIds
});




}
/// @nodoc
class __$TimetableCopyWithImpl<$Res>
    implements _$TimetableCopyWith<$Res> {
  __$TimetableCopyWithImpl(this._self, this._then);

  final _Timetable _self;
  final $Res Function(_Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? createdAt = null,Object? updatedAt = null,Object? items = null,Object? excludedCourseIds = null,}) {
  return _then(_Timetable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItem>,excludedCourseIds: null == excludedCourseIds ? _self._excludedCourseIds : excludedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$TimetableItem {

 int get id; int get courseId; String? get courseCode; String? get courseName; String? get professor; int? get credits; String? get classroom; String? get campus; List<ClassTime> get classTimes; DateTime? get addedAt;
/// Create a copy of TimetableItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableItemCopyWith<TimetableItem> get copyWith => _$TimetableItemCopyWithImpl<TimetableItem>(this as TimetableItem, _$identity);

  /// Serializes this TimetableItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&const DeepCollectionEquality().equals(other.classTimes, classTimes)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseCode,courseName,professor,credits,classroom,campus,const DeepCollectionEquality().hash(classTimes),addedAt);

@override
String toString() {
  return 'TimetableItem(id: $id, courseId: $courseId, courseCode: $courseCode, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, classTimes: $classTimes, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $TimetableItemCopyWith<$Res>  {
  factory $TimetableItemCopyWith(TimetableItem value, $Res Function(TimetableItem) _then) = _$TimetableItemCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String? courseCode, String? courseName, String? professor, int? credits, String? classroom, String? campus, List<ClassTime> classTimes, DateTime? addedAt
});




}
/// @nodoc
class _$TimetableItemCopyWithImpl<$Res>
    implements $TimetableItemCopyWith<$Res> {
  _$TimetableItemCopyWithImpl(this._self, this._then);

  final TimetableItem _self;
  final $Res Function(TimetableItem) _then;

/// Create a copy of TimetableItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseCode = freezed,Object? courseName = freezed,Object? professor = freezed,Object? credits = freezed,Object? classroom = freezed,Object? campus = freezed,Object? classTimes = null,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseCode: freezed == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String?,courseName: freezed == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String?,professor: freezed == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String?,credits: freezed == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int?,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self.classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableItem].
extension TimetableItemPatterns on TimetableItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableItem value)  $default,){
final _that = this;
switch (_that) {
case _TimetableItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableItem value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String? courseCode,  String? courseName,  String? professor,  int? credits,  String? classroom,  String? campus,  List<ClassTime> classTimes,  DateTime? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
return $default(_that.id,_that.courseId,_that.courseCode,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.classTimes,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String? courseCode,  String? courseName,  String? professor,  int? credits,  String? classroom,  String? campus,  List<ClassTime> classTimes,  DateTime? addedAt)  $default,) {final _that = this;
switch (_that) {
case _TimetableItem():
return $default(_that.id,_that.courseId,_that.courseCode,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.classTimes,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String? courseCode,  String? courseName,  String? professor,  int? credits,  String? classroom,  String? campus,  List<ClassTime> classTimes,  DateTime? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
return $default(_that.id,_that.courseId,_that.courseCode,_that.courseName,_that.professor,_that.credits,_that.classroom,_that.campus,_that.classTimes,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableItem implements TimetableItem {
  const _TimetableItem({required this.id, required this.courseId, this.courseCode, this.courseName, this.professor, this.credits, this.classroom, this.campus, final  List<ClassTime> classTimes = const [], this.addedAt}): _classTimes = classTimes;
  factory _TimetableItem.fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String? courseCode;
@override final  String? courseName;
@override final  String? professor;
@override final  int? credits;
@override final  String? classroom;
@override final  String? campus;
 final  List<ClassTime> _classTimes;
@override@JsonKey() List<ClassTime> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}

@override final  DateTime? addedAt;

/// Create a copy of TimetableItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableItemCopyWith<_TimetableItem> get copyWith => __$TimetableItemCopyWithImpl<_TimetableItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.campus, campus) || other.campus == campus)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseCode,courseName,professor,credits,classroom,campus,const DeepCollectionEquality().hash(_classTimes),addedAt);

@override
String toString() {
  return 'TimetableItem(id: $id, courseId: $courseId, courseCode: $courseCode, courseName: $courseName, professor: $professor, credits: $credits, classroom: $classroom, campus: $campus, classTimes: $classTimes, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$TimetableItemCopyWith<$Res> implements $TimetableItemCopyWith<$Res> {
  factory _$TimetableItemCopyWith(_TimetableItem value, $Res Function(_TimetableItem) _then) = __$TimetableItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String? courseCode, String? courseName, String? professor, int? credits, String? classroom, String? campus, List<ClassTime> classTimes, DateTime? addedAt
});




}
/// @nodoc
class __$TimetableItemCopyWithImpl<$Res>
    implements _$TimetableItemCopyWith<$Res> {
  __$TimetableItemCopyWithImpl(this._self, this._then);

  final _TimetableItem _self;
  final $Res Function(_TimetableItem) _then;

/// Create a copy of TimetableItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseCode = freezed,Object? courseName = freezed,Object? professor = freezed,Object? credits = freezed,Object? classroom = freezed,Object? campus = freezed,Object? classTimes = null,Object? addedAt = freezed,}) {
  return _then(_TimetableItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseCode: freezed == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String?,courseName: freezed == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String?,professor: freezed == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String?,credits: freezed == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int?,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self._classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
