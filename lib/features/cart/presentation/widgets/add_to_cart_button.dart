import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/cart_provider.dart';
import 'cart_slide_over.dart';

class AddToCartButton extends ConsumerStatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback? onAdded;

  const AddToCartButton({
    super.key,
    required this.product,
    this.quantity = 1,
    this.onAdded,
  });

  @override
  ConsumerState<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<AddToCartButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    // Validar stock
    if (!widget.product.isInStock) {
      _showErrorSnackBar('Producto agotado');
      return;
    }

    if (widget.quantity > widget.product.stock) {
      _showErrorSnackBar(
        'Solo hay ${widget.product.stock} unidades disponibles',
      );
      return;
    }

    setState(() => _isLoading = true);
    _animationController.forward().then((_) => _animationController.reverse());

    try {
      // Añadir al carrito
      ref.read(cartProvider.notifier).addToCart(
            product: widget.product,
            quantity: widget.quantity,
          );

      // Mostrar SnackBar de éxito y CartSlideOver
      if (mounted) {
        _showSuccessSnackBar();
        widget.onAdded?.call();
        // Esperar un momento para que el usuario vea la animación
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            CartSlideOver.show(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${widget.product.name} añadido al carrito'),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = !widget.product.isInStock;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isOutOfStock || _isLoading ? null : _handleAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutOfStock ? AppColors.textTertiary : null,
            disabledBackgroundColor: AppColors.textTertiary,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isOutOfStock
                          ? 'AGOTADO'
                          : 'AÑADIR AL CARRITO',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Compact quick-add button for product cards
class QuickAddToCartButton extends ConsumerStatefulWidget {
  final Product product;

  const QuickAddToCartButton({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<QuickAddToCartButton> createState() =>
      _QuickAddToCartButtonState();
}

class _QuickAddToCartButtonState extends ConsumerState<QuickAddToCartButton> {
  bool _isLoading = false;

  Future<void> _handleQuickAdd() async {
    if (!widget.product.isInStock) return;

    setState(() => _isLoading = true);

    try {
      ref.read(cartProvider.notifier).addToCart(
            product: widget.product,
            quantity: 1,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text('Añadido al carrito'),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.product.isInStock && !_isLoading
          ? _handleQuickAdd
          : null,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.add_shopping_cart, size: 18),
    );
  }
}
