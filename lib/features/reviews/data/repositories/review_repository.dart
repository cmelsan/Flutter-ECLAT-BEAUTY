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
          .select('*')
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      final reviews = data as List;

      // Fetch profile emails separately — there is no direct FK from reviews to profiles
      await _attachProfiles(reviews);

      return Right(
        reviews.map((e) => Review.fromJson(e)).toList(),
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
          .select('*')
          .eq('product_id', productId)
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        return const Right(null);
      }

      // Attach profile email
      await _attachProfiles([data]);

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
      // Mirror the logic from the original web app (can-review.ts):
      // Only allow reviews after delivery (and post-delivery statuses)
      final reviewableStatuses = [
        'delivered',
        'return_requested',
        'returned',
        'partially_returned',
        'refunded',
        'partially_refunded',
      ];

      // 1. Find user's orders with a reviewable status
      final purchasesResponse = await _client
          .from('orders')
          .select('id')
          .eq('user_id', userId)
          .inFilter('status', reviewableStatuses);

      final purchases = purchasesResponse as List;
      if (purchases.isEmpty) {
        return const Right(false);
      }

      // 2. Check if product is in any of those delivered orders
      final orderIds = purchases.map((o) => o['id'] as String).toList();
      final orderItemsResponse = await _client
          .from('order_items')
          .select('order_id')
          .eq('product_id', productId)
          .inFilter('order_id', orderIds)
          .limit(1);

      final orderItems = orderItemsResponse as List;
      if (orderItems.isEmpty) {
        return const Right(false);
      }

      // 3. Check if user already reviewed this product
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
      }).select('*').single();

      // Attach profile email
      await _attachProfiles([data]);

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
          .select('*')
          .single();

      // Attach profile email
      await _attachProfiles([data]);

      return Right(Review.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Batch-fetch profiles for a list of review maps and attach as 'profile' key.
  /// Falls back silently if profiles can't be fetched (RLS, etc.).
  Future<void> _attachProfiles(List<dynamic> reviews) async {
    if (reviews.isEmpty) return;
    try {
      final userIds = reviews
          .map((r) => r['user_id'] as String)
          .toSet()
          .toList();
      final profilesData = await _client
          .from('profiles')
          .select('id, email')
          .inFilter('id', userIds);
      final profileMap = <String, Map<String, dynamic>>{};
      for (final p in (profilesData as List)) {
        profileMap[p['id'] as String] = p;
      }
      for (final review in reviews) {
        final uid = review['user_id'] as String;
        review['profile'] = profileMap[uid];
      }
    } catch (_) {
      // Non-critical: if profiles can't be fetched, reviews still display with generic names
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
