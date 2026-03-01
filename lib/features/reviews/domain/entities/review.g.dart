// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  userId: json['user_id'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  isVerifiedPurchase: json['is_verified_purchase'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  profile: json['profile'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'user_id': instance.userId,
      'rating': instance.rating,
      'comment': instance.comment,
      'is_verified_purchase': instance.isVerifiedPurchase,
      'created_at': instance.createdAt?.toIso8601String(),
      'profile': instance.profile,
    };
