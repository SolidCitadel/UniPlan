import 'package:freezed_annotation/freezed_annotation.dart';
import 'course.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required Course course,
    required int priority,
    @Default(false) bool isSelected,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => _$WishlistItemFromJson(json);
}
