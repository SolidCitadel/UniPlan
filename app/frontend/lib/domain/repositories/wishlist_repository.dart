import '../entities/wishlist_item.dart';
import '../entities/course.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<void> addToWishlist(Course course, int priority);
  Future<void> removeFromWishlist(String itemId);
  Future<void> updatePriority(String itemId, int priority);
}
