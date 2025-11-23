import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final remoteDataSource = ref.watch(wishlistRemoteDataSourceProvider);
  return WishlistRepositoryImpl(remoteDataSource);
});

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _remoteDataSource;

  WishlistRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<WishlistItem>> getWishlist() async {
    return await _remoteDataSource.getWishlist();
  }

  @override
  Future<WishlistItem> addToWishlist(int courseId, int priority) async {
    return await _remoteDataSource.addToWishlist(courseId, priority);
  }

  @override
  Future<void> removeFromWishlist(int itemId) async {
    return await _remoteDataSource.removeFromWishlist(itemId);
  }

  @override
  Future<void> updatePriority(int itemId, int priority) async {
    return await _remoteDataSource.updatePriority(itemId, priority);
  }
}
