import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Supabase RPC (Remote Procedure Call) functions
/// This handles all critical backend operations that require atomic transactions
class RPCDataSource {
  final SupabaseClient _supabase;

  RPCDataSource(this._supabase);

  // ============================================
  // ORDER MANAGEMENT
  // ============================================

  /// Create a new order with atomic stock validation
  /// 
  /// This function:
  /// - Validates stock availability for all items
  /// - Creates order and order_items in a transaction
  /// - Decrements stock atomically
  /// - Generates order number (ORD-YYYY-XXXXX)
  /// 
  /// Parameters:
  /// - [items]: List of cart items (product_id, quantity, price)
  /// - [totalAmount]: Total amount in cents
  /// - [shippingAddress]: Complete shipping address
  /// - [guestEmail]: Email for guest checkout (optional)
  /// - [customerName]: Name for guest checkout (optional)
  /// - [couponId]: Applied coupon ID (optional)
  /// 
  /// Returns: Order data with generated ID and order number
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required int totalAmount,
    required Map<String, dynamic> shippingAddress,
    String? guestEmail,
    String? customerName,
    String? couponId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'create_order',
        params: {
          'p_items': items,
          'p_total_amount': totalAmount,
          'p_shipping_address': shippingAddress,
          'p_guest_email': ?guestEmail,
          'p_customer_name': ?customerName,
          'p_coupon_id': ?couponId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      // Check for specific error messages from the RPC function
      if (e.message.contains('insufficient stock')) {
        throw Exception('Insufficient stock for one or more products');
      }
      throw Exception('Failed to create order: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Cancel an order and restore stock
  /// 
  /// This function:
  /// - Sets order status to 'cancelled'
  /// - Restores stock for all order items
  /// - Records status change in history
  /// 
  /// Only orders with status 'awaiting_payment' or 'paid' can be cancelled
  Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    try {
      final response = await _supabase.rpc(
        'cancel_order',
        params: {'p_order_id': orderId},
      );

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('cannot be cancelled')) {
        throw Exception('Order cannot be cancelled in its current state');
      }
      throw Exception('Failed to cancel order: ${e.message}');
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  /// Update order status
  /// 
  /// Valid transitions:
  /// - awaiting_payment → paid, cancelled
  /// - paid → shipped, cancelled
  /// - shipped → delivered, return_requested
  /// - delivered → return_requested (within 30 days)
  /// 
  /// Records change in order_status_history
  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String newStatus,
    String? notes,
  }) async {
    try {
      final response = await _supabase.rpc(
        'update_order_status',
        params: {
          'p_order_id': orderId,
          'p_new_status': newStatus,
          'p_notes': ?notes,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('invalid status transition')) {
        throw Exception('Invalid status transition');
      }
      throw Exception('Failed to update order status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // ============================================
  // RETURNS & REFUNDS
  // ============================================

  /// Request a return for a delivered order
  /// 
  /// Requirements:
  /// - Order must have status 'delivered'
  /// - Must be within 30 days of delivery
  /// 
  /// Sets status to 'return_requested' and calculates deadline
  Future<Map<String, dynamic>> requestReturn({
    required String orderId,
    required String reason,
  }) async {
    try {
      final response = await _supabase.rpc(
        'request_return',
        params: {
          'p_order_id': orderId,
          'p_reason': reason,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('not eligible')) {
        throw Exception('Order is not eligible for return');
      }
      if (e.message.contains('30 days')) {
        throw Exception('Return period has expired (30 days limit)');
      }
      throw Exception('Failed to request return: ${e.message}');
    } catch (e) {
      throw Exception('Failed to request return: $e');
    }
  }

  /// Process a return request (Admin only)
  /// 
  /// Parameters:
  /// - [orderId]: Order ID
  /// - [approved]: Whether to approve or reject
  /// - [restoreStock]: Whether to restore product stock (if approved)
  /// - [notes]: Admin notes
  Future<Map<String, dynamic>> processReturn({
    required String orderId,
    required bool approved,
    bool restoreStock = true,
    String? notes,
  }) async {
    try {
      final response = await _supabase.rpc(
        'process_return',
        params: {
          'p_order_id': orderId,
          'p_approved': approved,
          'p_restore_stock': restoreStock,
          'p_notes': ?notes,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to process return: ${e.message}');
    } catch (e) {
      throw Exception('Failed to process return: $e');
    }
  }

  /// Process a refund for a returned order (Admin only)
  /// 
  /// Requirements:
  /// - Order must have status 'returned'
  /// 
  /// Sets status to 'refunded' and records refund date
  Future<Map<String, dynamic>> processRefund(String orderId) async {
    try {
      final response = await _supabase.rpc(
        'process_refund',
        params: {'p_order_id': orderId},
      );

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('not in returned status')) {
        throw Exception('Order must be in returned status to process refund');
      }
      throw Exception('Failed to process refund: ${e.message}');
    } catch (e) {
      throw Exception('Failed to process refund: $e');
    }
  }

  // ============================================
  // COUPON MANAGEMENT
  // ============================================

  /// Increment coupon usage atomically
  /// 
  /// This function:
  /// - Validates max_uses limit (with row locking to prevent race conditions)
  /// - Increments current_uses counter
  /// - Records usage in coupon_usage table
  /// 
  /// Called AFTER successful payment
  Future<Map<String, dynamic>> incrementCouponUsage({
    required String couponId,
    required String orderId,
    String? userId,
    required int discountApplied,
  }) async {
    try {
      final response = await _supabase.rpc(
        'increment_coupon_usage_atomic',
        params: {
          'p_coupon_id': couponId,
          'p_order_id': orderId,
          'p_user_id': userId,
          'p_discount_applied': discountApplied,
        },
      );

      final result = response;

      if (result['success'] != true) {
        throw Exception(result['error'] ?? 'Failed to increment coupon usage');
      }

      return result;
    } on PostgrestException catch (e) {
      throw Exception('Failed to increment coupon usage: ${e.message}');
    } catch (e) {
      throw Exception('Failed to increment coupon usage: $e');
    }
  }

  // ============================================
  // CART MANAGEMENT
  // ============================================

  /// Migrate guest cart to authenticated user
  /// 
  /// Called when a guest user logs in or registers
  /// Merges guest cart items with user's cart
  Future<Map<String, dynamic>> migrateGuestCartToUser({
    required String sessionId,
    String? userId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'migrate_guest_cart_to_user',
        params: {
          'p_session_id': sessionId,
          'p_user_id': ?userId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to migrate cart: ${e.message}');
    } catch (e) {
      throw Exception('Failed to migrate cart: $e');
    }
  }

  // ============================================
  // UTILITY FUNCTIONS
  // ============================================

  /// Generate a new order number
  /// Format: ORD-YYYY-XXXXX (e.g., ORD-2026-00001)
  Future<String> generateOrderNumber() async {
    try {
      final response = await _supabase.rpc('generate_order_number');
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to generate order number: ${e.message}');
    } catch (e) {
      throw Exception('Failed to generate order number: $e');
    }
  }

  // ============================================
  // ADMIN STATISTICS
  // ============================================

  /// Get dashboard statistics (Admin only)
  /// 
  /// Returns aggregated data for admin dashboard
  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      // Note: This function would need to be created in Supabase
      // For now, we'll do manual queries
      final products = await _supabase
          .from('products')
          .select('*')
          .count(CountOption.exact);

      final orders = await _supabase
          .from('orders')
          .select('*')
          .count(CountOption.exact);

      final categories = await _supabase
          .from('categories')
          .select('*')
          .count(CountOption.exact);

      final brands = await _supabase
          .from('brands')
          .select('*')
          .count(CountOption.exact);

      return {
        'total_products': products.count,
        'total_orders': orders.count,
        'total_categories': categories.count,
        'total_brands': brands.count,
      };
    } catch (e) {
      throw Exception('Failed to get admin stats: $e');
    }
  }
}
