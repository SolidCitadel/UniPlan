import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<WishlistItem> addToWishlist(int courseId, int priority);
  Future<void> removeFromWishlist(int itemId);
  Future<void> updatePriority(int itemId, int priority);
}
