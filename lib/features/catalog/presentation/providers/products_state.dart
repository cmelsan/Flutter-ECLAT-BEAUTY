import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const ProductsState._(); // Required for extensions
  
  const factory ProductsState({
    @Default([]) List<Product> products,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int page,
    @Default(true) bool hasMore,
    String? error,
    @Default('') String searchQuery,
    String? selectedCategoryId,
    String? selectedBrandId,
    int? minPrice, // in cents
    int? maxPrice, // in cents
  }) = _ProductsState;
}

extension ProductsStateX on ProductsState {
  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedBrandId != null ||
      minPrice != null ||
      maxPrice != null ||
      searchQuery.isNotEmpty;
}
