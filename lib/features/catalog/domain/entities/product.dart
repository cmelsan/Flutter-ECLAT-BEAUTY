import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._(); // Enable custom getters

  const factory Product({
    required String id,
    required String name,
    required String slug,
    String? description,
    required int price, // in cents
    required int stock,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    @Default([]) List<String> images,
    // Flash sale fields
    @JsonKey(name: 'is_flash_sale') @Default(false) bool isFlashSale,
    @JsonKey(name: 'flash_sale_discount') double? flashSaleDiscount,
    @JsonKey(name: 'flash_sale_end_time') DateTime? flashSaleEndTime,
    // Offer/discount fields (from offers join)
    int? discount,
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    @JsonKey(name: 'offer_label') String? offerLabel,
    // Relations (populated via joins)
    Map<String, dynamic>? category,
    Map<String, dynamic>? brand,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Product;

  /// The effective price considering any active discount
  int get effectivePrice => discountedPrice ?? price;

  /// Whether this product has a discount
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  /// Discount percentage (0-100)
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountedPrice!) * 100 / price).round();
  }

  /// Whether this product is in stock
  bool get isInStock => stock > 0;

  /// Primary image URL
  String get primaryImage =>
      images.isNotEmpty ? images.first : '';

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
