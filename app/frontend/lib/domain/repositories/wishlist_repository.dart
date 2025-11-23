import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<WishlistItem> addToWishlist(int courseId, int priority);
  Future<void> removeFromWishlist(int courseId);
  Future<WishlistItem> changePriority(int courseId, int priority);
}
