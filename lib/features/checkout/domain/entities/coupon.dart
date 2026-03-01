import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
abstract class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    String? description,
    @JsonKey(name: 'discount_type') required String discountType, // 'percentage' | 'fixed'
    @JsonKey(name: 'discount_value') required int discountValue, // cents or %
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'current_uses') @Default(0) int currentUses,
    @JsonKey(name: 'min_purchase_amount') int? minPurchaseAmount, // cents
    @JsonKey(name: 'max_discount_amount') int? maxDiscountAmount, // cents
    @JsonKey(name: 'applicable_categories') List<String>? applicableCategories,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) =>
      _$CouponFromJson(json);
}
