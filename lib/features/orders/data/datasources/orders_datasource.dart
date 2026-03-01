import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Orders and Order Items table operations
class OrdersDataSource {
  final SupabaseClient _supabase;

  OrdersDataSource(this._supabase);

  /// Fetch all orders for the current user
  Future<List<Map<String, dynamic>>> fetchUserOrders({
    String? userId,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images)
            )
          ''')
          .order('created_at', ascending: false);

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch a single order by ID
  Future<Map<String, dynamic>?> fetchOrderById(String orderId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images, price)
            )
          ''')
          .eq('id', orderId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch order: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Fetch a single order by order number
  Future<Map<String, dynamic>?> fetchOrderByNumber(String orderNumber) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images, price)
            )
          ''')
          .eq('order_number', orderNumber)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch order: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Fetch all orders (Admin only)
  Future<List<Map<String, dynamic>>> fetchAllOrders({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images)
            )
          ''')
          .order('created_at', ascending: false);

      if (status != null) {
        query = query.eq('status', status);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch orders by status filter
  Future<List<Map<String, dynamic>>> fetchOrdersByStatus(
    List<String> statuses,
  ) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images)
            )
          ''')
          .inFilter('status', statuses)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch return requests (Admin only)
  Future<List<Map<String, dynamic>>> fetchReturnRequests() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images)
            )
          ''')
          .eq('status', 'return_requested')
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch return requests: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch return requests: $e');
    }
  }

  /// Fetch order status history
  Future<List<Map<String, dynamic>>> fetchOrderStatusHistory(
    String orderId,
  ) async {
    try {
      final response = await _supabase
          .from('order_status_history')
          .select('*')
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch order history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch order history: $e');
    }
  }

  /// Get total order count (Admin dashboard)
  Future<int> getTotalOrderCount() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('*')
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get order count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get order count: $e');
    }
  }

  /// Get pending orders count (Admin dashboard)
  Future<int> getPendingOrdersCount() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('*')
          .inFilter('status', ['awaiting_payment', 'paid'])
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get pending orders count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get pending orders count: $e');
    }
  }

  /// Get total revenue for a date range
  Future<int> getTotalRevenue({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('orders')
          .select('total_amount')
          .eq('status', 'paid');

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query;
      final orders = response as List;

      return orders.fold<int>(
        0,
        (sum, order) => sum + (order['total_amount'] as int? ?? 0),
      );
    } on PostgrestException catch (e) {
      throw Exception('Failed to calculate revenue: ${e.message}');
    } catch (e) {
      throw Exception('Failed to calculate revenue: $e');
    }
  }

  /// Search orders by order number or customer email (Admin)
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items(
              *,
              product:products(id, name, slug, images)
            )
          ''')
          .or(
            'order_number.ilike.%$query%,guest_email.ilike.%$query%,customer_name.ilike.%$query%',
          )
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to search orders: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search orders: $e');
    }
  }
}
