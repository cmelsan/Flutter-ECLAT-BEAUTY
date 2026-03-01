// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductRatingImpl _$$ProductRatingImplFromJson(Map<String, dynamic> json) =>
    _$ProductRatingImpl(
      productId: json['product_id'] as String,
      avgRating: (json['avg_rating'] as num).toDouble(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      ratingDistribution: Map<String, int>.from(
        json['rating_distribution'] as Map,
      ),
    );

Map<String, dynamic> _$$ProductRatingImplToJson(_$ProductRatingImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'avg_rating': instance.avgRating,
      'total_reviews': instance.totalReviews,
      'rating_distribution': instance.ratingDistribution,
    };
