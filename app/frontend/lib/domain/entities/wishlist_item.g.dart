// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) =>
    _WishlistItem(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String?,
      professor: json['professor'] as String?,
      priority: (json['priority'] as num).toInt(),
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$WishlistItemToJson(_WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'professor': instance.professor,
      'priority': instance.priority,
      'addedAt': instance.addedAt?.toIso8601String(),
    };
