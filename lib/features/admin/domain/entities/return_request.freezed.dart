// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReturnRequest _$ReturnRequestFromJson(Map<String, dynamic> json) {
  return _ReturnRequest.fromJson(json);
}

/// @nodoc
mixin _$ReturnRequest {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_status')
  String? get returnStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_reason')
  String? get returnReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_requested_at')
  DateTime? get returnRequestedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_processed_at')
  DateTime? get returnProcessedAt => throw _privateConstructorUsedError; // Add joined fields for UI if they come from Supabase query
  Map<String, dynamic>? get order => throw _privateConstructorUsedError;
  Map<String, dynamic>? get product => throw _privateConstructorUsedError;

  /// Serializes this ReturnRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReturnRequestCopyWith<ReturnRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnRequestCopyWith<$Res> {
  factory $ReturnRequestCopyWith(
    ReturnRequest value,
    $Res Function(ReturnRequest) then,
  ) = _$ReturnRequestCopyWithImpl<$Res, ReturnRequest>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'return_status') String? returnStatus,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_requested_at') DateTime? returnRequestedAt,
    @JsonKey(name: 'return_processed_at') DateTime? returnProcessedAt,
    Map<String, dynamic>? order,
    Map<String, dynamic>? product,
  });
}

/// @nodoc
class _$ReturnRequestCopyWithImpl<$Res, $Val extends ReturnRequest>
    implements $ReturnRequestCopyWith<$Res> {
  _$ReturnRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? returnStatus = freezed,
    Object? returnReason = freezed,
    Object? returnRequestedAt = freezed,
    Object? returnProcessedAt = freezed,
    Object? order = freezed,
    Object? product = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            returnStatus: freezed == returnStatus
                ? _value.returnStatus
                : returnStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            returnReason: freezed == returnReason
                ? _value.returnReason
                : returnReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            returnRequestedAt: freezed == returnRequestedAt
                ? _value.returnRequestedAt
                : returnRequestedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            returnProcessedAt: freezed == returnProcessedAt
                ? _value.returnProcessedAt
                : returnProcessedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReturnRequestImplCopyWith<$Res>
    implements $ReturnRequestCopyWith<$Res> {
  factory _$$ReturnRequestImplCopyWith(
    _$ReturnRequestImpl value,
    $Res Function(_$ReturnRequestImpl) then,
  ) = _$$ReturnRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'return_status') String? returnStatus,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_requested_at') DateTime? returnRequestedAt,
    @JsonKey(name: 'return_processed_at') DateTime? returnProcessedAt,
    Map<String, dynamic>? order,
    Map<String, dynamic>? product,
  });
}

/// @nodoc
class _$$ReturnRequestImplCopyWithImpl<$Res>
    extends _$ReturnRequestCopyWithImpl<$Res, _$ReturnRequestImpl>
    implements _$$ReturnRequestImplCopyWith<$Res> {
  _$$ReturnRequestImplCopyWithImpl(
    _$ReturnRequestImpl _value,
    $Res Function(_$ReturnRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? returnStatus = freezed,
    Object? returnReason = freezed,
    Object? returnRequestedAt = freezed,
    Object? returnProcessedAt = freezed,
    Object? order = freezed,
    Object? product = freezed,
  }) {
    return _then(
      _$ReturnRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        returnStatus: freezed == returnStatus
            ? _value.returnStatus
            : returnStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        returnReason: freezed == returnReason
            ? _value.returnReason
            : returnReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        returnRequestedAt: freezed == returnRequestedAt
            ? _value.returnRequestedAt
            : returnRequestedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        returnProcessedAt: freezed == returnProcessedAt
            ? _value.returnProcessedAt
            : returnProcessedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        order: freezed == order
            ? _value._order
            : order // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        product: freezed == product
            ? _value._product
            : product // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReturnRequestImpl implements _ReturnRequest {
  const _$ReturnRequestImpl({
    required this.id,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'return_status') this.returnStatus,
    @JsonKey(name: 'return_reason') this.returnReason,
    @JsonKey(name: 'return_requested_at') this.returnRequestedAt,
    @JsonKey(name: 'return_processed_at') this.returnProcessedAt,
    final Map<String, dynamic>? order,
    final Map<String, dynamic>? product,
  }) : _order = order,
       _product = product;

  factory _$ReturnRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReturnRequestImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'return_status')
  final String? returnStatus;
  @override
  @JsonKey(name: 'return_reason')
  final String? returnReason;
  @override
  @JsonKey(name: 'return_requested_at')
  final DateTime? returnRequestedAt;
  @override
  @JsonKey(name: 'return_processed_at')
  final DateTime? returnProcessedAt;
  // Add joined fields for UI if they come from Supabase query
  final Map<String, dynamic>? _order;
  // Add joined fields for UI if they come from Supabase query
  @override
  Map<String, dynamic>? get order {
    final value = _order;
    if (value == null) return null;
    if (_order is EqualUnmodifiableMapView) return _order;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _product;
  @override
  Map<String, dynamic>? get product {
    final value = _product;
    if (value == null) return null;
    if (_product is EqualUnmodifiableMapView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReturnRequest(id: $id, orderId: $orderId, productId: $productId, returnStatus: $returnStatus, returnReason: $returnReason, returnRequestedAt: $returnRequestedAt, returnProcessedAt: $returnProcessedAt, order: $order, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.returnStatus, returnStatus) ||
                other.returnStatus == returnStatus) &&
            (identical(other.returnReason, returnReason) ||
                other.returnReason == returnReason) &&
            (identical(other.returnRequestedAt, returnRequestedAt) ||
                other.returnRequestedAt == returnRequestedAt) &&
            (identical(other.returnProcessedAt, returnProcessedAt) ||
                other.returnProcessedAt == returnProcessedAt) &&
            const DeepCollectionEquality().equals(other._order, _order) &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    productId,
    returnStatus,
    returnReason,
    returnRequestedAt,
    returnProcessedAt,
    const DeepCollectionEquality().hash(_order),
    const DeepCollectionEquality().hash(_product),
  );

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnRequestImplCopyWith<_$ReturnRequestImpl> get copyWith =>
      _$$ReturnRequestImplCopyWithImpl<_$ReturnRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReturnRequestImplToJson(this);
  }
}

abstract class _ReturnRequest implements ReturnRequest {
  const factory _ReturnRequest({
    required final String id,
    @JsonKey(name: 'order_id') required final String orderId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'return_status') final String? returnStatus,
    @JsonKey(name: 'return_reason') final String? returnReason,
    @JsonKey(name: 'return_requested_at') final DateTime? returnRequestedAt,
    @JsonKey(name: 'return_processed_at') final DateTime? returnProcessedAt,
    final Map<String, dynamic>? order,
    final Map<String, dynamic>? product,
  }) = _$ReturnRequestImpl;

  factory _ReturnRequest.fromJson(Map<String, dynamic> json) =
      _$ReturnRequestImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'return_status')
  String? get returnStatus;
  @override
  @JsonKey(name: 'return_reason')
  String? get returnReason;
  @override
  @JsonKey(name: 'return_requested_at')
  DateTime? get returnRequestedAt;
  @override
  @JsonKey(name: 'return_processed_at')
  DateTime? get returnProcessedAt; // Add joined fields for UI if they come from Supabase query
  @override
  Map<String, dynamic>? get order;
  @override
  Map<String, dynamic>? get product;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReturnRequestImplCopyWith<_$ReturnRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
