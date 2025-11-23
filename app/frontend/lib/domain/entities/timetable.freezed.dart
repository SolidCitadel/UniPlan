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

 int get id; String get name; int get openingYear; String get semester; List<int> get excludedCourseIds; List<TimetableItem> get items;
/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableCopyWith<Timetable> get copyWith => _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&const DeepCollectionEquality().equals(other.excludedCourseIds, excludedCourseIds)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,openingYear,semester,const DeepCollectionEquality().hash(excludedCourseIds),const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Timetable(id: $id, name: $name, openingYear: $openingYear, semester: $semester, excludedCourseIds: $excludedCourseIds, items: $items)';
}


}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res>  {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) = _$TimetableCopyWithImpl;
@useResult
$Res call({
 int id, String name, int openingYear, String semester, List<int> excludedCourseIds, List<TimetableItem> items
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? excludedCourseIds = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,excludedCourseIds: null == excludedCourseIds ? _self.excludedCourseIds : excludedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItem>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int openingYear,  String semester,  List<int> excludedCourseIds,  List<TimetableItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.excludedCourseIds,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int openingYear,  String semester,  List<int> excludedCourseIds,  List<TimetableItem> items)  $default,) {final _that = this;
switch (_that) {
case _Timetable():
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.excludedCourseIds,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int openingYear,  String semester,  List<int> excludedCourseIds,  List<TimetableItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.id,_that.name,_that.openingYear,_that.semester,_that.excludedCourseIds,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Timetable implements Timetable {
  const _Timetable({required this.id, required this.name, required this.openingYear, required this.semester, final  List<int> excludedCourseIds = const [], final  List<TimetableItem> items = const []}): _excludedCourseIds = excludedCourseIds,_items = items;
  factory _Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);

@override final  int id;
@override final  String name;
@override final  int openingYear;
@override final  String semester;
 final  List<int> _excludedCourseIds;
@override@JsonKey() List<int> get excludedCourseIds {
  if (_excludedCourseIds is EqualUnmodifiableListView) return _excludedCourseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedCourseIds);
}

 final  List<TimetableItem> _items;
@override@JsonKey() List<TimetableItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timetable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingYear, openingYear) || other.openingYear == openingYear)&&(identical(other.semester, semester) || other.semester == semester)&&const DeepCollectionEquality().equals(other._excludedCourseIds, _excludedCourseIds)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,openingYear,semester,const DeepCollectionEquality().hash(_excludedCourseIds),const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Timetable(id: $id, name: $name, openingYear: $openingYear, semester: $semester, excludedCourseIds: $excludedCourseIds, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TimetableCopyWith<$Res> implements $TimetableCopyWith<$Res> {
  factory _$TimetableCopyWith(_Timetable value, $Res Function(_Timetable) _then) = __$TimetableCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int openingYear, String semester, List<int> excludedCourseIds, List<TimetableItem> items
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? openingYear = null,Object? semester = null,Object? excludedCourseIds = null,Object? items = null,}) {
  return _then(_Timetable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingYear: null == openingYear ? _self.openingYear : openingYear // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,excludedCourseIds: null == excludedCourseIds ? _self._excludedCourseIds : excludedCourseIds // ignore: cast_nullable_to_non_nullable
as List<int>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TimetableItem>,
  ));
}


}


/// @nodoc
mixin _$TimetableItem {

 int get id; int get courseId; String get courseName; String get professor; String? get classroom; List<ClassTime> get classTimes;
/// Create a copy of TimetableItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableItemCopyWith<TimetableItem> get copyWith => _$TimetableItemCopyWithImpl<TimetableItem>(this as TimetableItem, _$identity);

  /// Serializes this TimetableItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other.classTimes, classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,classroom,const DeepCollectionEquality().hash(classTimes));

@override
String toString() {
  return 'TimetableItem(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class $TimetableItemCopyWith<$Res>  {
  factory $TimetableItemCopyWith(TimetableItem value, $Res Function(TimetableItem) _then) = _$TimetableItemCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String courseName, String professor, String? classroom, List<ClassTime> classTimes
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? classroom = freezed,Object? classTimes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self.classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  String? classroom,  List<ClassTime> classTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classroom,_that.classTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String professor,  String? classroom,  List<ClassTime> classTimes)  $default,) {final _that = this;
switch (_that) {
case _TimetableItem():
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classroom,_that.classTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String courseName,  String professor,  String? classroom,  List<ClassTime> classTimes)?  $default,) {final _that = this;
switch (_that) {
case _TimetableItem() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.professor,_that.classroom,_that.classTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableItem implements TimetableItem {
  const _TimetableItem({required this.id, required this.courseId, required this.courseName, required this.professor, this.classroom, final  List<ClassTime> classTimes = const []}): _classTimes = classTimes;
  factory _TimetableItem.fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String courseName;
@override final  String professor;
@override final  String? classroom;
 final  List<ClassTime> _classTimes;
@override@JsonKey() List<ClassTime> get classTimes {
  if (_classTimes is EqualUnmodifiableListView) return _classTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classTimes);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableItem&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other._classTimes, _classTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,professor,classroom,const DeepCollectionEquality().hash(_classTimes));

@override
String toString() {
  return 'TimetableItem(id: $id, courseId: $courseId, courseName: $courseName, professor: $professor, classroom: $classroom, classTimes: $classTimes)';
}


}

/// @nodoc
abstract mixin class _$TimetableItemCopyWith<$Res> implements $TimetableItemCopyWith<$Res> {
  factory _$TimetableItemCopyWith(_TimetableItem value, $Res Function(_TimetableItem) _then) = __$TimetableItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String courseName, String professor, String? classroom, List<ClassTime> classTimes
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? professor = null,Object? classroom = freezed,Object? classTimes = null,}) {
  return _then(_TimetableItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,classroom: freezed == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String?,classTimes: null == classTimes ? _self._classTimes : classTimes // ignore: cast_nullable_to_non_nullable
as List<ClassTime>,
  ));
}


}


/// @nodoc
mixin _$ClassTime {

 String get day; String get startTime; String get endTime;
/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassTimeCopyWith<ClassTime> get copyWith => _$ClassTimeCopyWithImpl<ClassTime>(this as ClassTime, _$identity);

  /// Serializes this ClassTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassTime&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTime(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $ClassTimeCopyWith<$Res>  {
  factory $ClassTimeCopyWith(ClassTime value, $Res Function(ClassTime) _then) = _$ClassTimeCopyWithImpl;
@useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class _$ClassTimeCopyWithImpl<$Res>
    implements $ClassTimeCopyWith<$Res> {
  _$ClassTimeCopyWithImpl(this._self, this._then);

  final ClassTime _self;
  final $Res Function(ClassTime) _then;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassTime].
extension ClassTimePatterns on ClassTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassTime value)  $default,){
final _that = this;
switch (_that) {
case _ClassTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassTime value)?  $default,){
final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String day,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String day,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _ClassTime():
return $default(_that.day,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String day,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _ClassTime() when $default != null:
return $default(_that.day,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassTime implements ClassTime {
  const _ClassTime({required this.day, required this.startTime, required this.endTime});
  factory _ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);

@override final  String day;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassTimeCopyWith<_ClassTime> get copyWith => __$ClassTimeCopyWithImpl<_ClassTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassTime&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,startTime,endTime);

@override
String toString() {
  return 'ClassTime(day: $day, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ClassTimeCopyWith<$Res> implements $ClassTimeCopyWith<$Res> {
  factory _$ClassTimeCopyWith(_ClassTime value, $Res Function(_ClassTime) _then) = __$ClassTimeCopyWithImpl;
@override @useResult
$Res call({
 String day, String startTime, String endTime
});




}
/// @nodoc
class __$ClassTimeCopyWithImpl<$Res>
    implements _$ClassTimeCopyWith<$Res> {
  __$ClassTimeCopyWithImpl(this._self, this._then);

  final _ClassTime _self;
  final $Res Function(_ClassTime) _then;

/// Create a copy of ClassTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_ClassTime(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
