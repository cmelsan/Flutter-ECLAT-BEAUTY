// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductsState {
  List<Product> get products => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  String? get selectedBrandId => throw _privateConstructorUsedError;
  int? get minPrice => throw _privateConstructorUsedError; // in cents
  int? get maxPrice => throw _privateConstructorUsedError;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductsStateCopyWith<ProductsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsStateCopyWith<$Res> {
  factory $ProductsStateCopyWith(
    ProductsState value,
    $Res Function(ProductsState) then,
  ) = _$ProductsStateCopyWithImpl<$Res, ProductsState>;
  @useResult
  $Res call({
    List<Product> products,
    bool isLoading,
    bool isLoadingMore,
    int page,
    bool hasMore,
    String? error,
    String searchQuery,
    String? selectedCategoryId,
    String? selectedBrandId,
    int? minPrice,
    int? maxPrice,
  });
}

/// @nodoc
class _$ProductsStateCopyWithImpl<$Res, $Val extends ProductsState>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? page = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<Product>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedCategoryId: freezed == selectedCategoryId
                ? _value.selectedCategoryId
                : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedBrandId: freezed == selectedBrandId
                ? _value.selectedBrandId
                : selectedBrandId // ignore: cast_nullable_to_non_nullable
                      as String?,
            minPrice: freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxPrice: freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductsStateImplCopyWith<$Res>
    implements $ProductsStateCopyWith<$Res> {
  factory _$$ProductsStateImplCopyWith(
    _$ProductsStateImpl value,
    $Res Function(_$ProductsStateImpl) then,
  ) = _$$ProductsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Product> products,
    bool isLoading,
    bool isLoadingMore,
    int page,
    bool hasMore,
    String? error,
    String searchQuery,
    String? selectedCategoryId,
    String? selectedBrandId,
    int? minPrice,
    int? maxPrice,
  });
}

/// @nodoc
class _$$ProductsStateImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsStateImpl>
    implements _$$ProductsStateImplCopyWith<$Res> {
  _$$ProductsStateImplCopyWithImpl(
    _$ProductsStateImpl _value,
    $Res Function(_$ProductsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? page = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _$ProductsStateImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCategoryId: freezed == selectedCategoryId
            ? _value.selectedCategoryId
            : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedBrandId: freezed == selectedBrandId
            ? _value.selectedBrandId
            : selectedBrandId // ignore: cast_nullable_to_non_nullable
                  as String?,
        minPrice: freezed == minPrice
            ? _value.minPrice
            : minPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxPrice: freezed == maxPrice
            ? _value.maxPrice
            : maxPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ProductsStateImpl extends _ProductsState {
  const _$ProductsStateImpl({
    final List<Product> products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.page = 0,
    this.hasMore = true,
    this.error,
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedBrandId,
    this.minPrice,
    this.maxPrice,
  }) : _products = products,
       super._();

  final List<Product> _products;
  @override
  @JsonKey()
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? error;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  final String? selectedCategoryId;
  @override
  final String? selectedBrandId;
  @override
  final int? minPrice;
  // in cents
  @override
  final int? maxPrice;

  @override
  String toString() {
    return 'ProductsState(products: $products, isLoading: $isLoading, isLoadingMore: $isLoadingMore, page: $page, hasMore: $hasMore, error: $error, searchQuery: $searchQuery, selectedCategoryId: $selectedCategoryId, selectedBrandId: $selectedBrandId, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.selectedBrandId, selectedBrandId) ||
                other.selectedBrandId == selectedBrandId) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    isLoading,
    isLoadingMore,
    page,
    hasMore,
    error,
    searchQuery,
    selectedCategoryId,
    selectedBrandId,
    minPrice,
    maxPrice,
  );

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsStateImplCopyWith<_$ProductsStateImpl> get copyWith =>
      _$$ProductsStateImplCopyWithImpl<_$ProductsStateImpl>(this, _$identity);
}

abstract class _ProductsState extends ProductsState {
  const factory _ProductsState({
    final List<Product> products,
    final bool isLoading,
    final bool isLoadingMore,
    final int page,
    final bool hasMore,
    final String? error,
    final String searchQuery,
    final String? selectedCategoryId,
    final String? selectedBrandId,
    final int? minPrice,
    final int? maxPrice,
  }) = _$ProductsStateImpl;
  const _ProductsState._() : super._();

  @override
  List<Product> get products;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  int get page;
  @override
  bool get hasMore;
  @override
  String? get error;
  @override
  String get searchQuery;
  @override
  String? get selectedCategoryId;
  @override
  String? get selectedBrandId;
  @override
  int? get minPrice; // in cents
  @override
  int? get maxPrice;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsStateImplCopyWith<_$ProductsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
