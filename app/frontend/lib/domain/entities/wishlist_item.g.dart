// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) =>
    _WishlistItem(
      id: json['id'] as String,
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      priority: (json['priority'] as num).toInt(),
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$WishlistItemToJson(_WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'priority': instance.priority,
      'isSelected': instance.isSelected,
    };
