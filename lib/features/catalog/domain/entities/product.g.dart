// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      categoryId: json['category_id'] as String?,
      brandId: json['brand_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFlashSale: json['is_flash_sale'] as bool? ?? false,
      flashSaleDiscount: (json['flash_sale_discount'] as num?)?.toDouble(),
      flashSaleEndTime: json['flash_sale_end_time'] == null
          ? null
          : DateTime.parse(json['flash_sale_end_time'] as String),
      discount: (json['discount'] as num?)?.toInt(),
      discountedPrice: (json['discounted_price'] as num?)?.toInt(),
      offerLabel: json['offer_label'] as String?,
      category: json['category'] as Map<String, dynamic>?,
      brand: json['brand'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'category_id': instance.categoryId,
      'brand_id': instance.brandId,
      'subcategory_id': instance.subcategoryId,
      'images': instance.images,
      'is_flash_sale': instance.isFlashSale,
      'flash_sale_discount': instance.flashSaleDiscount,
      'flash_sale_end_time': instance.flashSaleEndTime?.toIso8601String(),
      'discount': instance.discount,
      'discounted_price': instance.discountedPrice,
      'offer_label': instance.offerLabel,
      'category': instance.category,
      'brand': instance.brand,
      'created_at': instance.createdAt?.toIso8601String(),
    };
