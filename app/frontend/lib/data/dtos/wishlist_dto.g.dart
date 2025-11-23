// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItemDto _$WishlistItemDtoFromJson(Map<String, dynamic> json) =>
    _WishlistItemDto(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      professor: json['professor'] as String,
      priority: (json['priority'] as num).toInt(),
      classroom: json['classroom'] as String?,
      classTimes:
          (json['classTimes'] as List<dynamic>?)
              ?.map(
                (e) => WishlistClassTimeDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WishlistItemDtoToJson(_WishlistItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'priority': instance.priority,
      'classroom': instance.classroom,
      'classTimes': instance.classTimes,
    };

_WishlistClassTimeDto _$WishlistClassTimeDtoFromJson(
  Map<String, dynamic> json,
) => _WishlistClassTimeDto(
  day: json['day'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$WishlistClassTimeDtoToJson(
  _WishlistClassTimeDto instance,
) => <String, dynamic>{
  'day': instance.day,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
};
