import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../../data/repositories/offers_repository.dart';
import '../providers/offers_provider.dart';

/// Admin screen for managing "Rebajas" (featured offers).
///
/// Matches Astro's `/admin/rebajas` — OffersManager.tsx.
///
/// Features:
/// - Global toggle (offers_enabled)
/// - List of all products with checkbox to add/remove from rebajas
/// - Per-product discount % input
/// - Save all at once
class AdminOffersScreen extends ConsumerStatefulWidget {
  const AdminOffersScreen({super.key});

  @override
  ConsumerState<AdminOffersScreen> createState() => _AdminOffersScreenState();
}

class _AdminOffersScreenState extends ConsumerState<AdminOffersScreen> {
  /// Local map: productId → discount% (for editing before saving).
  Map<String, double> _selectedOffers = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentOffers();
  }

  Future<void> _loadCurrentOffers() async {
    final repo = ref.read(offersRepositoryProvider);
    final result = await repo.getFeaturedOffers();
    result.fold(
      (_) {},
      (offers) {
        final map = <String, double>{};
        for (final o in offers) {
          final id = o['id'] as String?;
          final disc = (o['discount'] as num?)?.toDouble();
          if (id != null && disc != null) {
            map[id] = disc;
          }
        }
        setState(() {
          _selectedOffers = map;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _saveOffers() async {
    setState(() => _isSaving = true);

    final offers = _selectedOffers.entries
        .map((e) => {'id': e.key, 'discount': e.value})
        .toList();

    final repo = ref.read(offersRepositoryProvider);
    final result = await repo.saveFeaturedOffers(offers);

    setState(() => _isSaving = false);

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${failure.message}')),
        );
      },
      (_) {
        // Refresh the offers provider so home screen updates
        ref.invalidate(offersProvider);
        ref.invalidate(featuredOffersMapProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rebajas guardadas correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _toggleProduct(String productId) {
    setState(() {
      if (_selectedOffers.containsKey(productId)) {
        _selectedOffers.remove(productId);
      } else {
        _selectedOffers[productId] = 20; // Default 20%
      }
    });
  }

  void _updateDiscount(String productId, double discount) {
    setState(() {
      _selectedOffers[productId] = discount.clamp(1, 90);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(adminProductsProvider);
    final isEnabledAsync = ref.watch(offersEnabledStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Rebajas'),
        actions: [
          // Global toggle
          isEnabledAsync.when(
            data: (isEnabled) => Row(
              children: [
                Text(isEnabled ? 'Activo' : 'Inactivo'),
                Switch(
                  value: isEnabled,
                  activeThumbColor: AppColors.error,
                  onChanged: (val) async {
                    final repo = ref.read(adminRepositoryProvider);
                    await repo.updateSetting('offers_enabled', val);
                  },
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _saveOffers,
        backgroundColor: AppColors.success,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save, color: Colors.white),
        label: Text(
          _isSaving ? 'Guardando...' : 'Guardar rebajas',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsAsync.when(
              data: (products) => _buildContent(context, products),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<Map<String, dynamic>> allProducts) {
    // Separate selected from unselected
    final selected = allProducts
        .where((p) => _selectedOffers.containsKey(p['id']))
        .toList();
    final unselected = allProducts
        .where((p) => !_selectedOffers.containsKey(p['id']))
        .toList();

    return CustomScrollView(
      slivers: [
        // ── Stats ────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: '${allProducts.length}',
                  color: AppColors.info,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'En rebaja',
                  value: '${selected.length}',
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Sin rebaja',
                  value: '${unselected.length}',
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),

        // ── Selected Products Header ─────────────
        if (selected.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Productos en Rebajas (${selected.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _SelectedProductTile(
                    product: selected[index],
                    discount: _selectedOffers[selected[index]['id']] ?? 20,
                    onRemove: () =>
                        _toggleProduct(selected[index]['id'] as String),
                    onDiscountChanged: (val) =>
                        _updateDiscount(selected[index]['id'] as String, val),
                  ),
              childCount: selected.length,
            ),
          ),
        ],

        // ── Divider ──────────────────────────────
        if (selected.isNotEmpty && unselected.isNotEmpty)
          const SliverToBoxAdapter(
            child: Divider(height: 32, thickness: 1),
          ),

        // ── All Products Header ──────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Todos los Productos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),

        // ── Product Grid ─────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = unselected[index];
                final productId = product['id'] as String;
                final isSelected = _selectedOffers.containsKey(productId);

                return _ProductGridTile(
                  product: product,
                  isSelected: isSelected,
                  onTap: () => _toggleProduct(productId),
                );
              },
              childCount: unselected.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final double discount;
  final VoidCallback onRemove;
  final ValueChanged<double> onDiscountChanged;

  const _SelectedProductTile({
    required this.product,
    required this.discount,
    required this.onRemove,
    required this.onDiscountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final price = product['price'] as int? ?? 0;
    final discountedPrice =
        OffersRepository.calculateDiscountedPrice(price, discount);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 50,
                height: 50,
                child: _productImage(product),
              ),
            ),
            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String? ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        AppUtils.formatPrice(discountedPrice),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppUtils.formatPrice(price),
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Discount input
            SizedBox(
              width: 70,
              child: TextFormField(
                initialValue: discount.toInt().toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  suffixText: '%',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  final d = double.tryParse(val);
                  if (d != null) onDiscountChanged(d);
                },
              ),
            ),

            // Remove button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close, color: AppColors.error, size: 20),
              tooltip: 'Quitar de rebajas',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGridTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProductGridTile({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? const BorderSide(color: AppColors.error, width: 2)
              : BorderSide.none,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _productImage(product),
                  if (isSelected)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String? ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AppUtils.formatPrice(product['price'] as int? ?? 0),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared helper to render a product thumbnail.
Widget _productImage(Map<String, dynamic> product) {
  final images = product['images'] as List<dynamic>? ?? [];
  final imageUrl = images.isNotEmpty ? images[0] as String : '';

  if (imageUrl.isEmpty) {
    return Container(
      color: AppColors.backgroundSecondary,
      child: const Icon(Icons.image_outlined, size: 24),
    );
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => Container(
      color: AppColors.backgroundSecondary,
      child: const Icon(Icons.broken_image_outlined, size: 24),
    ),
  );
}
