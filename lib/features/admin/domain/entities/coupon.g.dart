// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponImpl _$$CouponImplFromJson(Map<String, dynamic> json) => _$CouponImpl(
  id: json['id'] as String,
  code: json['code'] as String,
  description: json['description'] as String?,
  discountType: json['discount_type'] as String? ?? 'percentage',
  discountValue: (json['discount_value'] as num).toDouble(),
  minPurchaseAmount: (json['min_purchase_amount'] as num?)?.toDouble() ?? 0,
  maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
  isActive: json['is_active'] as bool? ?? true,
  validFrom: json['valid_from'] == null
      ? null
      : DateTime.parse(json['valid_from'] as String),
  validUntil: json['valid_until'] == null
      ? null
      : DateTime.parse(json['valid_until'] as String),
  currentUses: (json['current_uses'] as num?)?.toInt() ?? 0,
  maxUses: (json['max_uses'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CouponImplToJson(_$CouponImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'description': instance.description,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'min_purchase_amount': instance.minPurchaseAmount,
      'max_discount_amount': instance.maxDiscountAmount,
      'is_active': instance.isActive,
      'valid_from': instance.validFrom?.toIso8601String(),
      'valid_until': instance.validUntil?.toIso8601String(),
      'current_uses': instance.currentUses,
      'max_uses': instance.maxUses,
    };
