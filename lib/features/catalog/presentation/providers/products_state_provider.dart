import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/catalog_repository.dart';
import 'catalog_provider.dart';
import 'products_state.dart';

final productsStateProvider =
    StateNotifierProvider<ProductsStateNotifier, ProductsState>((ref) {
  return ProductsStateNotifier(
    ref.watch(catalogRepositoryProvider),
  );
});

class ProductsStateNotifier extends StateNotifier<ProductsState> {
  final CatalogRepository _repository;
  Timer? _debounceTimer;

  ProductsStateNotifier(this._repository) : super(const ProductsState());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null, page: 0, hasMore: true);

    try {
      final result = await _repository.getProducts(
        categoryId: state.selectedCategoryId,
        brandId: state.selectedBrandId,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: 0,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            error: failure.message,
            isLoading: false,
          );
        },
        (products) {
          state = state.copyWith(
            products: products,
            isLoading: false,
            hasMore: products.length == 12, // Assuming limit is 12
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.page + 1;
      final result = await _repository.getProducts(
        categoryId: state.selectedCategoryId,
        brandId: state.selectedBrandId,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: nextPage,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            error: failure.message,
            isLoadingMore: false,
          );
        },
        (newProducts) {
          state = state.copyWith(
            products: [...state.products, ...newProducts],
            isLoadingMore: false,
            page: nextPage,
            hasMore: newProducts.length == 12, // Assuming limit is 12
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoadingMore: false,
      );
    }
  }

  void setSearchQuery(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Update query immediately for UI
    state = state.copyWith(searchQuery: query);

    // Debounce the actual search (300ms)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      loadProducts();
    });
  }

  void setCategoryFilter(String? categoryId) {
    final value = categoryId == null || categoryId.isEmpty ? null : categoryId;
    state = state.copyWith(selectedCategoryId: value);
    loadProducts();
  }

  void setCategoryFilters(List<String> categoryIds) {
    final normalized = categoryIds.where((id) => id.trim().isNotEmpty).toSet().toList();
    final value = normalized.isEmpty ? null : normalized.join(',');
    state = state.copyWith(selectedCategoryId: value);
    loadProducts();
  }

  void setBrandFilter(String? brandId) {
    final value = brandId == null || brandId.isEmpty ? null : brandId;
    state = state.copyWith(selectedBrandId: value);
    loadProducts();
  }

  void setBrandFilters(List<String> brandIds) {
    final normalized = brandIds.where((id) => id.trim().isNotEmpty).toSet().toList();
    final value = normalized.isEmpty ? null : normalized.join(',');
    state = state.copyWith(selectedBrandId: value);
    loadProducts();
  }

  void setPriceRange(int? minPrice, int? maxPrice) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
    loadProducts();
  }

  void clearCategoryFilter() {
    state = state.copyWith(selectedCategoryId: null);
    loadProducts();
  }

  void clearBrandFilter() {
    state = state.copyWith(selectedBrandId: null);
    loadProducts();
  }

  void clearPriceFilter() {
    state = state.copyWith(minPrice: null, maxPrice: null);
    loadProducts();
  }

  void clearFilters() {
    state = state.copyWith(
      selectedCategoryId: null,
      selectedBrandId: null,
      minPrice: null,
      maxPrice: null,
      searchQuery: '',
    );
    loadProducts();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
