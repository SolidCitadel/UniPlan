import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/entities/course.dart';

// Mock implementation for now as backend might not have wishlist endpoint yet
final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSource();
});

class WishlistRemoteDataSource {
  // In-memory storage for prototype
  final List<WishlistItem> _mockWishlist = [];

  Future<List<WishlistItem>> getWishlist() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockWishlist;
  }

  Future<void> addToWishlist(Course course, int priority) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_mockWishlist.any((item) => item.course.id == course.id)) {
      throw Exception('Course already in wishlist');
    }
    _mockWishlist.add(WishlistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      course: course,
      priority: priority,
    ));
  }

  Future<void> removeFromWishlist(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockWishlist.removeWhere((item) => item.id == itemId);
  }

  Future<void> updatePriority(String itemId, int priority) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockWishlist.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _mockWishlist[index] = _mockWishlist[index].copyWith(priority: priority);
    }
  }
}
