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
    );

Map<String, dynamic> _$WishlistItemDtoToJson(_WishlistItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'priority': instance.priority,
    };
