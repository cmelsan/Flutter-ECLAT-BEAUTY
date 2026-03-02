// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'invoice' | 'credit_note'
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_invoice_id')
  String? get referenceInvoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_note_scope')
  String? get creditNoteScope => throw _privateConstructorUsedError;
  int get subtotal => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'tax_rate')
  num get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  int get taxAmount => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'discount_amount')
  int get discountAmount => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_address')
  Map<String, dynamic>? get customerAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_nif')
  String? get customerNif => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_items')
  List<InvoiceLineItem> get lineItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'stripe_refund_id')
  String? get stripeRefundId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'issued_at')
  DateTime? get issuedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Joined order data (from select with join)
  Map<String, dynamic>? get orders => throw _privateConstructorUsedError;

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call({
    String id,
    String type,
    @JsonKey(name: 'invoice_number') String invoiceNumber,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'reference_invoice_id') String? referenceInvoiceId,
    @JsonKey(name: 'credit_note_scope') String? creditNoteScope,
    int subtotal,
    @JsonKey(name: 'tax_rate') num taxRate,
    @JsonKey(name: 'tax_amount') int taxAmount,
    @JsonKey(name: 'discount_amount') int discountAmount,
    @JsonKey(name: 'total_amount') int totalAmount,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_address') Map<String, dynamic>? customerAddress,
    @JsonKey(name: 'customer_nif') String? customerNif,
    @JsonKey(name: 'line_items') List<InvoiceLineItem> lineItems,
    @JsonKey(name: 'stripe_refund_id') String? stripeRefundId,
    String? notes,
    @JsonKey(name: 'issued_at') DateTime? issuedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Map<String, dynamic>? orders,
  });
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? invoiceNumber = null,
    Object? orderId = null,
    Object? referenceInvoiceId = freezed,
    Object? creditNoteScope = freezed,
    Object? subtotal = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? customerNif = freezed,
    Object? lineItems = null,
    Object? stripeRefundId = freezed,
    Object? notes = freezed,
    Object? issuedAt = freezed,
    Object? createdAt = freezed,
    Object? orders = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            invoiceNumber: null == invoiceNumber
                ? _value.invoiceNumber
                : invoiceNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceInvoiceId: freezed == referenceInvoiceId
                ? _value.referenceInvoiceId
                : referenceInvoiceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            creditNoteScope: freezed == creditNoteScope
                ? _value.creditNoteScope
                : creditNoteScope // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as int,
            taxRate: null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as num,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerAddress: freezed == customerAddress
                ? _value.customerAddress
                : customerAddress // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            customerNif: freezed == customerNif
                ? _value.customerNif
                : customerNif // ignore: cast_nullable_to_non_nullable
                      as String?,
            lineItems: null == lineItems
                ? _value.lineItems
                : lineItems // ignore: cast_nullable_to_non_nullable
                      as List<InvoiceLineItem>,
            stripeRefundId: freezed == stripeRefundId
                ? _value.stripeRefundId
                : stripeRefundId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            issuedAt: freezed == issuedAt
                ? _value.issuedAt
                : issuedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            orders: freezed == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
    _$InvoiceImpl value,
    $Res Function(_$InvoiceImpl) then,
  ) = __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    @JsonKey(name: 'invoice_number') String invoiceNumber,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'reference_invoice_id') String? referenceInvoiceId,
    @JsonKey(name: 'credit_note_scope') String? creditNoteScope,
    int subtotal,
    @JsonKey(name: 'tax_rate') num taxRate,
    @JsonKey(name: 'tax_amount') int taxAmount,
    @JsonKey(name: 'discount_amount') int discountAmount,
    @JsonKey(name: 'total_amount') int totalAmount,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_address') Map<String, dynamic>? customerAddress,
    @JsonKey(name: 'customer_nif') String? customerNif,
    @JsonKey(name: 'line_items') List<InvoiceLineItem> lineItems,
    @JsonKey(name: 'stripe_refund_id') String? stripeRefundId,
    String? notes,
    @JsonKey(name: 'issued_at') DateTime? issuedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Map<String, dynamic>? orders,
  });
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
    _$InvoiceImpl _value,
    $Res Function(_$InvoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? invoiceNumber = null,
    Object? orderId = null,
    Object? referenceInvoiceId = freezed,
    Object? creditNoteScope = freezed,
    Object? subtotal = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? customerNif = freezed,
    Object? lineItems = null,
    Object? stripeRefundId = freezed,
    Object? notes = freezed,
    Object? issuedAt = freezed,
    Object? createdAt = freezed,
    Object? orders = freezed,
  }) {
    return _then(
      _$InvoiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        invoiceNumber: null == invoiceNumber
            ? _value.invoiceNumber
            : invoiceNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceInvoiceId: freezed == referenceInvoiceId
            ? _value.referenceInvoiceId
            : referenceInvoiceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        creditNoteScope: freezed == creditNoteScope
            ? _value.creditNoteScope
            : creditNoteScope // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as int,
        taxRate: null == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as num,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerAddress: freezed == customerAddress
            ? _value._customerAddress
            : customerAddress // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        customerNif: freezed == customerNif
            ? _value.customerNif
            : customerNif // ignore: cast_nullable_to_non_nullable
                  as String?,
        lineItems: null == lineItems
            ? _value._lineItems
            : lineItems // ignore: cast_nullable_to_non_nullable
                  as List<InvoiceLineItem>,
        stripeRefundId: freezed == stripeRefundId
            ? _value.stripeRefundId
            : stripeRefundId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        issuedAt: freezed == issuedAt
            ? _value.issuedAt
            : issuedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        orders: freezed == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl({
    required this.id,
    required this.type,
    @JsonKey(name: 'invoice_number') required this.invoiceNumber,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'reference_invoice_id') this.referenceInvoiceId,
    @JsonKey(name: 'credit_note_scope') this.creditNoteScope,
    required this.subtotal,
    @JsonKey(name: 'tax_rate') required this.taxRate,
    @JsonKey(name: 'tax_amount') required this.taxAmount,
    @JsonKey(name: 'discount_amount') this.discountAmount = 0,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(name: 'customer_name') this.customerName,
    @JsonKey(name: 'customer_email') this.customerEmail,
    @JsonKey(name: 'customer_address')
    final Map<String, dynamic>? customerAddress,
    @JsonKey(name: 'customer_nif') this.customerNif,
    @JsonKey(name: 'line_items')
    final List<InvoiceLineItem> lineItems = const [],
    @JsonKey(name: 'stripe_refund_id') this.stripeRefundId,
    this.notes,
    @JsonKey(name: 'issued_at') this.issuedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    final Map<String, dynamic>? orders,
  }) : _customerAddress = customerAddress,
       _lineItems = lineItems,
       _orders = orders;

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  // 'invoice' | 'credit_note'
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'reference_invoice_id')
  final String? referenceInvoiceId;
  @override
  @JsonKey(name: 'credit_note_scope')
  final String? creditNoteScope;
  @override
  final int subtotal;
  // cents
  @override
  @JsonKey(name: 'tax_rate')
  final num taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  final int taxAmount;
  // cents
  @override
  @JsonKey(name: 'discount_amount')
  final int discountAmount;
  // cents
  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  // cents
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  final Map<String, dynamic>? _customerAddress;
  @override
  @JsonKey(name: 'customer_address')
  Map<String, dynamic>? get customerAddress {
    final value = _customerAddress;
    if (value == null) return null;
    if (_customerAddress is EqualUnmodifiableMapView) return _customerAddress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'customer_nif')
  final String? customerNif;
  final List<InvoiceLineItem> _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<InvoiceLineItem> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  @JsonKey(name: 'stripe_refund_id')
  final String? stripeRefundId;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'issued_at')
  final DateTime? issuedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Joined order data (from select with join)
  final Map<String, dynamic>? _orders;
  // Joined order data (from select with join)
  @override
  Map<String, dynamic>? get orders {
    final value = _orders;
    if (value == null) return null;
    if (_orders is EqualUnmodifiableMapView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Invoice(id: $id, type: $type, invoiceNumber: $invoiceNumber, orderId: $orderId, referenceInvoiceId: $referenceInvoiceId, creditNoteScope: $creditNoteScope, subtotal: $subtotal, taxRate: $taxRate, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, customerName: $customerName, customerEmail: $customerEmail, customerAddress: $customerAddress, customerNif: $customerNif, lineItems: $lineItems, stripeRefundId: $stripeRefundId, notes: $notes, issuedAt: $issuedAt, createdAt: $createdAt, orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.referenceInvoiceId, referenceInvoiceId) ||
                other.referenceInvoiceId == referenceInvoiceId) &&
            (identical(other.creditNoteScope, creditNoteScope) ||
                other.creditNoteScope == creditNoteScope) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            const DeepCollectionEquality().equals(
              other._customerAddress,
              _customerAddress,
            ) &&
            (identical(other.customerNif, customerNif) ||
                other.customerNif == customerNif) &&
            const DeepCollectionEquality().equals(
              other._lineItems,
              _lineItems,
            ) &&
            (identical(other.stripeRefundId, stripeRefundId) ||
                other.stripeRefundId == stripeRefundId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    type,
    invoiceNumber,
    orderId,
    referenceInvoiceId,
    creditNoteScope,
    subtotal,
    taxRate,
    taxAmount,
    discountAmount,
    totalAmount,
    customerName,
    customerEmail,
    const DeepCollectionEquality().hash(_customerAddress),
    customerNif,
    const DeepCollectionEquality().hash(_lineItems),
    stripeRefundId,
    notes,
    issuedAt,
    createdAt,
    const DeepCollectionEquality().hash(_orders),
  ]);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(this);
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice({
    required final String id,
    required final String type,
    @JsonKey(name: 'invoice_number') required final String invoiceNumber,
    @JsonKey(name: 'order_id') required final String orderId,
    @JsonKey(name: 'reference_invoice_id') final String? referenceInvoiceId,
    @JsonKey(name: 'credit_note_scope') final String? creditNoteScope,
    required final int subtotal,
    @JsonKey(name: 'tax_rate') required final num taxRate,
    @JsonKey(name: 'tax_amount') required final int taxAmount,
    @JsonKey(name: 'discount_amount') final int discountAmount,
    @JsonKey(name: 'total_amount') required final int totalAmount,
    @JsonKey(name: 'customer_name') final String? customerName,
    @JsonKey(name: 'customer_email') final String? customerEmail,
    @JsonKey(name: 'customer_address')
    final Map<String, dynamic>? customerAddress,
    @JsonKey(name: 'customer_nif') final String? customerNif,
    @JsonKey(name: 'line_items') final List<InvoiceLineItem> lineItems,
    @JsonKey(name: 'stripe_refund_id') final String? stripeRefundId,
    final String? notes,
    @JsonKey(name: 'issued_at') final DateTime? issuedAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    final Map<String, dynamic>? orders,
  }) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'invoice' | 'credit_note'
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'reference_invoice_id')
  String? get referenceInvoiceId;
  @override
  @JsonKey(name: 'credit_note_scope')
  String? get creditNoteScope;
  @override
  int get subtotal; // cents
  @override
  @JsonKey(name: 'tax_rate')
  num get taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  int get taxAmount; // cents
  @override
  @JsonKey(name: 'discount_amount')
  int get discountAmount; // cents
  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount; // cents
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'customer_address')
  Map<String, dynamic>? get customerAddress;
  @override
  @JsonKey(name: 'customer_nif')
  String? get customerNif;
  @override
  @JsonKey(name: 'line_items')
  List<InvoiceLineItem> get lineItems;
  @override
  @JsonKey(name: 'stripe_refund_id')
  String? get stripeRefundId;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'issued_at')
  DateTime? get issuedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Joined order data (from select with join)
  @override
  Map<String, dynamic>? get orders;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvoiceLineItem _$InvoiceLineItemFromJson(Map<String, dynamic> json) {
  return _InvoiceLineItem.fromJson(json);
}

/// @nodoc
mixin _$InvoiceLineItem {
  @JsonKey(name: 'order_item_id')
  String? get orderItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String? get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_gross')
  int get unitPriceGross => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'unit_price_net')
  int get unitPriceNet => throw _privateConstructorUsedError; // cents
  @JsonKey(name: 'tax_rate')
  num get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_total')
  int get lineTotal => throw _privateConstructorUsedError;

  /// Serializes this InvoiceLineItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceLineItemCopyWith<InvoiceLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceLineItemCopyWith<$Res> {
  factory $InvoiceLineItemCopyWith(
    InvoiceLineItem value,
    $Res Function(InvoiceLineItem) then,
  ) = _$InvoiceLineItemCopyWithImpl<$Res, InvoiceLineItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'order_item_id') String? orderItemId,
    @JsonKey(name: 'product_id') String? productId,
    String name,
    int quantity,
    @JsonKey(name: 'unit_price_gross') int unitPriceGross,
    @JsonKey(name: 'unit_price_net') int unitPriceNet,
    @JsonKey(name: 'tax_rate') num taxRate,
    @JsonKey(name: 'line_total') int lineTotal,
  });
}

/// @nodoc
class _$InvoiceLineItemCopyWithImpl<$Res, $Val extends InvoiceLineItem>
    implements $InvoiceLineItemCopyWith<$Res> {
  _$InvoiceLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = freezed,
    Object? productId = freezed,
    Object? name = null,
    Object? quantity = null,
    Object? unitPriceGross = null,
    Object? unitPriceNet = null,
    Object? taxRate = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _value.copyWith(
            orderItemId: freezed == orderItemId
                ? _value.orderItemId
                : orderItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPriceGross: null == unitPriceGross
                ? _value.unitPriceGross
                : unitPriceGross // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPriceNet: null == unitPriceNet
                ? _value.unitPriceNet
                : unitPriceNet // ignore: cast_nullable_to_non_nullable
                      as int,
            taxRate: null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as num,
            lineTotal: null == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoiceLineItemImplCopyWith<$Res>
    implements $InvoiceLineItemCopyWith<$Res> {
  factory _$$InvoiceLineItemImplCopyWith(
    _$InvoiceLineItemImpl value,
    $Res Function(_$InvoiceLineItemImpl) then,
  ) = __$$InvoiceLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'order_item_id') String? orderItemId,
    @JsonKey(name: 'product_id') String? productId,
    String name,
    int quantity,
    @JsonKey(name: 'unit_price_gross') int unitPriceGross,
    @JsonKey(name: 'unit_price_net') int unitPriceNet,
    @JsonKey(name: 'tax_rate') num taxRate,
    @JsonKey(name: 'line_total') int lineTotal,
  });
}

/// @nodoc
class __$$InvoiceLineItemImplCopyWithImpl<$Res>
    extends _$InvoiceLineItemCopyWithImpl<$Res, _$InvoiceLineItemImpl>
    implements _$$InvoiceLineItemImplCopyWith<$Res> {
  __$$InvoiceLineItemImplCopyWithImpl(
    _$InvoiceLineItemImpl _value,
    $Res Function(_$InvoiceLineItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoiceLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = freezed,
    Object? productId = freezed,
    Object? name = null,
    Object? quantity = null,
    Object? unitPriceGross = null,
    Object? unitPriceNet = null,
    Object? taxRate = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _$InvoiceLineItemImpl(
        orderItemId: freezed == orderItemId
            ? _value.orderItemId
            : orderItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPriceGross: null == unitPriceGross
            ? _value.unitPriceGross
            : unitPriceGross // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPriceNet: null == unitPriceNet
            ? _value.unitPriceNet
            : unitPriceNet // ignore: cast_nullable_to_non_nullable
                  as int,
        taxRate: null == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as num,
        lineTotal: null == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceLineItemImpl implements _InvoiceLineItem {
  const _$InvoiceLineItemImpl({
    @JsonKey(name: 'order_item_id') this.orderItemId,
    @JsonKey(name: 'product_id') this.productId,
    required this.name,
    required this.quantity,
    @JsonKey(name: 'unit_price_gross') required this.unitPriceGross,
    @JsonKey(name: 'unit_price_net') required this.unitPriceNet,
    @JsonKey(name: 'tax_rate') required this.taxRate,
    @JsonKey(name: 'line_total') required this.lineTotal,
  });

  factory _$InvoiceLineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceLineItemImplFromJson(json);

  @override
  @JsonKey(name: 'order_item_id')
  final String? orderItemId;
  @override
  @JsonKey(name: 'product_id')
  final String? productId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price_gross')
  final int unitPriceGross;
  // cents
  @override
  @JsonKey(name: 'unit_price_net')
  final int unitPriceNet;
  // cents
  @override
  @JsonKey(name: 'tax_rate')
  final num taxRate;
  @override
  @JsonKey(name: 'line_total')
  final int lineTotal;

  @override
  String toString() {
    return 'InvoiceLineItem(orderItemId: $orderItemId, productId: $productId, name: $name, quantity: $quantity, unitPriceGross: $unitPriceGross, unitPriceNet: $unitPriceNet, taxRate: $taxRate, lineTotal: $lineTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceLineItemImpl &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPriceGross, unitPriceGross) ||
                other.unitPriceGross == unitPriceGross) &&
            (identical(other.unitPriceNet, unitPriceNet) ||
                other.unitPriceNet == unitPriceNet) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderItemId,
    productId,
    name,
    quantity,
    unitPriceGross,
    unitPriceNet,
    taxRate,
    lineTotal,
  );

  /// Create a copy of InvoiceLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceLineItemImplCopyWith<_$InvoiceLineItemImpl> get copyWith =>
      __$$InvoiceLineItemImplCopyWithImpl<_$InvoiceLineItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceLineItemImplToJson(this);
  }
}

abstract class _InvoiceLineItem implements InvoiceLineItem {
  const factory _InvoiceLineItem({
    @JsonKey(name: 'order_item_id') final String? orderItemId,
    @JsonKey(name: 'product_id') final String? productId,
    required final String name,
    required final int quantity,
    @JsonKey(name: 'unit_price_gross') required final int unitPriceGross,
    @JsonKey(name: 'unit_price_net') required final int unitPriceNet,
    @JsonKey(name: 'tax_rate') required final num taxRate,
    @JsonKey(name: 'line_total') required final int lineTotal,
  }) = _$InvoiceLineItemImpl;

  factory _InvoiceLineItem.fromJson(Map<String, dynamic> json) =
      _$InvoiceLineItemImpl.fromJson;

  @override
  @JsonKey(name: 'order_item_id')
  String? get orderItemId;
  @override
  @JsonKey(name: 'product_id')
  String? get productId;
  @override
  String get name;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price_gross')
  int get unitPriceGross; // cents
  @override
  @JsonKey(name: 'unit_price_net')
  int get unitPriceNet; // cents
  @override
  @JsonKey(name: 'tax_rate')
  num get taxRate;
  @override
  @JsonKey(name: 'line_total')
  int get lineTotal;

  /// Create a copy of InvoiceLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceLineItemImplCopyWith<_$InvoiceLineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
