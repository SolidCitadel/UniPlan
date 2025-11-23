import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/wishlist_dto.dart';

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSource(ref.watch(dioProvider));
});

class WishlistRemoteDataSource {
  WishlistRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<WishlistItemDto>> getWishlist() async {
    final resp = await _dio.get(ApiEndpoints.wishlist);
    final data = resp.data as List;
    return data.map((e) => WishlistItemDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<WishlistItemDto> addToWishlist(int courseId, int priority) async {
    final resp = await _dio.post(ApiEndpoints.wishlist, data: {
      'courseId': courseId,
      'priority': priority,
    });
    return WishlistItemDto.fromJson(resp.data);
  }

  Future<void> removeFromWishlist(int courseId) async {
    await _dio.delete('${ApiEndpoints.wishlist}/$courseId');
  }
}
