import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_dto.freezed.dart';
part 'wishlist_dto.g.dart';

@freezed
abstract class WishlistItemDto with _$WishlistItemDto {
  const factory WishlistItemDto({
    required int id,
    required int courseId,
    required String courseName,
    required String professor,
    required int priority,
  }) = _WishlistItemDto;

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) => _$WishlistItemDtoFromJson(json);
}
