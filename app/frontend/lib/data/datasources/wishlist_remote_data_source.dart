import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_provider.dart';
import '../../domain/entities/wishlist_item.dart';

// Assuming there is a wishlist endpoint; adjust API path as needed
final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSource(ref.watch(dioProvider));
});

class WishlistRemoteDataSource {
  final Dio _dio;

  WishlistRemoteDataSource(this._dio);

  Future<List<WishlistItem>> getWishlist() async {
    try {
      // Adjust endpoint when backend implements wishlist
      // For now, return empty list or throw unimplemented
      // final response = await _dio.get(
      //   '/api/v1/wishlist',
      //   options: Options(headers: {'Authorization': 'Bearer $token'}),
      // );
      // final data = response.data as List;
      // return data.map((json) => WishlistItem.fromJson(json)).toList();
      
      return []; // Temporary until backend implements wishlist
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }

  Future<WishlistItem> addToWishlist(int courseId, int priority) async {
    try {
      // Adjust endpoint when backend implements wishlist
      throw UnimplementedError('Wishlist API not implemented yet');
      // final response = await _dio.post(
      //   '/api/v1/wishlist',
      //   data: {
      //     'courseId': courseId,
      //     'priority': priority,
      //   },
      //   options: Options(headers: {'Authorization': 'Bearer $token'}),
      // );
      // return WishlistItem.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int itemId) async {
    try {
      // Adjust endpoint when backend implements wishlist
      throw UnimplementedError('Wishlist API not implemented yet');
      // await _dio.delete(
      //   '/api/v1/wishlist/$itemId',
      //   options: Options(headers: {'Authorization': 'Bearer $token'}),
      // );
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  Future<void> updatePriority(int itemId, int priority) async {
    try {
      // Adjust endpoint when backend implements wishlist
      throw Exception('Wishlist API not implemented yet');
      // await _dio.patch(
      //   '/api/v1/wishlist/$itemId',
      //   data: {'priority': priority},
      //   options: Options(headers: {'Authorization': 'Bearer $token'}),
      // );
    } catch (e) {
      throw Exception('Failed to update priority: $e');
    }
  }
}
