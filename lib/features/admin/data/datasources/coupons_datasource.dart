import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Coupons table operations
class CouponsDataSource {
  final SupabaseClient _supabase;

  CouponsDataSource(this._supabase);

  /// Validate a coupon code
  /// 
  /// Checks:
  /// - Coupon exists
  /// - Is active
  /// - Valid date range
  /// - Usage limit not reached
  /// - Minimum purchase met
  Future<Map<String, dynamic>?> validateCoupon({
    required String code,
    required int cartTotal,
  }) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('code', code.toUpperCase())
          .maybeSingle();

      if (response == null) {
        throw Exception('Código de cupón no válido');
      }

      final coupon = response;
      final now = DateTime.now();

      // Check if active
      if (coupon['is_active'] != true) {
        throw Exception('Este cupón no está disponible');
      }

      // Check valid_from
      if (coupon['valid_from'] != null) {
        final validFrom = DateTime.parse(coupon['valid_from'] as String);
        if (now.isBefore(validFrom)) {
          throw Exception(
            'Cupón válido desde ${validFrom.day}/${validFrom.month}/${validFrom.year}',
          );
        }
      }

      // Check valid_until
      if (coupon['valid_until'] != null) {
        final validUntil = DateTime.parse(coupon['valid_until'] as String);
        if (now.isAfter(validUntil)) {
          throw Exception('Cupón expirado');
        }
      }

      // Check usage limit
      final currentUses = coupon['current_uses'] as int? ?? 0;
      final maxUses = coupon['max_uses'] as int?;
      if (maxUses != null && currentUses >= maxUses) {
        throw Exception('Cupón ha alcanzado el límite de usos');
      }

      // Check minimum purchase
      final minimumPurchase = coupon['minimum_purchase'] as int?;
      if (minimumPurchase != null && cartTotal < minimumPurchase) {
        final minInEuros = (minimumPurchase / 100).toStringAsFixed(2);
        throw Exception('Compra mínima de €$minInEuros requerida');
      }

      return coupon;
    } on PostgrestException catch (e) {
      throw Exception('Error al validar cupón: ${e.message}');
    }
  }

  /// Fetch all coupons (Admin only)
  Future<List<Map<String, dynamic>>> fetchCoupons({
    bool? activeOnly,
  }) async {
    try {
      dynamic query = _supabase.from('coupons').select('*');

      if (activeOnly == true) {
        query = query.eq('is_active', true);
      }

      query = query.order('created_at', ascending: false);

      final response = await query;
      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch coupons: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  /// Fetch a single coupon by ID (Admin only)
  Future<Map<String, dynamic>?> fetchCouponById(String couponId) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('id', couponId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch coupon: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch coupon: $e');
    }
  }

  /// Create a new coupon (Admin only)
  Future<Map<String, dynamic>> createCoupon(
    Map<String, dynamic> couponData,
  ) async {
    try {
      // Ensure code is uppercase
      if (couponData['code'] != null) {
        couponData['code'] = (couponData['code'] as String).toUpperCase();
      }

      final response = await _supabase
          .from('coupons')
          .insert(couponData)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation
        throw Exception('Ya existe un cupón con este código');
      }
      throw Exception('Failed to create coupon: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create coupon: $e');
    }
  }

  /// Update a coupon (Admin only)
  Future<Map<String, dynamic>> updateCoupon({
    required String couponId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Ensure code is uppercase if being updated
      if (updates['code'] != null) {
        updates['code'] = (updates['code'] as String).toUpperCase();
      }

      final response = await _supabase
          .from('coupons')
          .update(updates)
          .eq('id', couponId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Ya existe un cupón con este código');
      }
      throw Exception('Failed to update coupon: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update coupon: $e');
    }
  }

  /// Delete a coupon (Admin only)
  Future<void> deleteCoupon(String couponId) async {
    try {
      await _supabase.from('coupons').delete().eq('id', couponId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete coupon: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete coupon: $e');
    }
  }

  /// Fetch coupon usage history (Admin only)
  Future<List<Map<String, dynamic>>> fetchCouponUsage(String couponId) async {
    try {
      final response = await _supabase
          .from('coupon_usage')
          .select('''
            *,
            order:orders!coupon_usage_order_id_fkey(
              id,
              order_number,
              total_amount
            )
          ''')
          .eq('coupon_id', couponId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch coupon usage: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch coupon usage: $e');
    }
  }
}
