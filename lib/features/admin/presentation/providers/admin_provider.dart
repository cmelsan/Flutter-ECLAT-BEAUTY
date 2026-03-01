import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(supabaseClientProvider));
});

/// Dashboard stats
final adminDashboardProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getDashboardStats();
  return result.fold((f) => {}, (stats) => stats);
});

/// Admin products list
final adminProductsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getProducts();
  return result.fold((f) => [], (products) => products);
});

/// Admin coupons list
final adminCouponsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getCoupons();
  return result.fold((f) => [], (coupons) => coupons);
});

/// Admin returns list
final adminReturnsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getReturnRequests();
  return result.fold((f) => [], (requests) => requests);
});

/// Filter state for admin orders screen
// final adminOrdersFilterProvider = StateProvider<String?>((ref) => null);

/// Filtered admin orders
// final adminOrdersProvider = ...
