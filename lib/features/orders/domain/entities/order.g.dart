// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  orderNumber: json['order_number'] as String,
  userId: json['user_id'] as String?,
  guestEmail: json['guest_email'] as String?,
  customerName: json['customer_name'] as String?,
  status: json['status'] as String,
  totalAmount: (json['total_amount'] as num).toInt(),
  shippingAddress: json['shipping_address'] as Map<String, dynamic>?,
  couponId: json['coupon_id'] as String?,
  discountAmount: (json['discount_amount'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deliveredAt: json['delivered_at'] == null
      ? null
      : DateTime.parse(json['delivered_at'] as String),
  returnInitiatedAt: json['return_initiated_at'] == null
      ? null
      : DateTime.parse(json['return_initiated_at'] as String),
  returnDeadlineAt: json['return_deadline_at'] == null
      ? null
      : DateTime.parse(json['return_deadline_at'] as String),
  returnReason: json['return_reason'] as String?,
  returnAddress: json['return_address'] as Map<String, dynamic>?,
  orderItems:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'user_id': instance.userId,
      'guest_email': instance.guestEmail,
      'customer_name': instance.customerName,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'shipping_address': instance.shippingAddress,
      'coupon_id': instance.couponId,
      'discount_amount': instance.discountAmount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'return_initiated_at': instance.returnInitiatedAt?.toIso8601String(),
      'return_deadline_at': instance.returnDeadlineAt?.toIso8601String(),
      'return_reason': instance.returnReason,
      'return_address': instance.returnAddress,
      'order_items': instance.orderItems,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceAtPurchase: (json['price_at_purchase'] as num).toInt(),
      returnStatus: json['return_status'] as String?,
      product: json['product'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'price_at_purchase': instance.priceAtPurchase,
      'return_status': instance.returnStatus,
      'product': instance.product,
    };

_$OrderStatusHistoryImpl _$$OrderStatusHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusHistoryImpl(
  id: json['id'] as String,
  orderId: json['order_id'] as String?,
  fromStatus: json['from_status'] as String?,
  toStatus: json['to_status'] as String,
  changedBy: json['changed_by'] as String?,
  changedByType: json['changed_by_type'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$OrderStatusHistoryImplToJson(
  _$OrderStatusHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'from_status': instance.fromStatus,
  'to_status': instance.toStatus,
  'changed_by': instance.changedBy,
  'changed_by_type': instance.changedByType,
  'notes': instance.notes,
  'created_at': instance.createdAt?.toIso8601String(),
};
