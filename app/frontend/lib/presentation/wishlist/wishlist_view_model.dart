import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../data/repositories/wishlist_repository_impl.dart';

final wishlistProvider = AsyncNotifierProvider<WishlistViewModel, List<WishlistItem>>(() {
  return WishlistViewModel();
});

class WishlistViewModel extends AsyncNotifier<List<WishlistItem>> {
  @override
  Future<List<WishlistItem>> build() async {
    return _fetchWishlist();
  }

  Future<List<WishlistItem>> _fetchWishlist() async {
    return await ref.read(wishlistRepositoryProvider).getWishlist();
  }

  Future<void> fetchWishlist() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWishlist());
  }

  Future<void> addToWishlist(int courseId, int priority) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(wishlistRepositoryProvider).addToWishlist(courseId, priority);
      return _fetchWishlist();
    });
  }

  Future<void> removeFromWishlist(int itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(wishlistRepositoryProvider).removeFromWishlist(itemId);
      return _fetchWishlist();
    });
  }

  Future<void> updatePriority(int itemId, int priority) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(wishlistRepositoryProvider).updatePriority(itemId, priority);
      return _fetchWishlist();
    });
  }
}
