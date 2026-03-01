import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../data/repositories/order_repository.dart';
import '../../domain/entities/order.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(supabaseClientProvider));
});

/// User's orders
final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  final result = await repo.getMyOrders();
  return result.fold((f) => <Order>[], (orders) => orders);
});

/// Single order detail
final orderDetailProvider =
    FutureProvider.family<Order, String>((ref, orderId) async {
  final repo = ref.watch(orderRepositoryProvider);
  final result = await repo.getOrderById(orderId);
  return result.fold((f) => throw Exception(f.message), (order) => order);
});

/// Order status history
final orderStatusHistoryProvider =
    FutureProvider.family<List<OrderStatusHistory>, String>(
        (ref, orderId) async {
  final repo = ref.watch(orderRepositoryProvider);
  final result = await repo.getStatusHistory(orderId);
  return result.fold((f) => [], (history) => history);
});

/// Admin: All orders with optional status filter
final adminOrdersFilterProvider = StateProvider<String?>((ref) => null);

final adminOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  final filter = ref.watch(adminOrdersFilterProvider);
  final result = await repo.getAllOrders(statusFilter: filter);
  return result.fold((f) => <Order>[], (orders) => orders);
});
