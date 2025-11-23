import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required int id,
    required int courseId,
    required String courseName,
    required String professor,
    required int priority,
    String? classroom,
    @Default([]) List<ClassTime> classTimes,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => _$WishlistItemFromJson(json);
}

@freezed
abstract class ClassTime with _$ClassTime {
  const factory ClassTime({
    required String day,
    required String startTime,
    required String endTime,
  }) = _ClassTime;

  factory ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);
}
