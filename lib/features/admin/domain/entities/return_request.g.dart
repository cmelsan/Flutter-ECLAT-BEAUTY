// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReturnRequestImpl _$$ReturnRequestImplFromJson(Map<String, dynamic> json) =>
    _$ReturnRequestImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      returnStatus: json['return_status'] as String?,
      returnReason: json['return_reason'] as String?,
      returnRequestedAt: json['return_requested_at'] == null
          ? null
          : DateTime.parse(json['return_requested_at'] as String),
      returnProcessedAt: json['return_processed_at'] == null
          ? null
          : DateTime.parse(json['return_processed_at'] as String),
      order: json['order'] as Map<String, dynamic>?,
      product: json['product'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReturnRequestImplToJson(_$ReturnRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'return_status': instance.returnStatus,
      'return_reason': instance.returnReason,
      'return_requested_at': instance.returnRequestedAt?.toIso8601String(),
      'return_processed_at': instance.returnProcessedAt?.toIso8601String(),
      'order': instance.order,
      'product': instance.product,
    };
