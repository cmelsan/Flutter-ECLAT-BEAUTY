import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'customer_name') String? customerName,
    required String status,
    @JsonKey(name: 'total_amount') required int totalAmount, // cents
    @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'coupon_id') String? couponId,
    @JsonKey(name: 'discount_amount') @Default(0) int discountAmount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'return_initiated_at') DateTime? returnInitiatedAt,
    @JsonKey(name: 'return_deadline_at') DateTime? returnDeadlineAt,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_address') Map<String, dynamic>? returnAddress,
    // Relations
    @JsonKey(name: 'order_items') @Default([]) List<OrderItem> orderItems,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'product_id') required String productId,
    required int quantity,
    @JsonKey(name: 'price_at_purchase') required int priceAtPurchase, // cents
    @JsonKey(name: 'return_status') String? returnStatus,
    // Joined product data
    Map<String, dynamic>? product,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
abstract class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    required String id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'from_status') String? fromStatus,
    @JsonKey(name: 'to_status') required String toStatus,
    @JsonKey(name: 'changed_by') String? changedBy,
    @JsonKey(name: 'changed_by_type') String? changedByType,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);
}

/// Order status constants matching the DB enum
class OrderStatus {
  OrderStatus._();

  static const String awaitingPayment = 'awaiting_payment';
  static const String paid = 'paid';
  static const String shipped = 'shipped';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
  static const String returnRequested = 'return_requested';
  static const String returned = 'returned';
  static const String partiallyReturned = 'partially_returned';
  static const String refunded = 'refunded';
  static const String partiallyRefunded = 'partially_refunded';

  static String label(String status) {
    switch (status) {
      case awaitingPayment:
        return 'Pendiente de pago';
      case paid:
        return 'Pagado';
      case shipped:
        return 'Enviado';
      case delivered:
        return 'Entregado';
      case cancelled:
        return 'Cancelado';
      case returnRequested:
        return 'Devolución solicitada';
      case returned:
        return 'Devuelto';
      case partiallyReturned:
        return 'Parcialmente devuelto';
      case refunded:
        return 'Reembolsado';
      case partiallyRefunded:
        return 'Parcialmente reembolsado';
      default:
        return status;
    }
  }
}
