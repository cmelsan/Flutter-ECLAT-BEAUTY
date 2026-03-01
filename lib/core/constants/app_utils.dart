import 'dart:math';

/// Utility functions mirroring the Astro web app
class AppUtils {
  AppUtils._();

  /// Format cents to EUR display string: "12,50 €"
  static String formatPrice(int cents) {
    final euros = (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
    return '$euros €';
  }

  /// Slugify text: lowercase, replace spaces, remove special chars
  static String slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9-]'), '')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Get human-readable stock label
  static String getStockLabel(int stock) {
    if (stock <= 0) return 'Agotado';
    if (stock <= 5) return 'Solo $stock disponibles';
    return 'En stock';
  }

  /// Get stock label color
  static StockStatus getStockStatus(int stock) {
    if (stock <= 0) return StockStatus.outOfStock;
    if (stock <= 5) return StockStatus.low;
    return StockStatus.inStock;
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Build Cloudinary optimized URL with transforms
  static String cloudinaryUrl(
    String originalUrl, {
    int? width,
    int? height,
    String crop = 'fill',
  }) {
    if (!originalUrl.contains('/upload/')) return originalUrl;

    final transforms = <String>['f_auto', 'q_auto'];
    if (width != null) transforms.add('w_$width');
    if (height != null) transforms.add('h_$height');
    if (width != null || height != null) transforms.add('c_$crop');

    final transformStr = transforms.join(',');
    return originalUrl.replaceFirst('/upload/', '/upload/$transformStr/');
  }

  /// Cloudinary presets matching the Astro web app
  static String thumbnailUrl(String url) =>
      cloudinaryUrl(url, width: 200, height: 200);

  static String catalogUrl(String url) =>
      cloudinaryUrl(url, width: 400, height: 400);

  static String galleryUrl(String url) =>
      cloudinaryUrl(url, width: 800, height: 800);

  static String fullWidthUrl(String url) =>
      cloudinaryUrl(url, width: 1200, height: 1200, crop: 'fit');

  /// Calculate coupon discount
  static int calculateDiscount({
    required String discountType,
    required int discountValue,
    int? maxDiscountAmount,
    required int cartTotal,
  }) {
    int discount;
    if (discountType == 'fixed') {
      discount = min(discountValue, cartTotal);
    } else {
      // percentage
      discount = (cartTotal * discountValue) ~/ 100;
      if (maxDiscountAmount != null) {
        discount = min(discount, maxDiscountAmount);
      }
    }
    return discount;
  }

  /// Format date for display (Spanish locale)
  static String formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  /// Format date as DD/MM/YYYY
  static String formatDateShort(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

enum StockStatus { inStock, low, outOfStock }
