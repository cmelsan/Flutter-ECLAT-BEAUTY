import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Wishlist table operations
class WishlistDataSource {
  final SupabaseClient _supabase;

  WishlistDataSource(this._supabase);

  /// Fetch user's wishlist
  Future<List<Map<String, dynamic>>> fetchWishlist(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('''
            *,
            product:products(
              *,
              category:categories!products_category_id_fkey(id, name, slug),
              brand:brands!products_brand_id_fkey(id, name, slug, logo)
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch wishlist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to check wishlist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check wishlist: $e');
    }
  }

  /// Add product to wishlist
  Future<Map<String, dynamic>> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .insert({
            'user_id': userId,
            'product_id': productId,
          })
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation - already in wishlist
        throw Exception('Producto ya está en tu lista de deseos');
      }
      throw Exception('Failed to add to wishlist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _supabase
          .from('wishlist')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  /// Toggle product in wishlist (add if not exists, remove if exists)
  Future<bool> toggleWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final isInList = await isInWishlist(
        userId: userId,
        productId: productId,
      );

      if (isInList) {
        await removeFromWishlist(userId: userId, productId: productId);
        return false; // Removed
      } else {
        await addToWishlist(userId: userId, productId: productId);
        return true; // Added
      }
    } catch (e) {
      throw Exception('Failed to toggle wishlist: $e');
    }
  }

  /// Clear entire wishlist
  Future<void> clearWishlist(String userId) async {
    try {
      await _supabase.from('wishlist').delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to clear wishlist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to clear wishlist: $e');
    }
  }

  /// Get wishlist count
  Future<int> getWishlistCount(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('*')
          .eq('user_id', userId)
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get wishlist count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get wishlist count: $e');
    }
  }

  /// Get product IDs in wishlist (lightweight query)
  Future<List<String>> getWishlistProductIds(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('product_id')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['product_id'] as String)
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to get wishlist product IDs: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get wishlist product IDs: $e');
    }
  }
}
