import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';

class FlashSalesRepository {
  final SupabaseClient _client;

  FlashSalesRepository(this._client);

  /// Check if flash sales are globally enabled
  Future<Either<Failure, bool>> isFlashSaleEnabled() async {
    try {
      final response = await _client
          .from('app_settings')
          .select('value')
          .eq('key', 'flash_sale_enabled')
          .maybeSingle();

      if (response == null) return const Right(false);
      return Right(response['value'] == true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Stream of flash sale enabled status
  Stream<bool> watchFlashSaleEnabled() {
    return _client
        .from('app_settings')
        .stream(primaryKey: ['key'])
        .eq('key', 'flash_sale_enabled')
        .map((event) {
          if (event.isEmpty) return false;
          return event.first['value'] == true;
        });
  }

  /// Fetch active flash sale products (max 6)
  Future<Either<Failure, List<Map<String, dynamic>>>> getFlashSaleProducts() async {
    try {
      final response = await _client
          .from('products')
          .select('*, brand:brands(name)')
          .eq('is_flash_sale', true)
          .limit(6);

      return Right(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Calculate discounted price in cents
  static int calculateDiscountedPrice(int priceInCents, num discountPercent) {
    return (priceInCents * (1 - discountPercent / 100)).round();
  }

  /// Get the latest end time among all flash sale products
  static DateTime? getLatestEndTime(List<Map<String, dynamic>> products) {
    DateTime? latest;
    for (final p in products) {
      final endStr = p['flash_sale_end_time'] as String?;
      if (endStr == null) continue;
      final dt = DateTime.tryParse(endStr);
      if (dt == null) continue;
      if (latest == null || dt.isAfter(latest)) {
        latest = dt;
      }
    }
    return latest;
  }
}
