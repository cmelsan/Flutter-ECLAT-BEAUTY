import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../flash_sales/presentation/widgets/flash_sales_section.dart';
import '../../../offers/presentation/widgets/offers_section.dart';
import '../../../offers/presentation/providers/offers_provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(enrichedFeaturedProductsProvider);
    final categories = ref.watch(categoriesProvider);

    // Show loading state if both are still loading
    if (featured.isLoading && categories.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando productos...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(categoriesProvider);
          ref.invalidate(offersProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── Hero Banner ──────────────────────────
            SliverToBoxAdapter(
              child: Container(
                height: 350,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: 'https://res.cloudinary.com/dmu6ttz2o/image/upload/v1770483149/eclat-beauty/hero-makeup-girl.jpg',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.85),
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Decorative line
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEC4899),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Title
                            const Text(
                              'ÉCLAT\nBEAUTY',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Subtitle
                            Text(
                              'Descubre tu belleza premium',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Spacer(),
                            // Search Bar
                            GestureDetector(
                              onTap: () {
                                context.push('/busqueda');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Buscar productos...',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Categories horizontal scroll ─────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categorías',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: categories.when(
                    data: (cats) {
                      debugPrint('DEBUG: Categories loaded: ${cats.length}');
                      if (cats.isEmpty) {
                        return const Center(
                          child: Text('No hay categorías disponibles'),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cats.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = cats[index];
                          return ActionChip(
                            label: Text(
                              cat.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            onPressed: () {
                              context.push('/categoria/${cat.slug}?name=${Uri.encodeComponent(cat.name)}');
                            },
                          );
                        },
                      );
                    },
                    loading: () {
                      debugPrint('DEBUG: Categories loading...');
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    error: (e, _) {
                      debugPrint('DEBUG: Categories error: $e');
                      return Center(
                        child: Text('Error cargando categorías: $e', 
                          style: const TextStyle(fontSize: 12, color: Colors.red)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Flash Sales ──────────────────────────
          const SliverToBoxAdapter(
            child: FlashSalesSection(),
          ),

          // ── Rebajas / Ofertas Destacadas ─────────
          const SliverToBoxAdapter(
            child: OffersSection(),
          ),

          // ── Featured Products ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Destacados',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // ── Product Grid ─────────────────────────
          featured.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.52,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.push('/producto/${product.slug}');
                      },
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Text('Error: $e'),
                ),
              ),
            ),
          ),

          // ── View All Products Button ─────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/productos'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'VER TODOS LOS PRODUCTOS',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    ),
  );
  }
}
