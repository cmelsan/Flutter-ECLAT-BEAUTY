import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart';

class OrderRepository {
  final SupabaseClient _client;

  OrderRepository(this._client);

  /// Get user's orders
  Future<Either<Failure, List<Order>>> getMyOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Right([]);

      final data = await _client
          .from('orders')
          .select('*, order_items(*, product:products(name, images, slug))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return Right(
        (data as List).map((e) => Order.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get single order by ID
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final data = await _client
          .from('orders')
          .select('*, order_items(*, product:products(name, images, slug))')
          .eq('id', orderId)
          .single();

      return Right(Order.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Cancel order (uses admin_cancel_order_atomic — same RPC as Astro web)
  /// NOTE: Stripe refund is NOT handled here. For paid orders the admin
  /// should process the refund separately via the refund flow.
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      final result = await _client.rpc('admin_cancel_order_atomic', params: {
        'p_order_id': orderId,
        'p_admin_id': userId,
        'p_notes': 'Cancelado por el cliente',
      });
      final data = result as Map<String, dynamic>;
      if (data['success'] == true) {
        return const Right(null);
      }
      return Left(ServerFailure(data['error']?.toString() ?? 'Error al cancelar'));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Request return — implemented client-side because the RPC has a
  /// changed_by_type='customer' bug that violates the DB CHECK constraint
  /// (only 'user','admin','system' are allowed).
  Future<Either<Failure, void>> requestReturn({
    required String orderId,
    required String reason,
    List<String>? itemIds,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;

      // 1. Validate order exists and is delivered
      final orderData = await _client
          .from('orders')
          .select('id, status, delivered_at')
          .eq('id', orderId)
          .single();

      final currentStatus = orderData['status'] as String?;
      if (currentStatus != 'delivered') {
        return Left(ServerFailure(
          'Solo se pueden devolver pedidos entregados (estado actual: $currentStatus)',
        ));
      }

      // 2. Mark selected order_items as 'requested'
      if (itemIds != null && itemIds.isNotEmpty) {
        await _client
            .from('order_items')
            .update({'return_status': 'requested', 'return_reason': reason})
            .eq('order_id', orderId)
            .inFilter('id', itemIds);
      } else {
        await _client
            .from('order_items')
            .update({'return_status': 'requested', 'return_reason': reason})
            .eq('order_id', orderId);
      }

      // 3. Update order status
      await _client.from('orders').update({
        'status': 'return_requested',
        'return_reason': reason,
        'return_initiated_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', orderId);

      // 4. Insert history with the CORRECT changed_by_type value
      await _client.from('order_status_history').insert({
        'order_id': orderId,
        'from_status': currentStatus,
        'to_status': 'return_requested',
        'changed_by': userId,
        'changed_by_type': 'user',
        'notes': 'Motivo: $reason',
      });

      debugPrint('[Return] Success — order $orderId → return_requested');
      return const Right(null);
    } catch (e) {
      debugPrint('[Return] Exception: $e');
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get order status history
  Future<Either<Failure, List<OrderStatusHistory>>> getStatusHistory(
    String orderId,
  ) async {
    try {
      final data = await _client
          .from('order_status_history')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      return Right(
        (data as List).map((e) => OrderStatusHistory.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  // ── Admin methods ─────────────────────────────────

  /// Get all orders (admin)
  Future<Either<Failure, List<Order>>> getAllOrders({
    String? statusFilter,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      var query = _client
          .from('orders')
          .select('*, order_items(*, product:products(name, images, slug))');

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.eq('status', statusFilter);
      }

      final data = await query
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      final orders = data as List;

      // Batch-fetch profiles for all registered users in a single query
      final userIds = orders
          .where((o) => o['user_id'] != null)
          .map((o) => o['user_id'] as String)
          .toSet()
          .toList();

      Map<String, Map<String, dynamic>> profilesMap = {};
      if (userIds.isNotEmpty) {
        final profiles = await _client
            .from('profiles')
            .select('id, email')
            .inFilter('id', userIds);
        for (final p in profiles as List) {
          profilesMap[p['id'] as String] = Map<String, dynamic>.from(p);
        }
      }

      // Enrich each order with profile data when the order fields are absent
      final enriched = orders.map((raw) {
        final o = Map<String, dynamic>.from(raw);
        final userId = o['user_id'] as String?;
        final profile = userId != null ? profilesMap[userId] : null;
        if (profile != null) {
          // Fill in name from profile email when not already on the order
          if ((o['customer_name'] as String?)?.isEmpty != false) {
            o['customer_name'] = profile['email'];
          }
          // Fill in email via guest_email field when it is absent (registered users)
          if ((o['guest_email'] as String?)?.isEmpty != false) {
            o['guest_email'] = profile['email'];
          }
        }
        return o;
      }).toList();

      return Right(
        enriched.map((e) => Order.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('❌ getAllOrders error: $e');
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Update order status (admin)
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String newStatus,
    String? notes,
  }) async {
    try {
      await _client.rpc('update_order_status', params: {
        'p_order_id': orderId,
        'p_new_status': newStatus,
        if (notes != null) 'p_notes': notes,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }
}
