import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/flash_sales_repository.dart';
import '../providers/flash_sales_provider.dart';

/// Flash Sales section widget (used on HomeScreen)
class FlashSalesSection extends ConsumerWidget {
  const FlashSalesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashState = ref.watch(flashSalesProvider);

    if (!flashState.isEnabled || flashState.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with countdown
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              const Icon(Icons.flash_on, color: AppColors.flashSale, size: 28),
              const SizedBox(width: 8),
              Text(
                'FLASH SALE',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
              ),
              const Spacer(),
              _CountdownWidget(
                timeRemaining: flashState.timeRemaining,
                isExpired: flashState.isExpired,
              ),
            ],
          ),
        ),

        // Horizontal product carousel
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: flashState.products.length,
            itemBuilder: (context, index) {
              return _FlashSaleCard(product: flashState.products[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _CountdownWidget extends StatelessWidget {
  final Duration timeRemaining;
  final bool isExpired;

  const _CountdownWidget({
    required this.timeRemaining,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Oferta Finalizada',
          style: TextStyle(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      );
    }

    final hours = timeRemaining.inHours % 24;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;

    return Row(
      children: [
        _TimeBox(value: hours.toString().padLeft(2, '0'), label: 'H'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.flashSale)),
        ),
        _TimeBox(value: minutes.toString().padLeft(2, '0'), label: 'M'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.flashSale)),
        ),
        _TimeBox(value: seconds.toString().padLeft(2, '0'), label: 'S'),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.flashSale,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _FlashSaleCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _FlashSaleCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final price = product['price'] as int? ?? 0;
    final discount = (product['flash_sale_discount'] as num?)?.toDouble() ?? 0;
    final discountedPrice =
        FlashSalesRepository.calculateDiscountedPrice(price, discount);
    final images = product['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images[0] as String : '';
    final brandData = product['brand'] as Map<String, dynamic>?;
    final brandName = brandData?['name'] as String? ?? '';
    final slug = product['slug'] as String? ?? '';

    return GestureDetector(
      onTap: () => context.push('/producto/$slug'),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with discount badge
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: AppColors.backgroundSecondary,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, _, _) => Container(
                              color: AppColors.backgroundSecondary,
                              child: const Icon(Icons.image_not_supported_outlined),
                            ),
                          )
                        : Container(
                            color: AppColors.backgroundSecondary,
                            child: const Icon(Icons.image_outlined, size: 48),
                          ),
                  ),

                  // Discount badge
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.flashSale,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${discount.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Product info
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (brandName.isNotEmpty)
                      Text(
                        brandName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      product['name'] as String? ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Prices
                    Row(
                      children: [
                        Text(
                          AppUtils.formatPrice(discountedPrice),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.flashSale,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppUtils.formatPrice(price),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
