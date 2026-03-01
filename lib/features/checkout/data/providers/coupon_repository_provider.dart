import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../admin/data/datasources/coupons_datasource.dart';
import '../../domain/repositories/coupon_repository.dart';

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  final supabase = Supabase.instance.client;
  final datasource = CouponsDataSource(supabase);
  return CouponRepository(datasource);
});
