import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/services/email_service.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../data/repositories/checkout_repository.dart';
import '../../data/services/stripe_service.dart';

/// Repository provider
final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(supabaseClientProvider));
});

/// Stripe service provider
final stripeServiceProvider = Provider<StripeService>((ref) {
  return StripeService();
});

/// Checkout flow state
enum CheckoutStep { address, payment, confirmation }

class CheckoutState {
  final CheckoutStep step;
  final Map<String, dynamic>? shippingAddress;
  final String? guestEmail;
  final String? customerName;
  final bool isLoading;
  final String? error;
  final String? orderId;
  final String? orderNumber;
  final String? stripeUrl;

  const CheckoutState({
    this.step = CheckoutStep.address,
    this.shippingAddress,
    this.guestEmail,
    this.customerName,
    this.isLoading = false,
    this.error,
    this.orderId,
    this.orderNumber,
    this.stripeUrl,
  });

  CheckoutState copyWith({
    CheckoutStep? step,
    Map<String, dynamic>? shippingAddress,
    String? guestEmail,
    String? customerName,
    bool? isLoading,
    String? error,
    String? orderId,
    String? orderNumber,
    String? stripeUrl,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      guestEmail: guestEmail ?? this.guestEmail,
      customerName: customerName ?? this.customerName,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      stripeUrl: stripeUrl ?? this.stripeUrl,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CheckoutRepository _repo;
  final StripeService _stripe;
  final Ref _ref;

  CheckoutNotifier(this._repo, this._stripe, this._ref) : super(const CheckoutState());

  void setShippingAddress(Map<String, dynamic> address) {
    state = state.copyWith(
      shippingAddress: address,
      step: CheckoutStep.address, // Stay on address/summary screen until payment is confirmed
    );
  }

  void setGuestInfo({required String email, required String name}) {
    state = state.copyWith(guestEmail: email, customerName: name);
  }

  /// Create order AND process payment via Stripe Payment Sheet
  Future<void> processOrder({
    required List<CartItem> items,
    required int totalAmount,
    String? couponId,
    int discountAmount = 0,
    String? email,
  }) async {
    debugPrint('processOrder called. shippingAddress: ${state.shippingAddress}');
    if (state.shippingAddress == null) {
      debugPrint('Error: shippingAddress is null');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    // Step 1: Create order in Supabase
    // Convert CartItem to Map for RPC
    final rpcItems = items.map((item) => {
      'product_id': item.productId,
      'quantity': item.quantity,
      'price': item.effectivePrice, 
    }).toList();

    final result = await _repo.createOrder(
      items: rpcItems,
      totalAmount: totalAmount,
      shippingAddress: state.shippingAddress!,
      guestEmail: state.guestEmail,
      customerName: state.customerName,
      couponId: couponId,
      discountAmount: discountAmount,
    );

    await result.fold(
      (failure) async {
        debugPrint('Error creating order: ${failure.message}');
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (data) async {
        final orderId = data['order_id'] as String;
        final orderNumber = data['order_number'] as String;
        
        debugPrint('Order created successfully: $orderId');
        
        // Step 2: Initialize Stripe Payment Sheet or Checkout Session
        final customerEmail = email ?? state.guestEmail ?? '';

        if (customerEmail.isNotEmpty) {
          if (kIsWeb) {
            debugPrint('Creating Stripe Checkout Session for $customerEmail on Web');
            final webItems = items.map((e) => {
              'product': { 'id': e.productId },
              'quantity': e.quantity,
              'price': e.effectivePrice,
            }).toList();

            final checkoutResult = await _stripe.createCheckoutSession(
              items: webItems,
              orderId: orderId,
              email: customerEmail,
              discountAmount: discountAmount,
            );

            checkoutResult.fold(
              (failure) {
                debugPrint('Error creating checkout session: ${failure.message}');
                state = state.copyWith(isLoading: false, error: failure.message);
              },
              (url) async {
                debugPrint('Redirecting to Stripe Checkout: $url');
                state = state.copyWith(
                  isLoading: false,
                  orderId: orderId,
                  orderNumber: orderNumber,
                  // on web we stay on checkout screen until redirect succeeds or fails
                );
                
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  state = state.copyWith(error: 'No se pudo abrir la página de pago');
                }
              }
            );
          } else {
            debugPrint('Initializing Payment Sheet for $customerEmail');
            final initResult = await _stripe.initPaymentSheet(
              orderId: orderId,
              items: items,
              email: customerEmail,
              discountAmount: discountAmount,
              couponId: couponId,
            );

            await initResult.fold(
              (failure) async {
                debugPrint('Error initializing Payment Sheet: ${failure.message}');
                state = state.copyWith(isLoading: false, error: failure.message);
              },
              (_) async {
                 debugPrint('Payment Sheet initialized successfully. Presenting...');
                 // Step 3: Present Payment Sheet
                 final presentResult = await _stripe.presentPaymentSheet();

                 presentResult.fold(
                   (failure) {
                     debugPrint('Error presenting Payment Sheet: ${failure.message}');
                     state = state.copyWith(isLoading: false, error: failure.message);
                   },
                   (_) async {
                     debugPrint('Payment successful!');
                     
                     // Vaciar carrito tras el pago exitoso (lo hacemos usando el ref inyectado)
                     _ref.read(cartProvider.notifier).clearCart();                    
                    // IMPORTANTE: Refrescar la lista de pedidos al completar la compra
                    _ref.invalidate(myOrdersProvider);

                     // Send order confirmation email (non-blocking)
                     // The webhook may also send it, but we ensure it
                     // reaches registered users whose receipt_email is null.
                     final confirmEmail = email ?? state.guestEmail ?? '';
                     final confirmName = state.customerName ?? 'Cliente';
                     if (confirmEmail.isNotEmpty) {
                       EmailService.sendOrderConfirmation(
                         email: confirmEmail,
                         customerName: confirmName,
                         orderNumber: orderNumber,
                         items: items.map((e) => <String, dynamic>{
                           'name': e.name,
                           'quantity': e.quantity,
                           'price': e.effectivePrice,
                         }).toList(),
                         totalCents: totalAmount,
                       );
                     }

                     // Success! Move to confirmation
                     state = state.copyWith(
                       isLoading: false,
                       orderId: orderId,
                       orderNumber: orderNumber,
                       step: CheckoutStep.confirmation,
                     );
                   }
                 );
              }
            );
          }
        } else {
          debugPrint('No email provided, skipping Stripe');
          // No Stripe (free order or fallback)
          _ref.read(cartProvider.notifier).clearCart();
          state = state.copyWith(
            isLoading: false,
            orderId: orderId,
            orderNumber: orderNumber,
            step: CheckoutStep.confirmation,
          );
        }
      },
    );
  }

  /// Called when user returns from Stripe payment page
  void confirmPayment() {
    state = state.copyWith(step: CheckoutStep.confirmation);
  }

  void reset() {
    state = const CheckoutState();
  }
}

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(
    ref.watch(checkoutRepositoryProvider),
    ref.watch(stripeServiceProvider),
    ref,
  );
});
