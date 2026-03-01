import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/address.dart';
import '../providers/checkout_provider.dart';
import '../widgets/address_step.dart';
import '../widgets/summary_step.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  Address? _shippingAddress;
  String? _guestEmail;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);

    // Listen for errors and changes in the checkout step
    ref.listen<CheckoutState>(checkoutProvider, (previous, next) {
      if (previous?.error != next.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      
      // Si el pago es exitoso, navegamos a la pantalla de éxito
      if (previous?.step != CheckoutStep.confirmation && next.step == CheckoutStep.confirmation) {
         context.go('/checkout/success');
      }
    });

    // Redirect if cart is empty y NO estamos en la fase de confirmación
    if (cart.isEmpty && checkoutState.step != CheckoutStep.confirmation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/carrito');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Finalizar pedido'),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: switch (checkoutState.step) {
        CheckoutStep.address => _buildStepBasedCheckout(context, cart),
        CheckoutStep.payment => _buildPaymentPending(context, checkoutState),
        CheckoutStep.confirmation => _buildConfirmation(context, checkoutState),
      },
    );
  }

  Widget _buildStepBasedCheckout(BuildContext context, CartState cart) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          
          // Step content
          _currentStep == 0
              ? AddressStep(
                  initialAddress: _shippingAddress,
                  showGuestFields: true,
                  onContinue: (address, guestEmail) {
                    setState(() {
                      _shippingAddress = address;
                      _guestEmail = guestEmail;
                      _currentStep = 1;
                    });
                  },
                )
              : SummaryStep(
                  shippingAddress: _shippingAddress!,
                  isLoading: ref.watch(checkoutProvider).isLoading,
                  onEditAddress: () {
                    setState(() {
                      _currentStep = 0;
                    });
                  },
                  onPlaceOrder: () => _placeOrder(cart),
                ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Step 1: Address
          _buildStepIndicator(
            stepNumber: 1,
            title: 'Dirección',
            isActive: _currentStep == 0,
            isCompleted: _currentStep > 0,
          ),
          
          // Connector line
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _currentStep > 0 
                    ? AppColors.primary 
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          
          // Step 2: Payment
          _buildStepIndicator(
            stepNumber: 2,
            title: 'Pago',
            isActive: _currentStep == 1,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive 
                ? AppColors.primary 
                : AppColors.textSecondary.withValues(alpha: 0.3),
            border: Border.all(
              color: isCompleted || isActive 
                  ? AppColors.primary 
                  : AppColors.textSecondary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive || isCompleted 
                ? AppColors.primary 
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _placeOrder(CartState cart) {
    debugPrint('Place order button clicked');
    final auth = ref.read(authProvider);
    final email = auth.isAuthenticated
        ? (auth.user?.email ?? '')
        : _guestEmail ?? '';

    // Set shipping address using new Address entity
    final addressMap = _shippingAddress!.toJson();
    debugPrint('Setting shipping address: $addressMap');
    ref.read(checkoutProvider.notifier).setShippingAddress(addressMap);

    // Set guest info if not logged in
    if (!auth.isAuthenticated && _guestEmail != null) {
      debugPrint('Setting guest info: $_guestEmail');
      ref.read(checkoutProvider.notifier).setGuestInfo(
        email: _guestEmail!,
        name: _shippingAddress!.fullName,
      );
    }

    debugPrint('Calling processOrder with email: $email');
    // Create order + redirect to Stripe
    ref.read(checkoutProvider.notifier).processOrder(
      items: cart.itemsList,
      totalAmount: cart.total,
      couponId: cart.coupon?.id,
      discountAmount: cart.discountAmount,
      email: email,
    );

    // NOTE: Cart will be cleared after successful payment in success screen
    // Do NOT clear cart here - we need it for the payment flow
  }

  Widget _buildPaymentPending(BuildContext context, CheckoutState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Procesando pago...',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Nº de pedido: ${state.orderNumber ?? ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Por favor, completa el pago en la ventana de Stripe.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation(BuildContext context, CheckoutState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.success,
            ),
            const SizedBox(height: 24),
            Text(
              '¡Pedido realizado!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Nº de pedido: ${state.orderNumber ?? ''}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Recibirás un email de confirmación con los detalles.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(checkoutProvider.notifier).reset();
                context.go('/');
              },
              child: const Text('VOLVER AL INICIO'),
            ),
          ],
        ),
      ),
    );
  }
}
