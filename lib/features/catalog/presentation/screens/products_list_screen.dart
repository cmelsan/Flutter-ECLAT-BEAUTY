import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../providers/products_state.dart';
import '../providers/products_state_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_filters_widget.dart';

class ProductsListScreen extends ConsumerStatefulWidget {
  final String? brandSlug;
  final String? categorySlug;
  final String? title;

  const ProductsListScreen({
    super.key,
    this.brandSlug,
    this.categorySlug,
    this.title,
  });

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  int _countCsvValues(String? value) {
    if (value == null || value.trim().isEmpty) return 0;
    return value
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .length;
  }

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(_onScroll);
    
    // Apply initial filters and load products
    Future.microtask(() async {
      // Apply brand filter if provided
      if (widget.brandSlug != null) {
        final brands = await ref.read(brandsProvider.future);
        final brand = brands.firstWhere(
          (b) => b.slug == widget.brandSlug,
          orElse: () => brands.first,
        );
        ref.read(productsStateProvider.notifier).setBrandFilter(brand.id);
      }

      // Apply category filter if provided
      if (widget.categorySlug != null) {
        final categories = await ref.read(categoriesProvider.future);
        final category = categories.firstWhere(
          (c) => c.slug == widget.categorySlug,
          orElse: () => categories.first,
        );
        ref.read(productsStateProvider.notifier).setCategoryFilter(category.id);
      }

      // Load products will be called automatically by the filters above
      // If no filters, load all products
      if (widget.brandSlug == null && widget.categorySlug == null) {
        ref.read(productsStateProvider.notifier).loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsStateProvider.notifier).loadMoreProducts();
    }
  }

  Future<void> _refresh() async {
    await ref.read(productsStateProvider.notifier).loadProducts();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProductFiltersWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: widget.title != null 
            ? Text(widget.title!) 
            : TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(productsStateProvider.notifier).setSearchQuery('');
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(productsStateProvider.notifier).setSearchQuery(value);
                },
              ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilters,
              ),
              if (state.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(ProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return _buildLoadingGrid();
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(productsStateProvider.notifier).loadProducts(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            const Text(
              'No hay productos disponibles',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            if (state.hasActiveFilters) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(productsStateProvider.notifier).clearFilters(),
                child: const Text('Limpiar filtros'),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        // Active filters chips
        if (state.hasActiveFilters)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (state.selectedCategoryId != null)
                  _FilterChip(
                    label: _countCsvValues(state.selectedCategoryId) > 1
                        ? 'Categorías (${_countCsvValues(state.selectedCategoryId)})'
                        : 'Categoría',
                    onDeleted: () => ref.read(productsStateProvider.notifier).clearCategoryFilter(),
                  ),
                if (state.selectedBrandId != null)
                  _FilterChip(
                    label: _countCsvValues(state.selectedBrandId) > 1
                        ? 'Marcas (${_countCsvValues(state.selectedBrandId)})'
                        : 'Marca',
                    onDeleted: () => ref.read(productsStateProvider.notifier).clearBrandFilter(),
                  ),
                if (state.minPrice != null || state.maxPrice != null)
                  _FilterChip(
                    label: 'Precio',
                    onDeleted: () => ref.read(productsStateProvider.notifier).clearPriceFilter(),
                  ),
                ActionChip(
                  label: const Text('Limpiar todo'),
                  onPressed: () => ref.read(productsStateProvider.notifier).clearFilters(),
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: AppColors.error),
                ),
              ],
            ),
          ),

        // Products grid
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              childAspectRatio: 0.52,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= state.products.length) {
                return _buildLoadingCard();
              }

              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  context.push('/producto/${product.slug}');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => _buildLoadingCard(),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(color: AppColors.shimmerBase),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _FilterChip({
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIconColor: AppColors.primary,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: const TextStyle(color: AppColors.primary),
    );
  }
}
