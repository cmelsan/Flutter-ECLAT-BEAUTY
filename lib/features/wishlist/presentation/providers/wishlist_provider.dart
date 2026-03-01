import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../../domain/entities/wishlist_item.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(ref.watch(supabaseClientProvider));
});


/// Wishlist state
class WishlistNotifier extends StateNotifier<List<WishlistItem>> {
  final WishlistRepository _repo;
  final Set<String> _productIds = {};

  WishlistNotifier(this._repo) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getWishlist();
    result.fold(
      (_) {},
      (items) {
        state = items;
        _productIds.clear();
        _productIds.addAll(items.map((i) => i.productId));
      },
    );
  }

  bool isInWishlist(String productId) => _productIds.contains(productId);

  Future<void> toggle(String productId) async {
    if (isInWishlist(productId)) {
      await _repo.removeFromWishlist(productId);
      _productIds.remove(productId);
      state = state.where((i) => i.productId != productId).toList();
    } else {
      await _repo.addToWishlist(productId);
      await _load(); // Reload to get full data with product join
    }
  }

  Future<void> refresh() => _load();
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishlistItem>>((ref) {
  // Watch auth state to re-initialize when user logs in/out
  ref.watch(authProvider);
  return WishlistNotifier(ref.watch(wishlistRepositoryProvider));
});

/// Check if a specific product is in wishlist
final isInWishlistProvider = Provider.family<bool, String>((ref, productId) {
  final wishlist = ref.watch(wishlistProvider);
  return wishlist.any((item) => item.productId == productId);
});
