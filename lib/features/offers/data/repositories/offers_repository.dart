import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';

/// Repository for the "Rebajas" (featured offers) system.
///
/// Offers are stored in the `app_settings` table:
///  - key='offers_enabled'    → bool  (global toggle)
///  - key='featured_offers'   → JSON  [{id: productId, discount: %}]
///
/// Priority: flash sale > rebajas > base price
class OffersRepository {
  final SupabaseClient _client;

  OffersRepository(this._client);

  // ─── Settings ─────────────────────────────────────────

  /// Check if offers (rebajas) are globally enabled.
  Future<Either<Failure, bool>> isOffersEnabled() async {
    try {
      final response = await _client
          .from('app_settings')
          .select('value')
          .eq('key', 'offers_enabled')
          .maybeSingle();

      if (response == null) return const Right(false);
      return Right(response['value'] == true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Real-time stream of offers_enabled setting.
  Stream<bool> watchOffersEnabled() {
    return _client
        .from('app_settings')
        .stream(primaryKey: ['key'])
        .eq('key', 'offers_enabled')
        .map((event) {
          if (event.isEmpty) return false;
          return event.first['value'] == true;
        });
  }

  // ─── Featured Offers CRUD ─────────────────────────────

  /// Get the raw featured_offers list from app_settings.
  /// Returns `[{id: "uuid", discount: 20}, ...]`.
  Future<Either<Failure, List<Map<String, dynamic>>>> getFeaturedOffers() async {
    try {
      final response = await _client
          .from('app_settings')
          .select('value')
          .eq('key', 'featured_offers')
          .maybeSingle();

      if (response == null || response['value'] == null) {
        return const Right([]);
      }

      final raw = response['value'];
      if (raw is List) {
        return Right(
          raw.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
        );
      }
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Save the entire featured_offers array to app_settings.
  Future<Either<Failure, void>> saveFeaturedOffers(
    List<Map<String, dynamic>> offers,
  ) async {
    try {
      await _client.from('app_settings').upsert({
        'key': 'featured_offers',
        'value': offers,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Product Queries ──────────────────────────────────

  /// Fetch the actual products for the featured offers,
  /// enriched with their per-product discount %.
  ///
  /// Returns a list of product maps with an extra `offer_discount` field.
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getOfferProducts() async {
    try {
      // 1. Read the offers list
      final offersResult = await getFeaturedOffers();
      final offers = offersResult.fold((_) => <Map<String, dynamic>>[], (v) => v);

      if (offers.isEmpty) return const Right([]);

      // 2. Build a map of productId → discount
      final discountMap = <String, num>{};
      for (final o in offers) {
        final id = o['id'] as String?;
        final disc = o['discount'] as num?;
        if (id != null && disc != null) {
          discountMap[id] = disc;
        }
      }

      if (discountMap.isEmpty) return const Right([]);

      // 3. Fetch products by IDs
      final productIds = discountMap.keys.toList();
      final response = await _client
          .from('products')
          .select('*, brand:brands(name)')
          .inFilter('id', productIds)
          .gt('stock', 0); // Only in-stock

      // 4. Enrich with offer_discount
      final enriched = <Map<String, dynamic>>[];
      for (final p in (response as List)) {
        final product = Map<String, dynamic>.from(p as Map);
        final id = product['id'] as String;
        product['offer_discount'] = discountMap[id] ?? 0;
        enriched.add(product);
      }

      return Right(enriched);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get all products (for admin offers management).
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllProducts() async {
    try {
      final data = await _client
          .from('products')
          .select('*, brand:brands(name)')
          .order('name', ascending: true);
      return Right(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Price Calculation ────────────────────────────────

  /// Calculate discounted price from base price (cents) and discount %.
  static int calculateDiscountedPrice(int priceInCents, num discountPercent) {
    return (priceInCents * (1 - discountPercent / 100)).round();
  }

  /// Look up an offer discount for a specific product ID
  /// from the featured_offers settings.
  Future<num?> getOfferDiscountForProduct(String productId) async {
    final result = await getFeaturedOffers();
    return result.fold(
      (_) => null,
      (offers) {
        for (final o in offers) {
          if (o['id'] == productId) return o['discount'] as num?;
        }
        return null;
      },
    );
  }
}
