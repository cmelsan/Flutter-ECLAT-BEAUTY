// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      discountedPrice: (json['discounted_price'] as num?)?.toInt(),
      quantity: (json['quantity'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'discounted_price': instance.discountedPrice,
      'quantity': instance.quantity,
      'stock': instance.stock,
      'image': instance.image,
    };

_$AppliedCouponImpl _$$AppliedCouponImplFromJson(Map<String, dynamic> json) =>
    _$AppliedCouponImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discount_type'] as String,
      discountValue: (json['discount_value'] as num).toInt(),
      maxDiscountAmount: (json['max_discount_amount'] as num?)?.toInt(),
      discountAmount: (json['discount_amount'] as num).toInt(),
    );

Map<String, dynamic> _$$AppliedCouponImplToJson(_$AppliedCouponImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'max_discount_amount': instance.maxDiscountAmount,
      'discount_amount': instance.discountAmount,
    };
