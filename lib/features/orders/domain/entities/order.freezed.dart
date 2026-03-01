// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_email')
  String? get guestEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_id')
  String? get couponId => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  int get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_initiated_at')
  DateTime? get returnInitiatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_deadline_at')
  DateTime? get returnDeadlineAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_reason')
  String? get returnReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_address')
  Map<String, dynamic>? get returnAddress => throw _privateConstructorUsedError; // Relations
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'customer_name') String? customerName,
    String status,
    @JsonKey(name: 'total_amount') int totalAmount,
    @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'coupon_id') String? couponId,
    @JsonKey(name: 'discount_amount') int discountAmount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'return_initiated_at') DateTime? returnInitiatedAt,
    @JsonKey(name: 'return_deadline_at') DateTime? returnDeadlineAt,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_address') Map<String, dynamic>? returnAddress,
    @JsonKey(name: 'order_items') List<OrderItem> orderItems,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = freezed,
    Object? guestEmail = freezed,
    Object? customerName = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? shippingAddress = freezed,
    Object? couponId = freezed,
    Object? discountAmount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deliveredAt = freezed,
    Object? returnInitiatedAt = freezed,
    Object? returnDeadlineAt = freezed,
    Object? returnReason = freezed,
    Object? returnAddress = freezed,
    Object? orderItems = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestEmail: freezed == guestEmail
                ? _value.guestEmail
                : guestEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            shippingAddress: freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            couponId: freezed == couponId
                ? _value.couponId
                : couponId // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveredAt: freezed == deliveredAt
                ? _value.deliveredAt
                : deliveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            returnInitiatedAt: freezed == returnInitiatedAt
                ? _value.returnInitiatedAt
                : returnInitiatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            returnDeadlineAt: freezed == returnDeadlineAt
                ? _value.returnDeadlineAt
                : returnDeadlineAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            returnReason: freezed == returnReason
                ? _value.returnReason
                : returnReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            returnAddress: freezed == returnAddress
                ? _value.returnAddress
                : returnAddress // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            orderItems: null == orderItems
                ? _value.orderItems
                : orderItems // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'customer_name') String? customerName,
    String status,
    @JsonKey(name: 'total_amount') int totalAmount,
    @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'coupon_id') String? couponId,
    @JsonKey(name: 'discount_amount') int discountAmount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'return_initiated_at') DateTime? returnInitiatedAt,
    @JsonKey(name: 'return_deadline_at') DateTime? returnDeadlineAt,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_address') Map<String, dynamic>? returnAddress,
    @JsonKey(name: 'order_items') List<OrderItem> orderItems,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = freezed,
    Object? guestEmail = freezed,
    Object? customerName = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? shippingAddress = freezed,
    Object? couponId = freezed,
    Object? discountAmount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deliveredAt = freezed,
    Object? returnInitiatedAt = freezed,
    Object? returnDeadlineAt = freezed,
    Object? returnReason = freezed,
    Object? returnAddress = freezed,
    Object? orderItems = null,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestEmail: freezed == guestEmail
            ? _value.guestEmail
            : guestEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        shippingAddress: freezed == shippingAddress
            ? _value._shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        couponId: freezed == couponId
            ? _value.couponId
            : couponId // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveredAt: freezed == deliveredAt
            ? _value.deliveredAt
            : deliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        returnInitiatedAt: freezed == returnInitiatedAt
            ? _value.returnInitiatedAt
            : returnInitiatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        returnDeadlineAt: freezed == returnDeadlineAt
            ? _value.returnDeadlineAt
            : returnDeadlineAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        returnReason: freezed == returnReason
            ? _value.returnReason
            : returnReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        returnAddress: freezed == returnAddress
            ? _value._returnAddress
            : returnAddress // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        orderItems: null == orderItems
            ? _value._orderItems
            : orderItems // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    @JsonKey(name: 'order_number') required this.orderNumber,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'guest_email') this.guestEmail,
    @JsonKey(name: 'customer_name') this.customerName,
    required this.status,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(name: 'shipping_address')
    final Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'coupon_id') this.couponId,
    @JsonKey(name: 'discount_amount') this.discountAmount = 0,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'delivered_at') this.deliveredAt,
    @JsonKey(name: 'return_initiated_at') this.returnInitiatedAt,
    @JsonKey(name: 'return_deadline_at') this.returnDeadlineAt,
    @JsonKey(name: 'return_reason') this.returnReason,
    @JsonKey(name: 'return_address') final Map<String, dynamic>? returnAddress,
    @JsonKey(name: 'order_items') final List<OrderItem> orderItems = const [],
  }) : _shippingAddress = shippingAddress,
       _returnAddress = returnAddress,
       _orderItems = orderItems;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'guest_email')
  final String? guestEmail;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  final String status;
  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  // cents
  final Map<String, dynamic>? _shippingAddress;
  // cents
  @override
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress {
    final value = _shippingAddress;
    if (value == null) return null;
    if (_shippingAddress is EqualUnmodifiableMapView) return _shippingAddress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'coupon_id')
  final String? couponId;
  @override
  @JsonKey(name: 'discount_amount')
  final int discountAmount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @override
  @JsonKey(name: 'return_initiated_at')
  final DateTime? returnInitiatedAt;
  @override
  @JsonKey(name: 'return_deadline_at')
  final DateTime? returnDeadlineAt;
  @override
  @JsonKey(name: 'return_reason')
  final String? returnReason;
  final Map<String, dynamic>? _returnAddress;
  @override
  @JsonKey(name: 'return_address')
  Map<String, dynamic>? get returnAddress {
    final value = _returnAddress;
    if (value == null) return null;
    if (_returnAddress is EqualUnmodifiableMapView) return _returnAddress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Relations
  final List<OrderItem> _orderItems;
  // Relations
  @override
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, userId: $userId, guestEmail: $guestEmail, customerName: $customerName, status: $status, totalAmount: $totalAmount, shippingAddress: $shippingAddress, couponId: $couponId, discountAmount: $discountAmount, createdAt: $createdAt, updatedAt: $updatedAt, deliveredAt: $deliveredAt, returnInitiatedAt: $returnInitiatedAt, returnDeadlineAt: $returnDeadlineAt, returnReason: $returnReason, returnAddress: $returnAddress, orderItems: $orderItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.guestEmail, guestEmail) ||
                other.guestEmail == guestEmail) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(
              other._shippingAddress,
              _shippingAddress,
            ) &&
            (identical(other.couponId, couponId) ||
                other.couponId == couponId) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.returnInitiatedAt, returnInitiatedAt) ||
                other.returnInitiatedAt == returnInitiatedAt) &&
            (identical(other.returnDeadlineAt, returnDeadlineAt) ||
                other.returnDeadlineAt == returnDeadlineAt) &&
            (identical(other.returnReason, returnReason) ||
                other.returnReason == returnReason) &&
            const DeepCollectionEquality().equals(
              other._returnAddress,
              _returnAddress,
            ) &&
            const DeepCollectionEquality().equals(
              other._orderItems,
              _orderItems,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNumber,
    userId,
    guestEmail,
    customerName,
    status,
    totalAmount,
    const DeepCollectionEquality().hash(_shippingAddress),
    couponId,
    discountAmount,
    createdAt,
    updatedAt,
    deliveredAt,
    returnInitiatedAt,
    returnDeadlineAt,
    returnReason,
    const DeepCollectionEquality().hash(_returnAddress),
    const DeepCollectionEquality().hash(_orderItems),
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final String id,
    @JsonKey(name: 'order_number') required final String orderNumber,
    @JsonKey(name: 'user_id') final String? userId,
    @JsonKey(name: 'guest_email') final String? guestEmail,
    @JsonKey(name: 'customer_name') final String? customerName,
    required final String status,
    @JsonKey(name: 'total_amount') required final int totalAmount,
    @JsonKey(name: 'shipping_address')
    final Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'coupon_id') final String? couponId,
    @JsonKey(name: 'discount_amount') final int discountAmount,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'delivered_at') final DateTime? deliveredAt,
    @JsonKey(name: 'return_initiated_at') final DateTime? returnInitiatedAt,
    @JsonKey(name: 'return_deadline_at') final DateTime? returnDeadlineAt,
    @JsonKey(name: 'return_reason') final String? returnReason,
    @JsonKey(name: 'return_address') final Map<String, dynamic>? returnAddress,
    @JsonKey(name: 'order_items') final List<OrderItem> orderItems,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'guest_email')
  String? get guestEmail;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  String get status;
  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount; // cents
  @override
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress;
  @override
  @JsonKey(name: 'coupon_id')
  String? get couponId;
  @override
  @JsonKey(name: 'discount_amount')
  int get discountAmount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;
  @override
  @JsonKey(name: 'return_initiated_at')
  DateTime? get returnInitiatedAt;
  @override
  @JsonKey(name: 'return_deadline_at')
  DateTime? get returnDeadlineAt;
  @override
  @JsonKey(name: 'return_reason')
  String? get returnReason;
  @override
  @JsonKey(name: 'return_address')
  Map<String, dynamic>? get returnAddress; // Relations
  @override
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_at_purchase')
  int get priceAtPurchase => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'return_status')
  String? get returnStatus => throw _privateConstructorUsedError; // Joined product data
  Map<String, dynamic>? get product => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'product_id') String productId,
    int quantity,
    @JsonKey(name: 'price_at_purchase') int priceAtPurchase,
    @JsonKey(name: 'return_status') String? returnStatus,
    Map<String, dynamic>? product,
  });
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? quantity = null,
    Object? priceAtPurchase = null,
    Object? returnStatus = freezed,
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
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            priceAtPurchase: null == priceAtPurchase
                ? _value.priceAtPurchase
                : priceAtPurchase // ignore: cast_nullable_to_non_nullable
                      as int,
            returnStatus: freezed == returnStatus
                ? _value.returnStatus
                : returnStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'product_id') String productId,
    int quantity,
    @JsonKey(name: 'price_at_purchase') int priceAtPurchase,
    @JsonKey(name: 'return_status') String? returnStatus,
    Map<String, dynamic>? product,
  });
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? quantity = null,
    Object? priceAtPurchase = null,
    Object? returnStatus = freezed,
    Object? product = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
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
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        priceAtPurchase: null == priceAtPurchase
            ? _value.priceAtPurchase
            : priceAtPurchase // ignore: cast_nullable_to_non_nullable
                  as int,
        returnStatus: freezed == returnStatus
            ? _value.returnStatus
            : returnStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'product_id') required this.productId,
    required this.quantity,
    @JsonKey(name: 'price_at_purchase') required this.priceAtPurchase,
    @JsonKey(name: 'return_status') this.returnStatus,
    final Map<String, dynamic>? product,
  }) : _product = product;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'price_at_purchase')
  final int priceAtPurchase;
  // cents
  @override
  @JsonKey(name: 'return_status')
  final String? returnStatus;
  // Joined product data
  final Map<String, dynamic>? _product;
  // Joined product data
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
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, quantity: $quantity, priceAtPurchase: $priceAtPurchase, returnStatus: $returnStatus, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.priceAtPurchase, priceAtPurchase) ||
                other.priceAtPurchase == priceAtPurchase) &&
            (identical(other.returnStatus, returnStatus) ||
                other.returnStatus == returnStatus) &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    productId,
    quantity,
    priceAtPurchase,
    returnStatus,
    const DeepCollectionEquality().hash(_product),
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final String id,
    @JsonKey(name: 'order_id') required final String orderId,
    @JsonKey(name: 'product_id') required final String productId,
    required final int quantity,
    @JsonKey(name: 'price_at_purchase') required final int priceAtPurchase,
    @JsonKey(name: 'return_status') final String? returnStatus,
    final Map<String, dynamic>? product,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'price_at_purchase')
  int get priceAtPurchase; // cents
  @override
  @JsonKey(name: 'return_status')
  String? get returnStatus; // Joined product data
  @override
  Map<String, dynamic>? get product;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) {
  return _OrderStatusHistory.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusHistory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_status')
  String? get fromStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_status')
  String get toStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'changed_by')
  String? get changedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'changed_by_type')
  String? get changedByType => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusHistoryCopyWith<OrderStatusHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusHistoryCopyWith<$Res> {
  factory $OrderStatusHistoryCopyWith(
    OrderStatusHistory value,
    $Res Function(OrderStatusHistory) then,
  ) = _$OrderStatusHistoryCopyWithImpl<$Res, OrderStatusHistory>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'from_status') String? fromStatus,
    @JsonKey(name: 'to_status') String toStatus,
    @JsonKey(name: 'changed_by') String? changedBy,
    @JsonKey(name: 'changed_by_type') String? changedByType,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$OrderStatusHistoryCopyWithImpl<$Res, $Val extends OrderStatusHistory>
    implements $OrderStatusHistoryCopyWith<$Res> {
  _$OrderStatusHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = freezed,
    Object? fromStatus = freezed,
    Object? toStatus = null,
    Object? changedBy = freezed,
    Object? changedByType = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fromStatus: freezed == fromStatus
                ? _value.fromStatus
                : fromStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            toStatus: null == toStatus
                ? _value.toStatus
                : toStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            changedBy: freezed == changedBy
                ? _value.changedBy
                : changedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            changedByType: freezed == changedByType
                ? _value.changedByType
                : changedByType // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$OrderStatusHistoryImplCopyWith<$Res>
    implements $OrderStatusHistoryCopyWith<$Res> {
  factory _$$OrderStatusHistoryImplCopyWith(
    _$OrderStatusHistoryImpl value,
    $Res Function(_$OrderStatusHistoryImpl) then,
  ) = __$$OrderStatusHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'from_status') String? fromStatus,
    @JsonKey(name: 'to_status') String toStatus,
    @JsonKey(name: 'changed_by') String? changedBy,
    @JsonKey(name: 'changed_by_type') String? changedByType,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$OrderStatusHistoryImplCopyWithImpl<$Res>
    extends _$OrderStatusHistoryCopyWithImpl<$Res, _$OrderStatusHistoryImpl>
    implements _$$OrderStatusHistoryImplCopyWith<$Res> {
  __$$OrderStatusHistoryImplCopyWithImpl(
    _$OrderStatusHistoryImpl _value,
    $Res Function(_$OrderStatusHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = freezed,
    Object? fromStatus = freezed,
    Object? toStatus = null,
    Object? changedBy = freezed,
    Object? changedByType = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$OrderStatusHistoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: freezed == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fromStatus: freezed == fromStatus
            ? _value.fromStatus
            : fromStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        toStatus: null == toStatus
            ? _value.toStatus
            : toStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        changedBy: freezed == changedBy
            ? _value.changedBy
            : changedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        changedByType: freezed == changedByType
            ? _value.changedByType
            : changedByType // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$OrderStatusHistoryImpl implements _OrderStatusHistory {
  const _$OrderStatusHistoryImpl({
    required this.id,
    @JsonKey(name: 'order_id') this.orderId,
    @JsonKey(name: 'from_status') this.fromStatus,
    @JsonKey(name: 'to_status') required this.toStatus,
    @JsonKey(name: 'changed_by') this.changedBy,
    @JsonKey(name: 'changed_by_type') this.changedByType,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$OrderStatusHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusHistoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'from_status')
  final String? fromStatus;
  @override
  @JsonKey(name: 'to_status')
  final String toStatus;
  @override
  @JsonKey(name: 'changed_by')
  final String? changedBy;
  @override
  @JsonKey(name: 'changed_by_type')
  final String? changedByType;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OrderStatusHistory(id: $id, orderId: $orderId, fromStatus: $fromStatus, toStatus: $toStatus, changedBy: $changedBy, changedByType: $changedByType, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedByType, changedByType) ||
                other.changedByType == changedByType) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    fromStatus,
    toStatus,
    changedBy,
    changedByType,
    notes,
    createdAt,
  );

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      __$$OrderStatusHistoryImplCopyWithImpl<_$OrderStatusHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusHistoryImplToJson(this);
  }
}

abstract class _OrderStatusHistory implements OrderStatusHistory {
  const factory _OrderStatusHistory({
    required final String id,
    @JsonKey(name: 'order_id') final String? orderId,
    @JsonKey(name: 'from_status') final String? fromStatus,
    @JsonKey(name: 'to_status') required final String toStatus,
    @JsonKey(name: 'changed_by') final String? changedBy,
    @JsonKey(name: 'changed_by_type') final String? changedByType,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$OrderStatusHistoryImpl;

  factory _OrderStatusHistory.fromJson(Map<String, dynamic> json) =
      _$OrderStatusHistoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'from_status')
  String? get fromStatus;
  @override
  @JsonKey(name: 'to_status')
  String get toStatus;
  @override
  @JsonKey(name: 'changed_by')
  String? get changedBy;
  @override
  @JsonKey(name: 'changed_by_type')
  String? get changedByType;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
