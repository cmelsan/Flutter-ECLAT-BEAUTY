import '../../../admin/data/datasources/coupons_datasource.dart';
import '../entities/coupon.dart';

class CouponRepository {
  final CouponsDataSource _datasource;

  CouponRepository(this._datasource);

  /// Validate a coupon code against cart total
  /// 
  /// Returns the Coupon if valid, otherwise throws an exception
  Future<Coupon> validateCoupon({
    required String code,
    required int cartTotalInCents,
  }) async {
    final couponData = await _datasource.validateCoupon(
      code: code,
      cartTotal: cartTotalInCents,
    );

    if (couponData == null) {
      throw Exception('Código de cupón no válido');
    }

    return Coupon.fromJson(couponData);
  }
}
