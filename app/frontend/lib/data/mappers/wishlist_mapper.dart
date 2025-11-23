import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_dto.dart';

extension WishlistItemDtoMapper on WishlistItemDto {
  WishlistItem toDomain() => WishlistItem(
        id: id,
        courseId: courseId,
        courseName: courseName,
        professor: professor,
        priority: priority,
        classroom: classroom,
        classTimes: classTimes.map((e) => e.toDomain()).toList(),
      );
}

extension WishlistClassTimeDtoMapper on WishlistClassTimeDto {
  ClassTime toDomain() => ClassTime(
        day: day,
        startTime: startTime,
        endTime: endTime,
      );
}
