import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../reviews/presentation/widgets/reviews_list.dart';
import '../../../reviews/presentation/widgets/review_form.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productSlug;

  const ProductDetailScreen({super.key, required this.productSlug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(enrichedProductBySlugProvider(widget.productSlug));

    return Scaffold(
      body: productAsync.when(
        data: (product) => _buildContent(context, product),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(
                  enrichedProductBySlugProvider(widget.productSlug),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final isInWishlist = ref.watch(isInWishlistProvider(product.id));

    return CustomScrollView(
      slivers: [
        // ── Image Gallery ─────────────────────────
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.width,
          pinned: true,
          actions: [
            IconButton(
              icon: Icon(
                isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: isInWishlist ? AppColors.error : null,
              ),
              onPressed: () {
                ref.read(wishlistProvider.notifier).toggle(product.id);
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: product.images.isNotEmpty
                ? PageView.builder(
                    itemCount: product.images.length,
                    onPageChanged: (i) =>
                        setState(() => _selectedImageIndex = i),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: AppUtils.galleryUrl(product.images[index]),
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: AppColors.shimmerBase,
                        ),
                        errorWidget: (_, _, _) =>
                            const Icon(Icons.broken_image_outlined, size: 48),
                      );
                    },
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, size: 80),
                  ),
          ),
        ),

        // ── Page indicator ────────────────────────
        if (product.images.length > 1)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _selectedImageIndex
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // ── Product Info ──────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                if (product.brand != null)
                  Text(
                    (product.brand!['name'] as String?) ?? '',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                const SizedBox(height: 8),

                // Name
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppUtils.formatPrice(product.effectivePrice),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    if (product.hasDiscount) ...[
                      const SizedBox(width: 12),
                      Text(
                        AppUtils.formatPrice(product.price),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Stock status
                _StockBadge(stock: product.stock),
                const SizedBox(height: 20),

                // Description
                if (product.description?.isNotEmpty == true) ...[
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Quantity selector
                if (product.isInStock) ...[
                  Row(
                    children: [
                      Text(
                        'Cantidad',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 16),
                      _QuantitySelector(
                        value: _quantity,
                        max: product.stock,
                        onChanged: (v) => setState(() => _quantity = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add to cart
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addToCart(
                          product: product,
                          quantity: _quantity,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} añadido al carrito'),
                            action: SnackBarAction(
                              label: 'Ver carrito',
                              onPressed: () {
                                  context.go('/carrito');
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('AÑADIR AL CARRITO'),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // Reviews section
                Text(
                  'Opiniones de clientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                // Review form (only shown if user can review or already has a review)
                ReviewForm(productId: product.id),
                const SizedBox(height: 16),
                
                // Reviews list with rating summary
                ReviewsList(productId: product.id),

                const SizedBox(height: 32),

                // Related products section
                if (product.categoryId != null) ...[
                  Text(
                    'También te puede gustar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _RelatedProductsSection(
                    categoryId: product.categoryId!,
                    excludeProductId: product.id,
                  ),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RelatedProductsSection extends ConsumerWidget {
  final String categoryId;
  final String excludeProductId;

  const _RelatedProductsSection({
    required this.categoryId,
    required this.excludeProductId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedProductsAsync = ref.watch(
      relatedProductsProvider((
        categoryId: categoryId,
        excludeProductId: excludeProductId,
      )),
    );

    return relatedProductsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  right: index < products.length - 1 ? 12 : 0,
                ),
                child: ProductCard(
                  product: product,
                  onTap: () {
                    context.push('/producto/${product.slug}');
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stock;
  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final status = AppUtils.getStockStatus(stock);
    final color = switch (status) {
      StockStatus.inStock => AppColors.inStock,
      StockStatus.low => AppColors.lowStock,
      StockStatus.outOfStock => AppColors.outOfStock,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        AppUtils.getStockLabel(stock),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: value < max ? () => onChanged(value + 1) : null,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
