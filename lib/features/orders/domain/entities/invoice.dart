import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String type, // 'invoice' | 'credit_note'
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'reference_invoice_id') String? referenceInvoiceId,
    @JsonKey(name: 'credit_note_scope') String? creditNoteScope,
    required int subtotal, // cents
    @JsonKey(name: 'tax_rate') required num taxRate,
    @JsonKey(name: 'tax_amount') required int taxAmount, // cents
    @JsonKey(name: 'discount_amount') @Default(0) int discountAmount, // cents
    @JsonKey(name: 'total_amount') required int totalAmount, // cents
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_address') Map<String, dynamic>? customerAddress,
    @JsonKey(name: 'customer_nif') String? customerNif,
    @JsonKey(name: 'line_items') @Default([]) List<InvoiceLineItem> lineItems,
    @JsonKey(name: 'stripe_refund_id') String? stripeRefundId,
    String? notes,
    @JsonKey(name: 'issued_at') DateTime? issuedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined order data (from select with join)
    Map<String, dynamic>? orders,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}

@freezed
abstract class InvoiceLineItem with _$InvoiceLineItem {
  const factory InvoiceLineItem({
    @JsonKey(name: 'order_item_id') String? orderItemId,
    @JsonKey(name: 'product_id') String? productId,
    required String name,
    required int quantity,
    @JsonKey(name: 'unit_price_gross') required int unitPriceGross, // cents
    @JsonKey(name: 'unit_price_net') required int unitPriceNet, // cents
    @JsonKey(name: 'tax_rate') required num taxRate,
    @JsonKey(name: 'line_total') required int lineTotal, // cents
  }) = _InvoiceLineItem;

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceLineItemFromJson(json);
}
