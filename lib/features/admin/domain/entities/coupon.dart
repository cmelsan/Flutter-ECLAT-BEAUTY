// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    String? description,
    @JsonKey(name: 'discount_type') @Default('percentage') String discountType,
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'min_purchase_amount') @Default(0) double minPurchaseAmount,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'current_uses') @Default(0) int currentUses,
    @JsonKey(name: 'max_uses') int? maxUses,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
