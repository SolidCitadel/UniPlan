import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/wishlist_repository_impl.dart';

final wishlistProvider = StateNotifierProvider<WishlistViewModel, AsyncValue<List<WishlistItem>>>((ref) {
  return WishlistViewModel(ref);
});

class WishlistViewModel extends StateNotifier<AsyncValue<List<WishlistItem>>> {
  final Ref _ref;

  WishlistViewModel(this._ref) : super(const AsyncValue.loading()) {
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    state = const AsyncValue.loading();
    try {
      final items = await _ref.read(wishlistRepositoryProvider).getWishlist();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addToWishlist(Course course, int priority) async {
    try {
      await _ref.read(wishlistRepositoryProvider).addToWishlist(course, priority);
      await fetchWishlist(); // Refresh list
    } catch (e) {
      // Handle error (e.g. show snackbar via a separate error state or callback)
      // For now, just rethrow or log
      print('Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    try {
      await _ref.read(wishlistRepositoryProvider).removeFromWishlist(itemId);
      await fetchWishlist();
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  Future<void> updatePriority(String itemId, int priority) async {
    try {
      await _ref.read(wishlistRepositoryProvider).updatePriority(itemId, priority);
      await fetchWishlist();
    } catch (e) {
      print('Error updating priority: $e');
    }
  }
}
