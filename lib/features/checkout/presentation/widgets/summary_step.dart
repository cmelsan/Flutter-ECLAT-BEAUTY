import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_utils.dart';
import '../../domain/entities/address.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class SummaryStep extends ConsumerStatefulWidget {
  final Address shippingAddress;
  final Function() onEditAddress;
  final Function() onPlaceOrder;
  final bool isLoading;

  const SummaryStep({
    super.key,
    required this.shippingAddress,
    required this.onEditAddress,
    required this.onPlaceOrder,
    this.isLoading = false,
  });

  @override
  ConsumerState<SummaryStep> createState() => _SummaryStepState();
}

class _SummaryStepState extends ConsumerState<SummaryStep> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Resumen del pedido',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Revisa los datos antes de realizar el pago',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Shipping Address Section
          _buildShippingAddressSection(context),
          const SizedBox(height: 24),

          // Order Items Section
          _buildOrderItemsSection(context, cart),
          const SizedBox(height: 24),

          // Price Summary Section
          _buildPriceSummarySection(context, cart),
          const SizedBox(height: 24),

          // Terms and Conditions
          _buildTermsAndConditions(context),
          const SizedBox(height: 32),

          // Place Order Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Button pressed. _acceptTerms: $_acceptTerms, isLoading: ${widget.isLoading}');
                if (_acceptTerms && !widget.isLoading) {
                  widget.onPlaceOrder();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.textSecondary.withValues(alpha: 0.3),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'PAGAR CON STRIPE ${AppUtils.formatPrice(cart.total)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dirección de envío',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: widget.onEditAddress,
                child: const Text('EDITAR'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.shippingAddress.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.shippingAddress.street),
          if (widget.shippingAddress.addressLine2 != null) ...[
            const SizedBox(height: 2),
            Text(widget.shippingAddress.addressLine2!),
          ],
          const SizedBox(height: 2),
          Text(
            '${widget.shippingAddress.postalCode} ${widget.shippingAddress.city}',
          ),
          const SizedBox(height: 2),
          Text(widget.shippingAddress.country),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                widget.shippingAddress.phone,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(BuildContext context, CartState cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Artículos del pedido (${cart.cartCount})',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.itemsList.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              final item = cart.itemsList[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: AppColors.textSecondary.withValues(alpha: 0.2),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cantidad: ${item.quantity}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppUtils.formatPrice(item.effectivePrice * item.quantity),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.price != item.effectivePrice)
                          Text(
                            AppUtils.formatPrice(item.price * item.quantity),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummarySection(BuildContext context, CartState cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', cart.subtotal),
          
          if (cart.discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Descuento (${cart.coupon?.code})',
              -cart.discountAmount,
              isDiscount: true,
            ),
          ],
          
          const SizedBox(height: 8),
          _buildPriceRow('Envío', 0, note: 'Gratis'),
          
          const Divider(height: 24),
          
          _buildPriceRow(
            'Total',
            cart.total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    int amount, {
    bool isDiscount = false,
    bool isTotal = false,
    String? note,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        if (note != null)
          Text(
            note,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount 
                  ? AppColors.success 
                  : (isTotal ? AppColors.textPrimary : AppColors.textSecondary),
            ),
          )
        else
          Text(
            AppUtils.formatPrice(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount 
                  ? AppColors.success 
                  : (isTotal ? AppColors.textPrimary : AppColors.textSecondary),
            ),
          ),
      ],
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(
                      text: 'He leído y acepto los ',
                    ),
                    TextSpan(
                      text: 'términos y condiciones',
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(
                      text: ' y la ',
                    ),
                    TextSpan(
                      text: 'política de privacidad',
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
