import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_rating.dart';
import '../providers/review_provider.dart';
import 'rating_stars.dart';
import '../../../../core/theme/app_colors.dart';

class ProductRatingWidget extends ConsumerWidget {
  final String productId;
  final bool compact;

  const ProductRatingWidget({
    super.key,
    required this.productId,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAsync = ref.watch(productRatingProvider(productId));

    return ratingAsync.when(
      data: (rating) {
        if (rating == null || rating.totalReviews == 0) {
          return const Text(
            'Sin opiniones',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          );
        }

        if (compact) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingStars(
                rating: rating.avgRating,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${rating.avgRating.toStringAsFixed(1)} (${rating.totalReviews})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }

        return _FullRatingWidget(rating: rating);
      },
      loading: () => const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FullRatingWidget extends StatelessWidget {
  final ProductRating rating;

  const _FullRatingWidget({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              rating.avgRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingStars(
                    rating: rating.avgRating,
                    size: 24,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rating.totalReviews} ${rating.totalReviews == 1 ? 'opinión' : 'opiniones'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RatingDistribution(distribution: rating.ratingDistribution),
      ],
    );
  }
}

class _RatingDistribution extends StatelessWidget {
  final Map<String, int> distribution;

  const _RatingDistribution({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    
    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: List.generate(5, (index) {
        final stars = 5 - index;
        final count = distribution[stars.toString()] ?? 0;
        final percentage = total > 0 ? (count / total) : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    Text(
                      '$stars',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 30,
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
