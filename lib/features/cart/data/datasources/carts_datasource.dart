import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Carts table operations
class CartsDataSource {
  final SupabaseClient _supabase;

  CartsDataSource(this._supabase);

  /// Fetch cart for current user or session
  Future<List<Map<String, dynamic>>> fetchCart({
    String? userId,
    String? sessionId,
  }) async {
    try {
      var query = _supabase.from('carts').select('''
            *,
            product:products(
              *,
              category:categories!products_category_id_fkey(id, name, slug),
              brand:brands!products_brand_id_fkey(id, name, slug, logo)
            )
          ''');

      if (userId != null) {
        query = query.eq('user_id', userId);
      } else if (sessionId != null) {
        query = query.eq('session_id', sessionId);
      }

      final response = await query;
      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  /// Add item to cart (or update quantity if exists)
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // Check if item already exists
      var existingQuery = _supabase
          .from('carts')
          .select('*')
          .eq('product_id', productId);

      if (userId != null) {
        existingQuery = existingQuery.eq('user_id', userId);
      } else if (sessionId != null) {
        existingQuery = existingQuery.eq('session_id', sessionId);
      }

      final existing = await existingQuery.maybeSingle();

      if (existing != null) {
        // Update quantity
        final newQuantity = (existing['quantity'] as int) + quantity;
        final response = await _supabase
            .from('carts')
            .update({'quantity': newQuantity})
            .eq('id', existing['id'])
            .select()
            .single();

        return response;
      } else {
        // Insert new item
        final response = await _supabase
            .from('carts')
            .insert({
              'product_id': productId,
              'quantity': quantity,
              'user_id': ?userId,
              'session_id': ?sessionId,
            })
            .select()
            .single();

        return response;
      }
    } on PostgrestException catch (e) {
      throw Exception('Failed to add to cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Update cart item quantity
  Future<Map<String, dynamic>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await _supabase
          .from('carts')
          .update({'quantity': quantity})
          .eq('id', cartItemId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to update cart item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _supabase.from('carts').delete().eq('id', cartItemId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to remove from cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  /// Clear entire cart
  Future<void> clearCart({
    String? userId,
    String? sessionId,
  }) async {
    try {
      var query = _supabase.from('carts').delete();

      if (userId != null) {
        query = query.eq('user_id', userId);
      } else if (sessionId != null) {
        query = query.eq('session_id', sessionId);
      }

      await query;
    } on PostgrestException catch (e) {
      throw Exception('Failed to clear cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  /// Sync local cart to backend
  Future<void> syncCart({
    required List<Map<String, dynamic>> items,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // Clear existing cart
      await clearCart(userId: userId, sessionId: sessionId);

      // Insert all items
      if (items.isNotEmpty) {
        final cartItems = items
            .map((item) => {
                  'product_id': item['product_id'],
                  'quantity': item['quantity'],
                  'user_id': ?userId,
                  'session_id': ?sessionId,
                })
            .toList();

        await _supabase.from('carts').insert(cartItems);
      }
    } on PostgrestException catch (e) {
      throw Exception('Failed to sync cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sync cart: $e');
    }
  }

  /// Get cart item count
  Future<int> getCartCount({
    String? userId,
    String? sessionId,
  }) async {
    try {
      var query = _supabase
          .from('carts')
          .select('quantity');

      if (userId != null) {
        query = query.eq('user_id', userId);
      } else if (sessionId != null) {
        query = query.eq('session_id', sessionId);
      }

      final response = await query;
      final items = response as List;

      return items.fold<int>(
        0,
        (sum, item) => sum + (item['quantity'] as int? ?? 0),
      );
    } on PostgrestException catch (e) {
      throw Exception('Failed to get cart count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cart count: $e');
    }
  }
}
