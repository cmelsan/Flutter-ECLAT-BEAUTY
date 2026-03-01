import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;
  final int? totalReviews;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showRating = false,
    this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          if (rating >= starValue) {
            // Full star
            return Icon(
              Icons.star,
              size: size,
              color: starColor,
            );
          } else if (rating >= starValue - 0.5) {
            // Half star
            return Icon(
              Icons.star_half,
              size: size,
              color: starColor,
            );
          } else {
            // Empty star
            return Icon(
              Icons.star_border,
              size: size,
              color: starColor,
            );
          }
        }),
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.875,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (totalReviews != null) ...[
            Text(
              ' ($totalReviews)',
              style: TextStyle(
                fontSize: size * 0.75,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ],
    );
  }
}
