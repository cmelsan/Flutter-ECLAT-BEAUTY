import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/product_rating.dart';

class ReviewRepository {
  final SupabaseClient _client;

  ReviewRepository(this._client);

  Future<Either<Failure, List<Review>>> getProductReviews(
    String productId,
  ) async {
    try {
      final data = await _client
          .from('reviews')
          .select('*, profile:profiles(email, full_name)')
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      return Right(
        (data as List).map((e) => Review.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ProductRating?>> getProductRating(
    String productId,
  ) async {
    try {
      final data = await _client
          .from('product_ratings')
          .select()
          .eq('product_id', productId)
          .maybeSingle();

      if (data == null) {
        return const Right(null);
      }

      return Right(ProductRating.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Review?>> getUserReview({
    required String productId,
    required String userId,
  }) async {
    try {
      final data = await _client
          .from('reviews')
          .select('*, profile:profiles(email, full_name)')
          .eq('product_id', productId)
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        return const Right(null);
      }

      return Right(Review.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> canUserReview({
    required String productId,
    required String userId,
  }) async {
    try {
      // Check if user has purchased the product
      final hasPurchased = await _client.rpc(
        'user_has_purchased_product',
        params: {
          'p_user_id': userId,
          'p_product_id': productId,
        },
      );

      if (!hasPurchased) {
        return const Right(false);
      }

      // Check if user already reviewed
      final existingReview = await getUserReview(
        productId: productId,
        userId: userId,
      );

      return existingReview.fold(
        (failure) => Left(failure),
        (review) => Right(review == null),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Review>> addReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('Inicia sesión para dejar una opinión'));
      }

      final data = await _client.from('reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
        'comment': ?comment,
      }).select('*, profile:profiles(email, full_name)').single();

      return Right(Review.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Review>> updateReview({
    required String reviewId,
    required int rating,
    String? comment,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('Inicia sesión para actualizar la opinión'));
      }

      final data = await _client
          .from('reviews')
          .update({
            'rating': rating,
            'comment': comment,
          })
          .eq('id', reviewId)
          .eq('user_id', userId)
          .select('*, profile:profiles(email, full_name)')
          .single();

      return Right(Review.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('Inicia sesión para eliminar la opinión'));
      }

      await _client
          .from('reviews')
          .delete()
          .eq('id', reviewId)
          .eq('user_id', userId);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
