// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      invoiceNumber: json['invoice_number'] as String,
      orderId: json['order_id'] as String,
      referenceInvoiceId: json['reference_invoice_id'] as String?,
      creditNoteScope: json['credit_note_scope'] as String?,
      subtotal: (json['subtotal'] as num).toInt(),
      taxRate: json['tax_rate'] as num,
      taxAmount: (json['tax_amount'] as num).toInt(),
      discountAmount: (json['discount_amount'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num).toInt(),
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerAddress: json['customer_address'] as Map<String, dynamic>?,
      customerNif: json['customer_nif'] as String?,
      lineItems:
          (json['line_items'] as List<dynamic>?)
              ?.map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stripeRefundId: json['stripe_refund_id'] as String?,
      notes: json['notes'] as String?,
      issuedAt: json['issued_at'] == null
          ? null
          : DateTime.parse(json['issued_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      orders: json['orders'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'invoice_number': instance.invoiceNumber,
      'order_id': instance.orderId,
      'reference_invoice_id': instance.referenceInvoiceId,
      'credit_note_scope': instance.creditNoteScope,
      'subtotal': instance.subtotal,
      'tax_rate': instance.taxRate,
      'tax_amount': instance.taxAmount,
      'discount_amount': instance.discountAmount,
      'total_amount': instance.totalAmount,
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'customer_address': instance.customerAddress,
      'customer_nif': instance.customerNif,
      'line_items': instance.lineItems,
      'stripe_refund_id': instance.stripeRefundId,
      'notes': instance.notes,
      'issued_at': instance.issuedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'orders': instance.orders,
    };

_$InvoiceLineItemImpl _$$InvoiceLineItemImplFromJson(
  Map<String, dynamic> json,
) => _$InvoiceLineItemImpl(
  orderItemId: json['order_item_id'] as String?,
  productId: json['product_id'] as String?,
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPriceGross: (json['unit_price_gross'] as num).toInt(),
  unitPriceNet: (json['unit_price_net'] as num).toInt(),
  taxRate: json['tax_rate'] as num,
  lineTotal: (json['line_total'] as num).toInt(),
);

Map<String, dynamic> _$$InvoiceLineItemImplToJson(
  _$InvoiceLineItemImpl instance,
) => <String, dynamic>{
  'order_item_id': instance.orderItemId,
  'product_id': instance.productId,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit_price_gross': instance.unitPriceGross,
  'unit_price_net': instance.unitPriceNet,
  'tax_rate': instance.taxRate,
  'line_total': instance.lineTotal,
};
