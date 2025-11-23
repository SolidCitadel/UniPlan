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
    String? classroom,
    @Default([]) List<WishlistClassTimeDto> classTimes,
  }) = _WishlistItemDto;

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) => _$WishlistItemDtoFromJson(json);
}

@freezed
abstract class WishlistClassTimeDto with _$WishlistClassTimeDto {
  const factory WishlistClassTimeDto({
    required String day,
    required String startTime,
    required String endTime,
  }) = _WishlistClassTimeDto;

  factory WishlistClassTimeDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistClassTimeDtoFromJson(json);
}
