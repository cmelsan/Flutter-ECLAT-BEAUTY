// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flash_sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlashSale _$FlashSaleFromJson(Map<String, dynamic> json) {
  return _FlashSale.fromJson(json);
}

/// @nodoc
mixin _$FlashSale {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_percentage')
  int get discountPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'starts_at')
  DateTime get startsAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ends_at')
  DateTime get endsAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FlashSale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlashSale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashSaleCopyWith<FlashSale> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashSaleCopyWith<$Res> {
  factory $FlashSaleCopyWith(FlashSale value, $Res Function(FlashSale) then) =
      _$FlashSaleCopyWithImpl<$Res, FlashSale>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(name: 'discount_percentage') int discountPercentage,
    @JsonKey(name: 'starts_at') DateTime startsAt,
    @JsonKey(name: 'ends_at') DateTime endsAt,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$FlashSaleCopyWithImpl<$Res, $Val extends FlashSale>
    implements $FlashSaleCopyWith<$Res> {
  _$FlashSaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashSale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? discountPercentage = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? isActive = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountPercentage: null == discountPercentage
                ? _value.discountPercentage
                : discountPercentage // ignore: cast_nullable_to_non_nullable
                      as int,
            startsAt: null == startsAt
                ? _value.startsAt
                : startsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endsAt: null == endsAt
                ? _value.endsAt
                : endsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$FlashSaleImplCopyWith<$Res>
    implements $FlashSaleCopyWith<$Res> {
  factory _$$FlashSaleImplCopyWith(
    _$FlashSaleImpl value,
    $Res Function(_$FlashSaleImpl) then,
  ) = _$$FlashSaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(name: 'discount_percentage') int discountPercentage,
    @JsonKey(name: 'starts_at') DateTime startsAt,
    @JsonKey(name: 'ends_at') DateTime endsAt,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$$FlashSaleImplCopyWithImpl<$Res>
    extends _$FlashSaleCopyWithImpl<$Res, _$FlashSaleImpl>
    implements _$$FlashSaleImplCopyWith<$Res> {
  _$$FlashSaleImplCopyWithImpl(
    _$FlashSaleImpl _value,
    $Res Function(_$FlashSaleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlashSale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? discountPercentage = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$FlashSaleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountPercentage: null == discountPercentage
            ? _value.discountPercentage
            : discountPercentage // ignore: cast_nullable_to_non_nullable
                  as int,
        startsAt: null == startsAt
            ? _value.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endsAt: null == endsAt
            ? _value.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$FlashSaleImpl extends _FlashSale {
  const _$FlashSaleImpl({
    required this.id,
    required this.name,
    this.description,
    @JsonKey(name: 'discount_percentage') required this.discountPercentage,
    @JsonKey(name: 'starts_at') required this.startsAt,
    @JsonKey(name: 'ends_at') required this.endsAt,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : super._();

  factory _$FlashSaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashSaleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'discount_percentage')
  final int discountPercentage;
  @override
  @JsonKey(name: 'starts_at')
  final DateTime startsAt;
  @override
  @JsonKey(name: 'ends_at')
  final DateTime endsAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FlashSale(id: $id, name: $name, description: $description, discountPercentage: $discountPercentage, startsAt: $startsAt, endsAt: $endsAt, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashSaleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    discountPercentage,
    startsAt,
    endsAt,
    isActive,
    createdAt,
  );

  /// Create a copy of FlashSale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashSaleImplCopyWith<_$FlashSaleImpl> get copyWith =>
      _$$FlashSaleImplCopyWithImpl<_$FlashSaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashSaleImplToJson(this);
  }
}

abstract class _FlashSale extends FlashSale {
  const factory _FlashSale({
    required final String id,
    required final String name,
    final String? description,
    @JsonKey(name: 'discount_percentage') required final int discountPercentage,
    @JsonKey(name: 'starts_at') required final DateTime startsAt,
    @JsonKey(name: 'ends_at') required final DateTime endsAt,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$FlashSaleImpl;
  const _FlashSale._() : super._();

  factory _FlashSale.fromJson(Map<String, dynamic> json) =
      _$FlashSaleImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'discount_percentage')
  int get discountPercentage;
  @override
  @JsonKey(name: 'starts_at')
  DateTime get startsAt;
  @override
  @JsonKey(name: 'ends_at')
  DateTime get endsAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of FlashSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashSaleImplCopyWith<_$FlashSaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
