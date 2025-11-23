import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wishlist_item.dart';
import '../../data/repositories/wishlist_repository_impl.dart';

final wishlistViewModelProvider =
    AsyncNotifierProvider<WishlistViewModel, List<WishlistItem>>(
  WishlistViewModel.new,
);

class WishlistViewModel extends AsyncNotifier<List<WishlistItem>> {
  @override
  Future<List<WishlistItem>> build() async {
    return _fetch();
  }

  Future<List<WishlistItem>> _fetch() async {
    return ref.read(wishlistRepositoryProvider).getWishlist();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> add(int courseId, int priority) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(wishlistRepositoryProvider);
      await repo.addToWishlist(courseId, priority);
      return _fetch();
    });
  }

  Future<void> remove(int courseId) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(wishlistRepositoryProvider);
      await repo.removeFromWishlist(courseId);
      return _fetch();
    });
  }

  Future<void> movePriority(WishlistItem item, int priority) async {
    if (item.priority == priority) return;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(wishlistRepositoryProvider);
      await repo.changePriority(item.courseId, priority);
      return _fetch();
    });
  }
}
