import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required int id,
    required int userId,
    required int courseId,
    String? courseName,
    String? professor,
    required int priority,
    DateTime? addedAt,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => _$WishlistItemFromJson(json);
}
