import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_rating.freezed.dart';
part 'product_rating.g.dart';

@freezed
class ProductRating with _$ProductRating {
  const factory ProductRating({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'avg_rating') required double avgRating,
    @JsonKey(name: 'total_reviews') required int totalReviews,
    @JsonKey(name: 'rating_distribution') required Map<String, int> ratingDistribution,
  }) = _ProductRating;

  factory ProductRating.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingFromJson(json);
}
