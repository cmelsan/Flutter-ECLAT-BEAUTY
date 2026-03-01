import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item.dart';

class CartRepository {
  final SupabaseClient _client;

  CartRepository(this._client);

  /// Get or create a session ID for guest users
  Future<String> getSessionId() async {
    final box = Hive.box('app_settings');
    var sessionId = box.get('session_id') as String?;
    if (sessionId == null) {
      sessionId = const Uuid().v4();
      await box.put('session_id', sessionId);
    }
    return sessionId;
  }

  /// Sync cart to Supabase (upsert)
  Future<Either<Failure, void>> syncCartToSupabase(
    List<CartItem> items,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      final sessionId = userId == null ? await getSessionId() : null;

      final cartData = {
        'items': items.map((item) => item.toJson()).toList(),
        'expires_at': DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String(),
      };

      if (userId != null) {
        cartData['user_id'] = userId;
        // Upsert by user_id
        await _client.from('carts').upsert(
          {...cartData, 'user_id': userId},
          onConflict: 'user_id',
        );
      } else if (sessionId != null) {
        cartData['session_id'] = sessionId;
        await _client.from('carts').upsert(
          {...cartData, 'session_id': sessionId},
          onConflict: 'session_id',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Load cart from Supabase
  Future<Either<Failure, List<CartItem>>> loadCartFromSupabase() async {
    try {
      final userId = _client.auth.currentUser?.id;
      final sessionId = userId == null ? await getSessionId() : null;

      Map<String, dynamic>? cart;

      if (userId != null) {
        cart = await _client
            .from('carts')
            .select()
            .eq('user_id', userId)
            .maybeSingle();
      } else if (sessionId != null) {
        cart = await _client
            .from('carts')
            .select()
            .eq('session_id', sessionId)
            .maybeSingle();
      }

      if (cart == null || cart['items'] == null) {
        return const Right([]);
      }

      final items = (cart['items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Migrate guest cart to user on login
  Future<Either<Failure, void>> migrateGuestCart(String userId) async {
    try {
      final sessionId = await getSessionId();
      await _client.rpc('migrate_guest_cart_to_user', params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
      });
      return const Right(null);
    } catch (e) {
      // Not critical if this fails
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Validate stock for a product
  Future<Either<Failure, int>> checkStock(String productId) async {
    try {
      final data = await _client
          .from('products')
          .select('stock')
          .eq('id', productId)
          .single();
      return Right(data['stock'] as int);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
