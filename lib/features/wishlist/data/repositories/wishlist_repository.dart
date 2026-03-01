import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistRepository {
  final SupabaseClient _client;

  WishlistRepository(this._client);

  Future<Either<Failure, List<WishlistItem>>> getWishlist() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Right([]);

      final data = await _client
          .from('wishlist')
          .select('*, product:products(id, name, slug, price, images, stock)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return Right(
        (data as List).map((e) => WishlistItem.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addToWishlist(String productId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('Inicia sesión para usar favoritos'));
      }

      await _client.from('wishlist').insert({
        'user_id': userId,
        'product_id': productId,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Right(null);

      await _client
          .from('wishlist')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
