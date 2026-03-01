// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flash_sales_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FlashSalesState {
  bool get isEnabled => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get products => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  Duration get timeRemaining => throw _privateConstructorUsedError;
  bool get isExpired => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of FlashSalesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashSalesStateCopyWith<FlashSalesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashSalesStateCopyWith<$Res> {
  factory $FlashSalesStateCopyWith(
    FlashSalesState value,
    $Res Function(FlashSalesState) then,
  ) = _$FlashSalesStateCopyWithImpl<$Res, FlashSalesState>;
  @useResult
  $Res call({
    bool isEnabled,
    List<Map<String, dynamic>> products,
    bool isLoading,
    DateTime? endTime,
    Duration timeRemaining,
    bool isExpired,
    String? error,
  });
}

/// @nodoc
class _$FlashSalesStateCopyWithImpl<$Res, $Val extends FlashSalesState>
    implements $FlashSalesStateCopyWith<$Res> {
  _$FlashSalesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashSalesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? products = null,
    Object? isLoading = null,
    Object? endTime = freezed,
    Object? timeRemaining = null,
    Object? isExpired = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            timeRemaining: null == timeRemaining
                ? _value.timeRemaining
                : timeRemaining // ignore: cast_nullable_to_non_nullable
                      as Duration,
            isExpired: null == isExpired
                ? _value.isExpired
                : isExpired // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlashSalesStateImplCopyWith<$Res>
    implements $FlashSalesStateCopyWith<$Res> {
  factory _$$FlashSalesStateImplCopyWith(
    _$FlashSalesStateImpl value,
    $Res Function(_$FlashSalesStateImpl) then,
  ) = _$$FlashSalesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isEnabled,
    List<Map<String, dynamic>> products,
    bool isLoading,
    DateTime? endTime,
    Duration timeRemaining,
    bool isExpired,
    String? error,
  });
}

/// @nodoc
class _$$FlashSalesStateImplCopyWithImpl<$Res>
    extends _$FlashSalesStateCopyWithImpl<$Res, _$FlashSalesStateImpl>
    implements _$$FlashSalesStateImplCopyWith<$Res> {
  _$$FlashSalesStateImplCopyWithImpl(
    _$FlashSalesStateImpl _value,
    $Res Function(_$FlashSalesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlashSalesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? products = null,
    Object? isLoading = null,
    Object? endTime = freezed,
    Object? timeRemaining = null,
    Object? isExpired = null,
    Object? error = freezed,
  }) {
    return _then(
      _$FlashSalesStateImpl(
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        timeRemaining: null == timeRemaining
            ? _value.timeRemaining
            : timeRemaining // ignore: cast_nullable_to_non_nullable
                  as Duration,
        isExpired: null == isExpired
            ? _value.isExpired
            : isExpired // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FlashSalesStateImpl implements _FlashSalesState {
  const _$FlashSalesStateImpl({
    this.isEnabled = false,
    final List<Map<String, dynamic>> products = const [],
    this.isLoading = false,
    this.endTime,
    this.timeRemaining = Duration.zero,
    this.isExpired = false,
    this.error,
  }) : _products = products;

  @override
  @JsonKey()
  final bool isEnabled;
  final List<Map<String, dynamic>> _products;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final Duration timeRemaining;
  @override
  @JsonKey()
  final bool isExpired;
  @override
  final String? error;

  @override
  String toString() {
    return 'FlashSalesState(isEnabled: $isEnabled, products: $products, isLoading: $isLoading, endTime: $endTime, timeRemaining: $timeRemaining, isExpired: $isExpired, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashSalesStateImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.timeRemaining, timeRemaining) ||
                other.timeRemaining == timeRemaining) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isEnabled,
    const DeepCollectionEquality().hash(_products),
    isLoading,
    endTime,
    timeRemaining,
    isExpired,
    error,
  );

  /// Create a copy of FlashSalesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashSalesStateImplCopyWith<_$FlashSalesStateImpl> get copyWith =>
      _$$FlashSalesStateImplCopyWithImpl<_$FlashSalesStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FlashSalesState implements FlashSalesState {
  const factory _FlashSalesState({
    final bool isEnabled,
    final List<Map<String, dynamic>> products,
    final bool isLoading,
    final DateTime? endTime,
    final Duration timeRemaining,
    final bool isExpired,
    final String? error,
  }) = _$FlashSalesStateImpl;

  @override
  bool get isEnabled;
  @override
  List<Map<String, dynamic>> get products;
  @override
  bool get isLoading;
  @override
  DateTime? get endTime;
  @override
  Duration get timeRemaining;
  @override
  bool get isExpired;
  @override
  String? get error;

  /// Create a copy of FlashSalesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashSalesStateImplCopyWith<_$FlashSalesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
