import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'user_id') required String userId,
    required int rating, // 1-5
    String? comment,
    @JsonKey(name: 'is_verified_purchase') @Default(false) bool isVerifiedPurchase,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined user data
    Map<String, dynamic>? profile,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
