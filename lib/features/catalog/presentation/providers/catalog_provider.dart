import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/brand.dart';
import '../../../offers/data/repositories/offers_repository.dart';
import '../../../offers/presentation/providers/offers_provider.dart';

/// Repository provider
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.watch(supabaseClientProvider));
});

/// Categories
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getCategories();
  return result.fold((f) => throw Exception(f.message), (cats) => cats);
});

/// Brands
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getBrands();
  return result.fold((f) => throw Exception(f.message), (brands) => brands);
});

/// Featured products (home screen)
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getFeaturedProducts(limit: 8);
  return result.fold((f) => throw Exception(f.message), (products) => products);
});

/// Enriched featured products — applies offer/flash pricing to each product.
final enrichedFeaturedProductsProvider =
    FutureProvider<List<Product>>((ref) async {
  final products = await ref.watch(featuredProductsProvider.future);
  final offersMapAsync = ref.watch(featuredOffersMapProvider);
  final offersMap = offersMapAsync.valueOrNull ?? {};
  return _enrichProducts(products, offersMap);
});

/// Products by category slug
final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, slug) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getProducts(categorySlug: slug);
  return result.fold((f) => throw Exception(f.message), (products) => products);
});

/// Products by brand slug
final productsByBrandProvider =
    FutureProvider.family<List<Product>, String>((ref, slug) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getProducts(brandSlug: slug);
  return result.fold((f) => throw Exception(f.message), (products) => products);
});

/// Product detail by slug (autoDispose to always refetch on remount)
final productBySlugProvider =
    FutureProvider.autoDispose.family<Product, String>((ref, slug) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.getProductBySlug(slug);
  return result.fold((f) => throw Exception(f.message), (product) => product);
});

/// Enriched product — applies offer pricing with priority:
/// flash sale > rebajas > base price.
///
/// If the product already has an active flash sale, it keeps the flash
/// sale pricing. Otherwise, if the product appears in `featured_offers`,
/// we apply the rebaja discount via [Product.copyWith].
final enrichedProductBySlugProvider =
    FutureProvider.autoDispose.family<Product, String>((ref, slug) async {
  final product = await ref.watch(productBySlugProvider(slug).future);

  // If already has active flash sale, skip rebajas (flash > rebajas > base)
  if (product.isFlashSale && product.flashSaleDiscount != null) {
    final endTime = product.flashSaleEndTime;
    final isActive = endTime == null || endTime.isAfter(DateTime.now().toUtc());
    if (isActive) {
      // Apply flash sale pricing to discountedPrice so effectivePrice works
      final flashPrice = OffersRepository.calculateDiscountedPrice(
        product.price,
        product.flashSaleDiscount!,
      );
      return product.copyWith(
        discountedPrice: flashPrice,
        discount: product.flashSaleDiscount!.toInt(),
        offerLabel: 'Flash Sale',
      );
    }
  }

  // Check if product is in featured_offers (rebajas)
  final offersMapAsync = ref.watch(featuredOffersMapProvider);
  final offersMap = offersMapAsync.valueOrNull ?? {};

  final offerDiscount = offersMap[product.id];
  if (offerDiscount != null && offerDiscount > 0) {
    final rebajaPrice = OffersRepository.calculateDiscountedPrice(
      product.price,
      offerDiscount,
    );
    return product.copyWith(
      discountedPrice: rebajaPrice,
      discount: offerDiscount.toInt(),
      offerLabel: 'Rebaja',
    );
  }

  return product;
});

/// Search results
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repo = ref.watch(catalogRepositoryProvider);
  final result = await repo.searchProducts(query);
  return result.fold((f) => [], (products) => products);
});

/// Related products by category (excluding current product)
final relatedProductsProvider =
    FutureProvider.autoDispose.family<List<Product>, ({String categoryId, String excludeProductId})>(
  (ref, params) async {
    final repo = ref.watch(catalogRepositoryProvider);
    final result = await repo.getProducts(
      categoryId: params.categoryId,
      limit: 4,
    );
    
    return result.fold(
      (f) => [],
      (products) => products
          .where((p) => p.id != params.excludeProductId)
          .take(4)
          .toList(),
    );
  },
);

// ─── Helper ─────────────────────────────────────────────

/// Apply offer/flash sale pricing to a list of products.
/// Priority: flash sale > rebajas > base price.
List<Product> _enrichProducts(
  List<Product> products,
  Map<String, num> offersMap,
) {
  return products.map((product) {
    // Flash sale takes priority
    if (product.isFlashSale && product.flashSaleDiscount != null) {
      final endTime = product.flashSaleEndTime;
      final isActive =
          endTime == null || endTime.isAfter(DateTime.now().toUtc());
      if (isActive) {
        final flashPrice = OffersRepository.calculateDiscountedPrice(
          product.price,
          product.flashSaleDiscount!,
        );
        return product.copyWith(
          discountedPrice: flashPrice,
          discount: product.flashSaleDiscount!.toInt(),
          offerLabel: 'Flash Sale',
        );
      }
    }

    // Then rebajas
    final offerDiscount = offersMap[product.id];
    if (offerDiscount != null && offerDiscount > 0) {
      final rebajaPrice = OffersRepository.calculateDiscountedPrice(
        product.price,
        offerDiscount,
      );
      return product.copyWith(
        discountedPrice: rebajaPrice,
        discount: offerDiscount.toInt(),
        offerLabel: 'Rebaja',
      );
    }

    return product;
  }).toList();
}
