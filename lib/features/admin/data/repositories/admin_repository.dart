import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';

class AdminRepository {
  final SupabaseClient _client;

  AdminRepository(this._client);

  /// Dashboard stats
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      // Total orders
      final orders = await _client.from('orders').select('id').count();
      // Pending orders
      final pending = await _client
          .from('orders')
          .select('id')
          .eq('status', 'paid')
          .count();
      // Total products
      final products = await _client.from('products').select('id').count();
      // Total revenue (sum of paid orders)
      final revenue = await _client
          .from('orders')
          .select('total_amount')
          .neq('status', 'cancelled')
          .neq('status', 'awaiting_payment');

      int totalRevenue = 0;
      for (final row in (revenue as List)) {
        totalRevenue += (row['total_amount'] as num).toInt();
      }

      return Right({
        'totalOrders': orders.count,
        'pendingOrders': pending.count,
        'totalProducts': products.count,
        'totalRevenue': totalRevenue,
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get all products (admin)
  Future<Either<Failure, List<Map<String, dynamic>>>> getProducts({
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final data = await _client
          .from('products')
          .select('*, category:categories(name), brand:brands(name)')
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);
      return Right(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Create product
  Future<Either<Failure, Map<String, dynamic>>> createProduct(
    Map<String, dynamic> productData,
  ) async {
    try {
      final data = await _client
          .from('products')
          .insert(productData)
          .select()
          .single();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Update product
  Future<Either<Failure, void>> updateProduct(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _client.from('products').update(updates).eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Delete product
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _client.from('products').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Update app setting
  Future<Either<Failure, void>> updateSetting(String key, dynamic value) async {
    try {
      await _client.from('app_settings').upsert({
        'key': key,
        'value': value,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get all orders (with filters)
  Future<Either<Failure, List<Map<String, dynamic>>>> getOrders({
    String? status,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      dynamic builder = _client
          .from('orders')
          .select('*, order_items(*, product:products(*))')
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      if (status != null) {
        builder = builder.eq('status', status);
      }

      final data = await builder;
      return Right(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Update order status (legacy - direct table update)
  Future<Either<Failure, void>> updateOrderStatus(
    String id,
    String status,
  ) async {
    try {
      await _client.from('orders').update({'status': status}).eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Mark order as shipped via RPC
  Future<Either<Failure, Map<String, dynamic>>> markShipped(
    String orderId, {
    String? notes,
  }) async {
    try {
      final adminId = _client.auth.currentUser?.id;
      final data = await _client.rpc('admin_mark_shipped', params: {
        'p_order_id': orderId,
        'p_admin_id': adminId,
        'p_notes': notes,
      });
      final result = Map<String, dynamic>.from(data as Map);
      if (result['success'] != true) {
        return Left(ServerFailure(result['error']?.toString() ?? 'Error al marcar como enviado'));
      }
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Mark order as delivered via RPC
  Future<Either<Failure, Map<String, dynamic>>> markDelivered(
    String orderId, {
    String? notes,
  }) async {
    try {
      final adminId = _client.auth.currentUser?.id;
      final data = await _client.rpc('admin_mark_delivered', params: {
        'p_order_id': orderId,
        'p_admin_id': adminId,
        'p_notes': notes,
      });
      final result = Map<String, dynamic>.from(data as Map);
      if (result['success'] != true) {
        return Left(ServerFailure(result['error']?.toString() ?? 'Error al marcar como entregado'));
      }
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Cancel order via RPC (admin)
  Future<Either<Failure, Map<String, dynamic>>> adminCancelOrder(
    String orderId, {
    String? notes,
  }) async {
    try {
      final adminId = _client.auth.currentUser?.id;
      final data = await _client.rpc('admin_cancel_order_atomic', params: {
        'p_order_id': orderId,
        'p_admin_id': adminId,
        'p_notes': notes,
      });
      final result = Map<String, dynamic>.from(data as Map);
      if (result['success'] != true) {
        return Left(ServerFailure(result['error']?.toString() ?? 'Error al cancelar pedido'));
      }
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get all coupons
  Future<Either<Failure, List<Map<String, dynamic>>>> getCoupons() async {
    try {
      final data = await _client
          .from('coupons')
          .select()
          .order('created_at', ascending: false);
      return Right(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Create coupon
  Future<Either<Failure, void>> createCoupon(
    Map<String, dynamic> couponData,
  ) async {
    try {
      await _client.from('coupons').insert(couponData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Update coupon
  Future<Either<Failure, void>> updateCoupon(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _client.from('coupons').update(updates).eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Delete coupon
  Future<Either<Failure, void>> deleteCoupon(String id) async {
    try {
      await _client.from('coupons').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get return requests — fetches orders with return-related statuses
  /// Groups by order (like Astro's devoluciones page)
  Future<Either<Failure, List<Map<String, dynamic>>>> getReturnRequests() async {
    try {
      final data = await _client
          .from('orders')
          .select('*, order_items(*, product:products(name, images, slug)), order_status_history(*)')
          .inFilter('status', [
            'return_requested',
            'returned',
            'partially_returned',
            'refunded',
            'partially_refunded',
          ])
          .order('updated_at', ascending: false);
      
      return Right(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Process a return via admin_process_return RPC
  /// [newStatus]: 'returned' (approve), 'delivered' (reject/revert)
  /// [restoreStock]: whether to restore product stock
  /// [notes]: optional admin notes
  Future<Either<Failure, Map<String, dynamic>>> processReturn({
    required String orderId,
    required String newStatus,
    bool restoreStock = false,
    String? notes,
  }) async {
    try {
      final adminId = _client.auth.currentUser?.id;
      final result = await _client.rpc('admin_process_return', params: {
        'p_order_id': orderId,
        'p_admin_id': adminId,
        'p_new_status': newStatus,
        'p_restore_stock': restoreStock,
        'p_notes': notes,
      });

      final data = result as Map<String, dynamic>;
      if (data['success'] == true) {
        return Right(data);
      } else {
        return Left(ServerFailure(data['error']?.toString() ?? 'Error desconocido'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Process a Stripe refund via Astro backend on Coolify
  /// [refundAmount]: optional partial refund amount in euros (null = full refund)
  Future<Either<Failure, Map<String, dynamic>>> processRefund({
    required String orderId,
    String? notes,
    double? refundAmount,
  }) async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) {
        return const Left(ServerFailure('No hay sesión activa'));
      }

      final url = '${AppConstants.siteUrl}/api/mobile-admin/process-refund';
      print('[AdminRepo] processRefund → POST $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'orderId': orderId,
          if (notes != null) 'notes': notes,
          if (refundAmount != null) 'refundAmount': refundAmount,
        }),
      );

      print('[AdminRepo] processRefund response: ${response.statusCode} ${response.body.substring(0, (response.body.length > 300 ? 300 : response.body.length))}');

      // Handle non-JSON responses (e.g. 404 HTML pages)
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        return Left(ServerFailure(
          'Error del servidor (${response.statusCode}). Verifica que el endpoint exista en Coolify.'));
      }

      if (response.statusCode >= 400) {
        return Left(ServerFailure(data['message']?.toString() ?? 'Error al procesar reembolso (${response.statusCode})'));
      }

      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
