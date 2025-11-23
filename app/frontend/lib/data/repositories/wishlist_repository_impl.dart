import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../mappers/wishlist_mapper.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(ref.watch(wishlistRemoteDataSourceProvider));
});

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl(this._remote);

  final WishlistRemoteDataSource _remote;

  @override
  Future<List<WishlistItem>> getWishlist() async {
    final dtos = await _remote.getWishlist();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<WishlistItem> addToWishlist(int courseId, int priority) async {
    final dto = await _remote.addToWishlist(courseId, priority);
    return dto.toDomain();
  }

  @override
  Future<void> removeFromWishlist(int courseId) {
    return _remote.removeFromWishlist(courseId);
  }

  @override
  Future<WishlistItem> changePriority(int courseId, int priority) async {
    try {
      await _remote.removeFromWishlist(courseId);
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) rethrow;
    }
    return addToWishlist(courseId, priority);
  }
}
