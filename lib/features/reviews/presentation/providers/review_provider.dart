import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/product_rating.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(supabaseClientProvider));
});

/// Reviews for a specific product
final productReviewsProvider =
    FutureProvider.autoDispose.family<List<Review>, String>((ref, productId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getProductReviews(productId);
  return result.fold((f) => [], (reviews) => reviews);
});

/// Rating summary for a specific product
final productRatingProvider =
    FutureProvider.autoDispose.family<ProductRating?, String>((ref, productId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getProductRating(productId);
  return result.fold((f) => null, (rating) => rating);
});

/// User's review for a specific product
final userReviewProvider =
    FutureProvider.autoDispose.family<Review?, String>((ref, productId) async {
  final client = ref.watch(supabaseClientProvider);
  final userId = client.auth.currentUser?.id;
  
  if (userId == null) return null;
  
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getUserReview(
    productId: productId,
    userId: userId,
  );
  return result.fold((f) => null, (review) => review);
});

/// Check if user can review a product
final canUserReviewProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, productId) async {
  final client = ref.watch(supabaseClientProvider);
  final userId = client.auth.currentUser?.id;
  
  if (userId == null) return false;
  
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.canUserReview(
    productId: productId,
    userId: userId,
  );
  return result.fold((f) => false, (canReview) => canReview);
});

