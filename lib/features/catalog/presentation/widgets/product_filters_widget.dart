import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../providers/products_state_provider.dart';

class ProductFiltersWidget extends ConsumerStatefulWidget {
  const ProductFiltersWidget({super.key});

  @override
  ConsumerState<ProductFiltersWidget> createState() => _ProductFiltersWidgetState();
}

class _ProductFiltersWidgetState extends ConsumerState<ProductFiltersWidget> {
  static const double _maxSliderPrice = 500;

  Set<String> _selectedCategoryIds = <String>{};
  Set<String> _selectedBrandIds = <String>{};
  double _selectedMaxPrice = _maxSliderPrice;

  bool _isCategoryExpanded = true;
  bool _isBrandExpanded = true;
  bool _isPriceExpanded = true;

  @override
  void initState() {
    super.initState();
    final state = ref.read(productsStateProvider);
    _selectedCategoryIds = _parseCsvIds(state.selectedCategoryId).toSet();
    _selectedBrandIds = _parseCsvIds(state.selectedBrandId).toSet();

    final maxPriceFromState = state.maxPrice != null ? state.maxPrice! / 100 : _maxSliderPrice;
    _selectedMaxPrice = maxPriceFromState.clamp(0, _maxSliderPrice);
  }

  List<String> _parseCsvIds(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    return value
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  void _applyFilters() {
    final notifier = ref.read(productsStateProvider.notifier);
    notifier.setCategoryFilters(_selectedCategoryIds.toList());
    notifier.setBrandFilters(_selectedBrandIds.toList());

    if (_selectedMaxPrice < _maxSliderPrice) {
      notifier.setPriceRange(null, (_selectedMaxPrice * 100).toInt());
    } else {
      notifier.clearPriceFilter();
    }
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
      }
    });
    _applyFilters();
  }

  void _toggleBrand(String brandId) {
    setState(() {
      if (_selectedBrandIds.contains(brandId)) {
        _selectedBrandIds.remove(brandId);
      } else {
        _selectedBrandIds.add(brandId);
      }
    });
    _applyFilters();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryIds = <String>{};
      _selectedBrandIds = <String>{};
      _selectedMaxPrice = _maxSliderPrice;
    });
    final notifier = ref.read(productsStateProvider.notifier);
    notifier.clearCategoryFilter();
    notifier.clearBrandFilter();
    notifier.clearPriceFilter();
  }

  bool get _hasActiveFilters =>
      _selectedCategoryIds.isNotEmpty || _selectedBrandIds.isNotEmpty || _selectedMaxPrice < _maxSliderPrice;

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(brandsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(),

          // Filters content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: 'CATEGORÍA',
                    isExpanded: _isCategoryExpanded,
                    onTap: () => setState(() => _isCategoryExpanded = !_isCategoryExpanded),
                  ),
                  if (_isCategoryExpanded) ...[
                    const SizedBox(height: 8),
                    categoriesAsync.when(
                      data: (categories) => SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = _selectedCategoryIds.contains(category.id);
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isSelected,
                              onChanged: (_) => _toggleCategory(category.id),
                              title: Text(
                                category.name,
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            );
                          },
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => const Text('Error al cargar categorías'),
                    ),
                  ],

                  const Divider(height: 28),

                  _buildSectionHeader(
                    title: 'MARCA',
                    isExpanded: _isBrandExpanded,
                    onTap: () => setState(() => _isBrandExpanded = !_isBrandExpanded),
                  ),
                  if (_isBrandExpanded) ...[
                    const SizedBox(height: 8),
                    brandsAsync.when(
                      data: (brands) => SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: brands.length,
                          itemBuilder: (context, index) {
                            final brand = brands[index];
                            final isSelected = _selectedBrandIds.contains(brand.id);
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isSelected,
                              onChanged: (_) => _toggleBrand(brand.id),
                              title: Text(
                                brand.name,
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            );
                          },
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => const Text('Error al cargar marcas'),
                    ),
                  ],

                  const Divider(height: 28),

                  _buildSectionHeader(
                    title: 'PRECIO',
                    isExpanded: _isPriceExpanded,
                    onTap: () => setState(() => _isPriceExpanded = !_isPriceExpanded),
                  ),
                  if (_isPriceExpanded) ...[
                    const SizedBox(height: 8),
                    Text(
                      'MÁXIMO: ${_selectedMaxPrice.toInt()}€',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _selectedMaxPrice,
                      min: 0,
                      max: _maxSliderPrice,
                      divisions: 100,
                      label: '${_selectedMaxPrice.toInt()}€',
                      onChanged: (value) {
                        setState(() => _selectedMaxPrice = value);
                      },
                      onChangeEnd: (_) => _applyFilters(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '0€',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                        Text(
                          '500€+',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ],

                  if (_hasActiveFilters) ...[
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Limpiar Filtros'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Footer actions
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
