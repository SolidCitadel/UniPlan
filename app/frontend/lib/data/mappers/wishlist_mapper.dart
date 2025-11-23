import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_dto.dart';

extension WishlistItemDtoMapper on WishlistItemDto {
  WishlistItem toDomain() => WishlistItem(
        id: id,
        courseId: courseId,
        courseName: courseName,
        professor: professor,
        priority: priority,
      );
}
