import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../checkout/domain/entities/coupon.dart';

class CheckoutRepository {
  final SupabaseClient _client;

  CheckoutRepository(this._client);

  /// Validate and get coupon by code
  Future<Either<Failure, Coupon>> validateCoupon({
    required String code,
    required int cartTotal,
    String? userId,
  }) async {
    try {
      if (code.isEmpty) {
        return const Left(CouponFailure('Introduce un código de cupón'));
      }
      if (cartTotal <= 0) {
        return const Left(CouponFailure('El carrito está vacío'));
      }

      final data = await _client
          .from('coupons')
          .select()
          .eq('code', code.toUpperCase())
          .maybeSingle();

      if (data == null) {
        return const Left(CouponFailure('Cupón no encontrado'));
      }

      final coupon = Coupon.fromJson(data);

      // Validation checks matching the Astro web app
      if (!coupon.isActive) {
        return const Left(CouponFailure('Este cupón ya no está activo'));
      }

      final now = DateTime.now();
      if (coupon.validFrom != null && now.isBefore(coupon.validFrom!)) {
        return const Left(CouponFailure('Este cupón aún no es válido'));
      }
      if (coupon.validUntil != null && now.isAfter(coupon.validUntil!)) {
        return const Left(CouponFailure('Este cupón ha expirado'));
      }

      if (coupon.maxUses != null && coupon.currentUses >= coupon.maxUses!) {
        return const Left(CouponFailure('Este cupón ha alcanzado su límite de uso'));
      }

      if (coupon.minPurchaseAmount != null &&
          cartTotal < coupon.minPurchaseAmount!) {
        final min = AppUtils.formatPrice(coupon.minPurchaseAmount!);
        return Left(CouponFailure('Compra mínima de $min requerida'));
      }

      // Check per-user usage
      if (userId != null) {
        final usage = await _client
            .from('coupon_usage')
            .select('id')
            .eq('coupon_id', coupon.id)
            .eq('user_id', userId)
            .maybeSingle();

        if (usage != null) {
          return const Left(CouponFailure('Ya has usado este cupón'));
        }
      }

      return Right(coupon);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Create order via Supabase RPC
  Future<Either<Failure, Map<String, dynamic>>> createOrder({
    required List<Map<String, dynamic>> items,
    required int totalAmount,
    required Map<String, dynamic> shippingAddress,
    String? guestEmail,
    String? customerName,
    String? couponId,
    int discountAmount = 0,
  }) async {
    try {
      final result = await _client.rpc('create_order', params: {
        'p_items': items,
        'p_total_amount': totalAmount,
        'p_shipping_address': shippingAddress,
        'p_guest_email': ?guestEmail,
        'p_customer_name': ?customerName,
        'p_coupon_id': ?couponId,
      });

      final orderId = result['order_id'] as String;
      final orderNumber = result['order_number'] as String;

      // Record coupon usage if applicable
      if (couponId != null) {
        await _client.rpc('increment_coupon_usage_atomic', params: {
          'p_coupon_id': couponId,
          'p_order_id': orderId,
          'p_user_id': _client.auth.currentUser?.id,
          'p_discount_applied': discountAmount,
        });
      }

      return Right({
        'order_id': orderId,
        'order_number': orderNumber,
      });
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Decrement stock for purchased items after successful payment.
  /// Calls `decrease_product_stock_atomic` RPC for each item.
  /// This is a safety net — the Stripe webhook also decrements stock,
  /// but if the webhook is slow or fails, this guarantees consistency.
  Future<void> decreaseStockForItems(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      try {
        final result = await _client.rpc('decrease_product_stock_atomic', params: {
          'p_product_id': item['product_id'],
          'p_quantity': item['quantity'],
        });

        final success = result is Map ? result['success'] == true : false;
        if (!success) {
          debugPrint(
            '[Stock] Warning: decrease_product_stock_atomic failed for '
            '${item['product_id']}: $result',
          );
        }
      } catch (e) {
        debugPrint(
          '[Stock] Error decreasing stock for ${item['product_id']}: $e',
        );
      }
    }
  }

  /// Update order status to 'paid' after successful payment.
  /// También guarda el stripe_payment_intent_id para que los reembolsos funcionen.
  /// El webhook de Stripe omite el pedido por idempotencia si ya está en 'paid',
  /// por lo que guardamos el PI ID aquí desde el cliente.
  Future<void> updateOrderStatusToPaid(String orderId, {String? paymentIntentId}) async {
    try {
      await _client.rpc('update_order_status', params: {
        'p_order_id': orderId,
        'p_new_status': 'paid',
      });
      // Guardar el Payment Intent ID directamente para que los reembolsos funcionen.
      // El webhook normalmente lo haría, pero llega después de que el cliente
      // ya marcó el pedido como 'paid' y el webhook lo omite por idempotencia.
      if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
        await _client
            .from('orders')
            .update({'stripe_payment_intent_id': paymentIntentId})
            .eq('id', orderId);
        debugPrint('[Checkout] stripe_payment_intent_id saved: $paymentIntentId');
      }
    } catch (e) {
      debugPrint('[Checkout] Error updating order status to paid: $e');
    }
  }
}

