import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    @JsonKey(name: 'product_id') required String productId,
    required String name,
    required int price, // original price in cents
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    required int quantity,
    required int stock,
    String? image,
  }) = _CartItem;

  /// Effective unit price
  int get effectivePrice => discountedPrice ?? price;

  /// Line total in cents
  int get lineTotal => effectivePrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
abstract class AppliedCoupon with _$AppliedCoupon {
  const factory AppliedCoupon({
    required String id,
    required String code,
    @JsonKey(name: 'discount_type') required String discountType,
    @JsonKey(name: 'discount_value') required int discountValue,
    @JsonKey(name: 'max_discount_amount') int? maxDiscountAmount,
    @JsonKey(name: 'discount_amount') required int discountAmount,
  }) = _AppliedCoupon;

  factory AppliedCoupon.fromJson(Map<String, dynamic> json) =>
      _$AppliedCouponFromJson(json);
}
