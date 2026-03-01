import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for synchronizing local cart with backend
/// 
/// This service handles:
/// - Syncing local cart to backend `carts` table
/// - Migrating guest cart to authenticated user cart
/// - Keeping cart in sync between local and remote
class CartSyncService {
  final SupabaseClient _supabase;

  CartSyncService(this._supabase);

  /// Sync local cart items to backend
  /// 
  /// If user is authenticated: uses user_id
  /// If user is guest: uses session_id
  Future<void> syncToBackend({
    required List<Map<String, dynamic>> items,
    String? userId,
    String? sessionId,
  }) async {
    try {
      if (userId == null && sessionId == null) {
        throw Exception('Either userId or sessionId must be provided');
      }

      // Clear existing cart items for this user/session
      await _clearBackendCart(userId: userId, sessionId: sessionId);

      // Insert all items
      if (items.isNotEmpty) {
        final cartItems = items.map((item) {
          final cartItem = <String, dynamic>{
            'product_id': item['product_id'],
            'quantity': item['quantity'],
          };

          if (userId != null) {
            cartItem['user_id'] = userId;
          } else if (sessionId != null) {
            cartItem['session_id'] = sessionId;
          }

          return cartItem;
        }).toList();

        await _supabase.from('carts').insert(cartItems);
      }
    } on PostgrestException catch (e) {
      throw Exception('Failed to sync cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sync cart: $e');
    }
  }

  /// Fetch cart from backend
  /// 
  /// Returns list of cart items with product information
  Future<List<Map<String, dynamic>>> fetchFromBackend({
    String? userId,
    String? sessionId,
  }) async {
    try {
      if (userId == null && sessionId == null) {
        return [];
      }

      dynamic query = _supabase.from('carts').select('''
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

  /// Migrate guest cart to authenticated user
  /// 
  /// Called when a guest user logs in or registers
  /// Uses RPC function to atomically merge carts
  Future<Map<String, dynamic>> migrateGuestToUser({
    required String sessionId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'migrate_guest_cart_to_user',
        params: {
          'p_session_id': sessionId,
          'p_user_id': userId,
        },
      );

      return response as Map<String, dynamic>;
    } on PostgrestException catch (e) {
      throw Exception('Failed to migrate cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to migrate cart: $e');
    }
  }

  /// Add single item to backend cart
  /// 
  /// If item exists, updates quantity
  /// If item doesn't exist, creates new entry
  Future<Map<String, dynamic>> addItemToBackend({
    required String productId,
    required int quantity,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // Check if item already exists
      dynamic existingQuery = _supabase
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
        final response = await _supabase.from('carts').insert({
          'product_id': productId,
          'quantity': quantity,
          'user_id': ?userId,
          'session_id': ?sessionId,
        }).select().single();

        return response;
      }
    } on PostgrestException catch (e) {
      throw Exception('Failed to add to cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Update quantity of item in backend
  Future<Map<String, dynamic>> updateItemQuantity({
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
      throw Exception('Failed to update quantity: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  /// Remove item from backend cart
  Future<void> removeItemFromBackend(String cartItemId) async {
    try {
      await _supabase.from('carts').delete().eq('id', cartItemId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to remove item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  /// Clear all items from backend cart
  Future<void> clearBackendCart({
    String? userId,
    String? sessionId,
  }) async {
    await _clearBackendCart(userId: userId, sessionId: sessionId);
  }

  /// Internal method to clear cart
  Future<void> _clearBackendCart({
    String? userId,
    String? sessionId,
  }) async {
    try {
      dynamic query = _supabase.from('carts').delete();

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

  /// Get total item count from backend
  Future<int> getCartCount({
    String? userId,
    String? sessionId,
  }) async {
    try {
      dynamic query = _supabase.from('carts').select('quantity');

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

  /// Merge local cart with backend cart
  /// 
  /// Strategy:
  /// 1. Fetch backend cart
  /// 2. For each local item:
  ///    - If exists in backend: take max quantity
  ///    - If not in backend: add it
  /// 3. Sync merged result back to backend
  Future<List<Map<String, dynamic>>> mergeLocalWithBackend({
    required List<Map<String, dynamic>> localItems,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // Fetch backend cart
      final backendItems = await fetchFromBackend(
        userId: userId,
        sessionId: sessionId,
      );

      // Create map for easy lookup
      final backendMap = <String, Map<String, dynamic>>{};
      for (final item in backendItems) {
        final productId = item['product_id'] as String;
        backendMap[productId] = item;
      }

      // Merge logic
      final mergedItems = <Map<String, dynamic>>[];

      // Add/update local items
      for (final localItem in localItems) {
        final productId = localItem['product_id'] as String;
        final localQty = localItem['quantity'] as int;

        if (backendMap.containsKey(productId)) {
          // Item exists in both - take max quantity
          final backendQty = backendMap[productId]!['quantity'] as int;
          mergedItems.add({
            'product_id': productId,
            'quantity': localQty > backendQty ? localQty : backendQty,
          });
          backendMap.remove(productId); // Mark as processed
        } else {
          // Item only in local
          mergedItems.add(localItem);
        }
      }

      // Add remaining backend items not in local
      mergedItems.addAll(backendMap.values.map((item) => {
            'product_id': item['product_id'],
            'quantity': item['quantity'],
          }));

      // Sync merged result back to backend
      await syncToBackend(
        items: mergedItems,
        userId: userId,
        sessionId: sessionId,
      );

      return mergedItems;
    } catch (e) {
      throw Exception('Failed to merge carts: $e');
    }
  }
}
