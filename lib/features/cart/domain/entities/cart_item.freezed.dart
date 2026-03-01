// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get price =>
      throw _privateConstructorUsedError; // original price in cents
  @JsonKey(name: 'discounted_price')
  int? get discountedPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    String name,
    int price,
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    int quantity,
    int stock,
    String? image,
  });
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? price = null,
    Object? discountedPrice = freezed,
    Object? quantity = null,
    Object? stock = null,
    Object? image = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            discountedPrice: freezed == discountedPrice
                ? _value.discountedPrice
                : discountedPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = _$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    String name,
    int price,
    @JsonKey(name: 'discounted_price') int? discountedPrice,
    int quantity,
    int stock,
    String? image,
  });
}

/// @nodoc
class _$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  _$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? price = null,
    Object? discountedPrice = freezed,
    Object? quantity = null,
    Object? stock = null,
    Object? image = freezed,
  }) {
    return _then(
      _$CartItemImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        discountedPrice: freezed == discountedPrice
            ? _value.discountedPrice
            : discountedPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl extends _CartItem {
  const _$CartItemImpl({
    @JsonKey(name: 'product_id') required this.productId,
    required this.name,
    required this.price,
    @JsonKey(name: 'discounted_price') this.discountedPrice,
    required this.quantity,
    required this.stock,
    this.image,
  }) : super._();

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  final String name;
  @override
  final int price;
  // original price in cents
  @override
  @JsonKey(name: 'discounted_price')
  final int? discountedPrice;
  @override
  final int quantity;
  @override
  final int stock;
  @override
  final String? image;

  @override
  String toString() {
    return 'CartItem(productId: $productId, name: $name, price: $price, discountedPrice: $discountedPrice, quantity: $quantity, stock: $stock, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    name,
    price,
    discountedPrice,
    quantity,
    stock,
    image,
  );

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      _$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(this);
  }
}

abstract class _CartItem extends CartItem {
  const factory _CartItem({
    @JsonKey(name: 'product_id') required final String productId,
    required final String name,
    required final int price,
    @JsonKey(name: 'discounted_price') final int? discountedPrice,
    required final int quantity,
    required final int stock,
    final String? image,
  }) = _$CartItemImpl;
  const _CartItem._() : super._();

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  String get name;
  @override
  int get price; // original price in cents
  @override
  @JsonKey(name: 'discounted_price')
  int? get discountedPrice;
  @override
  int get quantity;
  @override
  int get stock;
  @override
  String? get image;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppliedCoupon _$AppliedCouponFromJson(Map<String, dynamic> json) {
  return _AppliedCoupon.fromJson(json);
}

/// @nodoc
mixin _$AppliedCoupon {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_type')
  String get discountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_value')
  int get discountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_discount_amount')
  int? get maxDiscountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  int get discountAmount => throw _privateConstructorUsedError;

  /// Serializes this AppliedCoupon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppliedCoupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppliedCouponCopyWith<AppliedCoupon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppliedCouponCopyWith<$Res> {
  factory $AppliedCouponCopyWith(
    AppliedCoupon value,
    $Res Function(AppliedCoupon) then,
  ) = _$AppliedCouponCopyWithImpl<$Res, AppliedCoupon>;
  @useResult
  $Res call({
    String id,
    String code,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') int discountValue,
    @JsonKey(name: 'max_discount_amount') int? maxDiscountAmount,
    @JsonKey(name: 'discount_amount') int discountAmount,
  });
}

/// @nodoc
class _$AppliedCouponCopyWithImpl<$Res, $Val extends AppliedCoupon>
    implements $AppliedCouponCopyWith<$Res> {
  _$AppliedCouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppliedCoupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscountAmount = freezed,
    Object? discountAmount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            discountType: null == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as String,
            discountValue: null == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as int,
            maxDiscountAmount: freezed == maxDiscountAmount
                ? _value.maxDiscountAmount
                : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
                      as int?,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppliedCouponImplCopyWith<$Res>
    implements $AppliedCouponCopyWith<$Res> {
  factory _$$AppliedCouponImplCopyWith(
    _$AppliedCouponImpl value,
    $Res Function(_$AppliedCouponImpl) then,
  ) = _$$AppliedCouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') int discountValue,
    @JsonKey(name: 'max_discount_amount') int? maxDiscountAmount,
    @JsonKey(name: 'discount_amount') int discountAmount,
  });
}

/// @nodoc
class _$$AppliedCouponImplCopyWithImpl<$Res>
    extends _$AppliedCouponCopyWithImpl<$Res, _$AppliedCouponImpl>
    implements _$$AppliedCouponImplCopyWith<$Res> {
  _$$AppliedCouponImplCopyWithImpl(
    _$AppliedCouponImpl _value,
    $Res Function(_$AppliedCouponImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppliedCoupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscountAmount = freezed,
    Object? discountAmount = null,
  }) {
    return _then(
      _$AppliedCouponImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        discountType: null == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as String,
        discountValue: null == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as int,
        maxDiscountAmount: freezed == maxDiscountAmount
            ? _value.maxDiscountAmount
            : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppliedCouponImpl implements _AppliedCoupon {
  const _$AppliedCouponImpl({
    required this.id,
    required this.code,
    @JsonKey(name: 'discount_type') required this.discountType,
    @JsonKey(name: 'discount_value') required this.discountValue,
    @JsonKey(name: 'max_discount_amount') this.maxDiscountAmount,
    @JsonKey(name: 'discount_amount') required this.discountAmount,
  });

  factory _$AppliedCouponImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppliedCouponImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  @JsonKey(name: 'discount_type')
  final String discountType;
  @override
  @JsonKey(name: 'discount_value')
  final int discountValue;
  @override
  @JsonKey(name: 'max_discount_amount')
  final int? maxDiscountAmount;
  @override
  @JsonKey(name: 'discount_amount')
  final int discountAmount;

  @override
  String toString() {
    return 'AppliedCoupon(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue, maxDiscountAmount: $maxDiscountAmount, discountAmount: $discountAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppliedCouponImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscountAmount, maxDiscountAmount) ||
                other.maxDiscountAmount == maxDiscountAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    discountType,
    discountValue,
    maxDiscountAmount,
    discountAmount,
  );

  /// Create a copy of AppliedCoupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppliedCouponImplCopyWith<_$AppliedCouponImpl> get copyWith =>
      _$$AppliedCouponImplCopyWithImpl<_$AppliedCouponImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppliedCouponImplToJson(this);
  }
}

abstract class _AppliedCoupon implements AppliedCoupon {
  const factory _AppliedCoupon({
    required final String id,
    required final String code,
    @JsonKey(name: 'discount_type') required final String discountType,
    @JsonKey(name: 'discount_value') required final int discountValue,
    @JsonKey(name: 'max_discount_amount') final int? maxDiscountAmount,
    @JsonKey(name: 'discount_amount') required final int discountAmount,
  }) = _$AppliedCouponImpl;

  factory _AppliedCoupon.fromJson(Map<String, dynamic> json) =
      _$AppliedCouponImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  @JsonKey(name: 'discount_type')
  String get discountType;
  @override
  @JsonKey(name: 'discount_value')
  int get discountValue;
  @override
  @JsonKey(name: 'max_discount_amount')
  int? get maxDiscountAmount;
  @override
  @JsonKey(name: 'discount_amount')
  int get discountAmount;

  /// Create a copy of AppliedCoupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppliedCouponImplCopyWith<_$AppliedCouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
