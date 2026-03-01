// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return _Coupon.fromJson(json);
}

/// @nodoc
mixin _$Coupon {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_type')
  String get discountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_value')
  double get discountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_purchase_amount')
  double get minPurchaseAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_discount_amount')
  double? get maxDiscountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_uses')
  int get currentUses => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_uses')
  int? get maxUses => throw _privateConstructorUsedError;

  /// Serializes this Coupon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponCopyWith<Coupon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponCopyWith<$Res> {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) then) =
      _$CouponCopyWithImpl<$Res, Coupon>;
  @useResult
  $Res call({
    String id,
    String code,
    String? description,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') double discountValue,
    @JsonKey(name: 'min_purchase_amount') double minPurchaseAmount,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'current_uses') int currentUses,
    @JsonKey(name: 'max_uses') int? maxUses,
  });
}

/// @nodoc
class _$CouponCopyWithImpl<$Res, $Val extends Coupon>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minPurchaseAmount = null,
    Object? maxDiscountAmount = freezed,
    Object? isActive = null,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? currentUses = null,
    Object? maxUses = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountType: null == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as String,
            discountValue: null == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as double,
            minPurchaseAmount: null == minPurchaseAmount
                ? _value.minPurchaseAmount
                : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            maxDiscountAmount: freezed == maxDiscountAmount
                ? _value.maxDiscountAmount
                : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            validFrom: freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            validUntil: freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            currentUses: null == currentUses
                ? _value.currentUses
                : currentUses // ignore: cast_nullable_to_non_nullable
                      as int,
            maxUses: freezed == maxUses
                ? _value.maxUses
                : maxUses // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CouponImplCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$$CouponImplCopyWith(
    _$CouponImpl value,
    $Res Function(_$CouponImpl) then,
  ) = _$$CouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String? description,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') double discountValue,
    @JsonKey(name: 'min_purchase_amount') double minPurchaseAmount,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'current_uses') int currentUses,
    @JsonKey(name: 'max_uses') int? maxUses,
  });
}

/// @nodoc
class _$$CouponImplCopyWithImpl<$Res>
    extends _$CouponCopyWithImpl<$Res, _$CouponImpl>
    implements _$$CouponImplCopyWith<$Res> {
  _$$CouponImplCopyWithImpl(
    _$CouponImpl _value,
    $Res Function(_$CouponImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minPurchaseAmount = null,
    Object? maxDiscountAmount = freezed,
    Object? isActive = null,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? currentUses = null,
    Object? maxUses = freezed,
  }) {
    return _then(
      _$CouponImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountType: null == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as String,
        discountValue: null == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as double,
        minPurchaseAmount: null == minPurchaseAmount
            ? _value.minPurchaseAmount
            : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        maxDiscountAmount: freezed == maxDiscountAmount
            ? _value.maxDiscountAmount
            : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        validFrom: freezed == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        validUntil: freezed == validUntil
            ? _value.validUntil
            : validUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        currentUses: null == currentUses
            ? _value.currentUses
            : currentUses // ignore: cast_nullable_to_non_nullable
                  as int,
        maxUses: freezed == maxUses
            ? _value.maxUses
            : maxUses // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponImpl implements _Coupon {
  const _$CouponImpl({
    required this.id,
    required this.code,
    this.description,
    @JsonKey(name: 'discount_type') this.discountType = 'percentage',
    @JsonKey(name: 'discount_value') required this.discountValue,
    @JsonKey(name: 'min_purchase_amount') this.minPurchaseAmount = 0,
    @JsonKey(name: 'max_discount_amount') this.maxDiscountAmount,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'valid_from') this.validFrom,
    @JsonKey(name: 'valid_until') this.validUntil,
    @JsonKey(name: 'current_uses') this.currentUses = 0,
    @JsonKey(name: 'max_uses') this.maxUses,
  });

  factory _$CouponImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String? description;
  @override
  @JsonKey(name: 'discount_type')
  final String discountType;
  @override
  @JsonKey(name: 'discount_value')
  final double discountValue;
  @override
  @JsonKey(name: 'min_purchase_amount')
  final double minPurchaseAmount;
  @override
  @JsonKey(name: 'max_discount_amount')
  final double? maxDiscountAmount;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'valid_from')
  final DateTime? validFrom;
  @override
  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;
  @override
  @JsonKey(name: 'current_uses')
  final int currentUses;
  @override
  @JsonKey(name: 'max_uses')
  final int? maxUses;

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, description: $description, discountType: $discountType, discountValue: $discountValue, minPurchaseAmount: $minPurchaseAmount, maxDiscountAmount: $maxDiscountAmount, isActive: $isActive, validFrom: $validFrom, validUntil: $validUntil, currentUses: $currentUses, maxUses: $maxUses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.minPurchaseAmount, minPurchaseAmount) ||
                other.minPurchaseAmount == minPurchaseAmount) &&
            (identical(other.maxDiscountAmount, maxDiscountAmount) ||
                other.maxDiscountAmount == maxDiscountAmount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.currentUses, currentUses) ||
                other.currentUses == currentUses) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    description,
    discountType,
    discountValue,
    minPurchaseAmount,
    maxDiscountAmount,
    isActive,
    validFrom,
    validUntil,
    currentUses,
    maxUses,
  );

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      _$$CouponImplCopyWithImpl<_$CouponImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponImplToJson(this);
  }
}

abstract class _Coupon implements Coupon {
  const factory _Coupon({
    required final String id,
    required final String code,
    final String? description,
    @JsonKey(name: 'discount_type') final String discountType,
    @JsonKey(name: 'discount_value') required final double discountValue,
    @JsonKey(name: 'min_purchase_amount') final double minPurchaseAmount,
    @JsonKey(name: 'max_discount_amount') final double? maxDiscountAmount,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'valid_from') final DateTime? validFrom,
    @JsonKey(name: 'valid_until') final DateTime? validUntil,
    @JsonKey(name: 'current_uses') final int currentUses,
    @JsonKey(name: 'max_uses') final int? maxUses,
  }) = _$CouponImpl;

  factory _Coupon.fromJson(Map<String, dynamic> json) = _$CouponImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String? get description;
  @override
  @JsonKey(name: 'discount_type')
  String get discountType;
  @override
  @JsonKey(name: 'discount_value')
  double get discountValue;
  @override
  @JsonKey(name: 'min_purchase_amount')
  double get minPurchaseAmount;
  @override
  @JsonKey(name: 'max_discount_amount')
  double? get maxDiscountAmount;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom;
  @override
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil;
  @override
  @JsonKey(name: 'current_uses')
  int get currentUses;
  @override
  @JsonKey(name: 'max_uses')
  int? get maxUses;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
