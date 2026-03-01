import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: AppColors.textTertiary),
                  SizedBox(height: 16),
                  Text('No tienes favoritos aún'),
                  SizedBox(height: 4),
                  Text(
                    'Pulsa ♡ en un producto para añadirlo',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final product = item.product;

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: product != null &&
                                (product['images'] as List?)?.isNotEmpty == true
                            ? CachedNetworkImage(
                                imageUrl: AppUtils.thumbnailUrl(
                                  (product['images'] as List).first as String,
                                ),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(Icons.image_outlined),
                              ),
                      ),
                    ),
                    title: Text(
                      product?['name'] as String? ?? 'Producto',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: product != null
                        ? Text(
                            AppUtils.formatPrice(product['price'] as int? ?? 0),
                            style: const TextStyle(color: AppColors.primary),
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.error),
                      onPressed: () {
                        ref
                            .read(wishlistProvider.notifier)
                            .toggle(item.productId);
                      },
                    ),
                    onTap: () {
                      // Navigate to product detail
                    },
                  ),
                );
              },
            ),
    );
  }
}
