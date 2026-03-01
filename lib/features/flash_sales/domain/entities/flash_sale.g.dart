// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlashSaleImpl _$$FlashSaleImplFromJson(Map<String, dynamic> json) =>
    _$FlashSaleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      discountPercentage: (json['discount_percentage'] as num).toInt(),
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FlashSaleImplToJson(_$FlashSaleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'discount_percentage': instance.discountPercentage,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };
