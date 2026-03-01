// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError; // in cents
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_id')
  String? get brandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_id')
  String? get subcategoryId => throw _privateConstructorUsedError;
  List<String> get images =>
      throw _privateConstructorUsedError; // Flash sale fields
  @JsonKey(name: 'is_flash_sale')
  bool get isFlashSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'flash_sale_discount')
  double? get flashSaleDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'flash_sale_end_time')
  DateTime? get flashSaleEndTime => throw _privateConstructorUsedError; // Offer/discount fields (from offers join)
  int? get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discounted_price')
  int? get discountedPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'offer_label')
  String? get offerLabel => throw _privateConstructorUsedError; // Relations (populated via joins)
  Map<String, dynamic>? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    int price,
    int stock,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    List<String> images,
    @JsonKey(name: 'is_flash_sale') bool isFlashSale,
    @JsonKey(name: 'flash_sale_discount') double? flashSaleDiscount,
    @JsonKey(name: 'flash_sale_end_time') DateTime? flashSaleEndTime,
    int? discount,
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    @JsonKey(name: 'offer_label') String? offerLabel,
    Map<String, dynamic>? category,
    Map<String, dynamic>? brand,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? stock = null,
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? subcategoryId = freezed,
    Object? images = null,
    Object? isFlashSale = null,
    Object? flashSaleDiscount = freezed,
    Object? flashSaleEndTime = freezed,
    Object? discount = freezed,
    Object? discountedPrice = freezed,
    Object? offerLabel = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandId: freezed == brandId
                ? _value.brandId
                : brandId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subcategoryId: freezed == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isFlashSale: null == isFlashSale
                ? _value.isFlashSale
                : isFlashSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            flashSaleDiscount: freezed == flashSaleDiscount
                ? _value.flashSaleDiscount
                : flashSaleDiscount // ignore: cast_nullable_to_non_nullable
                      as double?,
            flashSaleEndTime: freezed == flashSaleEndTime
                ? _value.flashSaleEndTime
                : flashSaleEndTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            discount: freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as int?,
            discountedPrice: freezed == discountedPrice
                ? _value.discountedPrice
                : discountedPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            offerLabel: freezed == offerLabel
                ? _value.offerLabel
                : offerLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = _$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    int price,
    int stock,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    List<String> images,
    @JsonKey(name: 'is_flash_sale') bool isFlashSale,
    @JsonKey(name: 'flash_sale_discount') double? flashSaleDiscount,
    @JsonKey(name: 'flash_sale_end_time') DateTime? flashSaleEndTime,
    int? discount,
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    @JsonKey(name: 'offer_label') String? offerLabel,
    Map<String, dynamic>? category,
    Map<String, dynamic>? brand,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  _$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? stock = null,
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? subcategoryId = freezed,
    Object? images = null,
    Object? isFlashSale = null,
    Object? flashSaleDiscount = freezed,
    Object? flashSaleEndTime = freezed,
    Object? discount = freezed,
    Object? discountedPrice = freezed,
    Object? offerLabel = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandId: freezed == brandId
            ? _value.brandId
            : brandId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subcategoryId: freezed == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isFlashSale: null == isFlashSale
            ? _value.isFlashSale
            : isFlashSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        flashSaleDiscount: freezed == flashSaleDiscount
            ? _value.flashSaleDiscount
            : flashSaleDiscount // ignore: cast_nullable_to_non_nullable
                  as double?,
        flashSaleEndTime: freezed == flashSaleEndTime
            ? _value.flashSaleEndTime
            : flashSaleEndTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        discount: freezed == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as int?,
        discountedPrice: freezed == discountedPrice
            ? _value.discountedPrice
            : discountedPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        offerLabel: freezed == offerLabel
            ? _value.offerLabel
            : offerLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value._category
            : category // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        brand: freezed == brand
            ? _value._brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl extends _Product {
  const _$ProductImpl({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    required this.stock,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'brand_id') this.brandId,
    @JsonKey(name: 'subcategory_id') this.subcategoryId,
    final List<String> images = const [],
    @JsonKey(name: 'is_flash_sale') this.isFlashSale = false,
    @JsonKey(name: 'flash_sale_discount') this.flashSaleDiscount,
    @JsonKey(name: 'flash_sale_end_time') this.flashSaleEndTime,
    this.discount,
    @JsonKey(name: 'discounted_price') this.discountedPrice,
    @JsonKey(name: 'offer_label') this.offerLabel,
    final Map<String, dynamic>? category,
    final Map<String, dynamic>? brand,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _images = images,
       _category = category,
       _brand = brand,
       super._();

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final int price;
  // in cents
  @override
  final int stock;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'brand_id')
  final String? brandId;
  @override
  @JsonKey(name: 'subcategory_id')
  final String? subcategoryId;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  // Flash sale fields
  @override
  @JsonKey(name: 'is_flash_sale')
  final bool isFlashSale;
  @override
  @JsonKey(name: 'flash_sale_discount')
  final double? flashSaleDiscount;
  @override
  @JsonKey(name: 'flash_sale_end_time')
  final DateTime? flashSaleEndTime;
  // Offer/discount fields (from offers join)
  @override
  final int? discount;
  @override
  @JsonKey(name: 'discounted_price')
  final int? discountedPrice;
  @override
  @JsonKey(name: 'offer_label')
  final String? offerLabel;
  // Relations (populated via joins)
  final Map<String, dynamic>? _category;
  // Relations (populated via joins)
  @override
  Map<String, dynamic>? get category {
    final value = _category;
    if (value == null) return null;
    if (_category is EqualUnmodifiableMapView) return _category;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _brand;
  @override
  Map<String, dynamic>? get brand {
    final value = _brand;
    if (value == null) return null;
    if (_brand is EqualUnmodifiableMapView) return _brand;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, slug: $slug, description: $description, price: $price, stock: $stock, categoryId: $categoryId, brandId: $brandId, subcategoryId: $subcategoryId, images: $images, isFlashSale: $isFlashSale, flashSaleDiscount: $flashSaleDiscount, flashSaleEndTime: $flashSaleEndTime, discount: $discount, discountedPrice: $discountedPrice, offerLabel: $offerLabel, category: $category, brand: $brand, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isFlashSale, isFlashSale) ||
                other.isFlashSale == isFlashSale) &&
            (identical(other.flashSaleDiscount, flashSaleDiscount) ||
                other.flashSaleDiscount == flashSaleDiscount) &&
            (identical(other.flashSaleEndTime, flashSaleEndTime) ||
                other.flashSaleEndTime == flashSaleEndTime) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.offerLabel, offerLabel) ||
                other.offerLabel == offerLabel) &&
            const DeepCollectionEquality().equals(other._category, _category) &&
            const DeepCollectionEquality().equals(other._brand, _brand) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    slug,
    description,
    price,
    stock,
    categoryId,
    brandId,
    subcategoryId,
    const DeepCollectionEquality().hash(_images),
    isFlashSale,
    flashSaleDiscount,
    flashSaleEndTime,
    discount,
    discountedPrice,
    offerLabel,
    const DeepCollectionEquality().hash(_category),
    const DeepCollectionEquality().hash(_brand),
    createdAt,
  ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      _$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product extends Product {
  const factory _Product({
    required final String id,
    required final String name,
    required final String slug,
    final String? description,
    required final int price,
    required final int stock,
    @JsonKey(name: 'category_id') final String? categoryId,
    @JsonKey(name: 'brand_id') final String? brandId,
    @JsonKey(name: 'subcategory_id') final String? subcategoryId,
    final List<String> images,
    @JsonKey(name: 'is_flash_sale') final bool isFlashSale,
    @JsonKey(name: 'flash_sale_discount') final double? flashSaleDiscount,
    @JsonKey(name: 'flash_sale_end_time') final DateTime? flashSaleEndTime,
    final int? discount,
    @JsonKey(name: 'discounted_price') final int? discountedPrice,
    @JsonKey(name: 'offer_label') final String? offerLabel,
    final Map<String, dynamic>? category,
    final Map<String, dynamic>? brand,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$ProductImpl;
  const _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  int get price; // in cents
  @override
  int get stock;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'brand_id')
  String? get brandId;
  @override
  @JsonKey(name: 'subcategory_id')
  String? get subcategoryId;
  @override
  List<String> get images; // Flash sale fields
  @override
  @JsonKey(name: 'is_flash_sale')
  bool get isFlashSale;
  @override
  @JsonKey(name: 'flash_sale_discount')
  double? get flashSaleDiscount;
  @override
  @JsonKey(name: 'flash_sale_end_time')
  DateTime? get flashSaleEndTime; // Offer/discount fields (from offers join)
  @override
  int? get discount;
  @override
  @JsonKey(name: 'discounted_price')
  int? get discountedPrice;
  @override
  @JsonKey(name: 'offer_label')
  String? get offerLabel; // Relations (populated via joins)
  @override
  Map<String, dynamic>? get category;
  @override
  Map<String, dynamic>? get brand;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
