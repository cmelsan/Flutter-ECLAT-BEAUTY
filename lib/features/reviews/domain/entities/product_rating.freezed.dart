// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_rating.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductRating _$ProductRatingFromJson(Map<String, dynamic> json) {
  return _ProductRating.fromJson(json);
}

/// @nodoc
mixin _$ProductRating {
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating')
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_distribution')
  Map<String, int> get ratingDistribution => throw _privateConstructorUsedError;

  /// Serializes this ProductRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductRatingCopyWith<ProductRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductRatingCopyWith<$Res> {
  factory $ProductRatingCopyWith(
    ProductRating value,
    $Res Function(ProductRating) then,
  ) = _$ProductRatingCopyWithImpl<$Res, ProductRating>;
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'total_reviews') int totalReviews,
    @JsonKey(name: 'rating_distribution') Map<String, int> ratingDistribution,
  });
}

/// @nodoc
class _$ProductRatingCopyWithImpl<$Res, $Val extends ProductRating>
    implements $ProductRatingCopyWith<$Res> {
  _$ProductRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            ratingDistribution: null == ratingDistribution
                ? _value.ratingDistribution
                : ratingDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductRatingImplCopyWith<$Res>
    implements $ProductRatingCopyWith<$Res> {
  factory _$$ProductRatingImplCopyWith(
    _$ProductRatingImpl value,
    $Res Function(_$ProductRatingImpl) then,
  ) = _$$ProductRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'total_reviews') int totalReviews,
    @JsonKey(name: 'rating_distribution') Map<String, int> ratingDistribution,
  });
}

/// @nodoc
class _$$ProductRatingImplCopyWithImpl<$Res>
    extends _$ProductRatingCopyWithImpl<$Res, _$ProductRatingImpl>
    implements _$$ProductRatingImplCopyWith<$Res> {
  _$$ProductRatingImplCopyWithImpl(
    _$ProductRatingImpl _value,
    $Res Function(_$ProductRatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
  }) {
    return _then(
      _$ProductRatingImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        ratingDistribution: null == ratingDistribution
            ? _value._ratingDistribution
            : ratingDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductRatingImpl implements _ProductRating {
  const _$ProductRatingImpl({
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'avg_rating') required this.avgRating,
    @JsonKey(name: 'total_reviews') required this.totalReviews,
    @JsonKey(name: 'rating_distribution')
    required final Map<String, int> ratingDistribution,
  }) : _ratingDistribution = ratingDistribution;

  factory _$ProductRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductRatingImplFromJson(json);

  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'avg_rating')
  final double avgRating;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  final Map<String, int> _ratingDistribution;
  @override
  @JsonKey(name: 'rating_distribution')
  Map<String, int> get ratingDistribution {
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratingDistribution);
  }

  @override
  String toString() {
    return 'ProductRating(productId: $productId, avgRating: $avgRating, totalReviews: $totalReviews, ratingDistribution: $ratingDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductRatingImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality().equals(
              other._ratingDistribution,
              _ratingDistribution,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    avgRating,
    totalReviews,
    const DeepCollectionEquality().hash(_ratingDistribution),
  );

  /// Create a copy of ProductRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductRatingImplCopyWith<_$ProductRatingImpl> get copyWith =>
      _$$ProductRatingImplCopyWithImpl<_$ProductRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductRatingImplToJson(this);
  }
}

abstract class _ProductRating implements ProductRating {
  const factory _ProductRating({
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'avg_rating') required final double avgRating,
    @JsonKey(name: 'total_reviews') required final int totalReviews,
    @JsonKey(name: 'rating_distribution')
    required final Map<String, int> ratingDistribution,
  }) = _$ProductRatingImpl;

  factory _ProductRating.fromJson(Map<String, dynamic> json) =
      _$ProductRatingImpl.fromJson;

  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'avg_rating')
  double get avgRating;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'rating_distribution')
  Map<String, int> get ratingDistribution;

  /// Create a copy of ProductRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductRatingImplCopyWith<_$ProductRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
