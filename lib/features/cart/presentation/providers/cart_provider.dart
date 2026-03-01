import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';

/// Repository provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(supabaseClientProvider));
});

/// Cart state
class CartState {
  final Map<String, CartItem> items;
  final AppliedCoupon? coupon;
  final bool isLoading;

  const CartState({
    this.items = const {},
    this.coupon,
    this.isLoading = false,
  });

  CartState copyWith({
    Map<String, CartItem>? items,
    AppliedCoupon? coupon,
    bool? isLoading,
    bool clearCoupon = false,
  }) {
    return CartState(
      items: items ?? this.items,
      coupon: clearCoupon ? null : (coupon ?? this.coupon),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Total item count
  int get cartCount =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal in cents (before coupon)
  int get subtotal =>
      items.values.fold(0, (sum, item) => sum + item.lineTotal);

  /// Discount amount from coupon
  int get discountAmount => coupon?.discountAmount ?? 0;

  /// Final total in cents
  int get total => max(0, subtotal - discountAmount);

  /// Whether cart is empty
  bool get isEmpty => items.isEmpty;

  /// List form for UI iteration
  List<CartItem> get itemsList => items.values.toList();
}

/// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repo;

  CartNotifier(this._repo) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);

    // Load from local Hive first (offline-first)
    final box = Hive.box('cart');
    final localItems = box.get('items');
    if (localItems != null) {
      try {
        final map = <String, CartItem>{};
        for (final entry in (localItems as Map).entries) {
          map[entry.key as String] =
              CartItem.fromJson(Map<String, dynamic>.from(entry.value));
        }
        state = state.copyWith(items: map);
      } catch (_) {}
    }

    // Then try to sync from Supabase
    final result = await _repo.loadCartFromSupabase();
    result.fold(
      (_) {}, // Keep local on error
      (serverItems) {
        if (serverItems.isNotEmpty) {
          final map = <String, CartItem>{};
          for (final item in serverItems) {
            map[item.productId] = item;
          }
          state = state.copyWith(items: map);
          _saveLocal();
        }
      },
    );

    state = state.copyWith(isLoading: false);
  }

  /// Add product to cart
  void addToCart({required Product product, int quantity = 1}) {
    final existing = state.items[product.id];
    final newQty = (existing?.quantity ?? 0) + quantity;

    if (newQty > product.stock) return; // Don't exceed stock

    final item = CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      discountedPrice: product.discountedPrice,
      quantity: newQty,
      stock: product.stock,
      image: product.primaryImage,
    );

    final newItems = Map<String, CartItem>.from(state.items);
    newItems[product.id] = item;
    state = state.copyWith(items: newItems);

    _saveLocal();
    _syncToServer();
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    final newItems = Map<String, CartItem>.from(state.items);
    newItems.remove(productId);
    state = state.copyWith(items: newItems);

    _saveLocal();
    _syncToServer();
  }

  /// Update quantity
  void updateQuantity(String productId, int quantity) {
    final item = state.items[productId];
    if (item == null) return;
    if (quantity <= 0) return removeFromCart(productId);
    if (quantity > item.stock) return;

    final newItems = Map<String, CartItem>.from(state.items);
    newItems[productId] = item.copyWith(quantity: quantity);
    state = state.copyWith(items: newItems);

    _saveLocal();
    _syncToServer();
  }

  /// Apply coupon
  void applyCoupon({
    required String id,
    required String code,
    required String discountType,
    required int discountValue,
    int? maxDiscountAmount,
  }) {
    final discount = AppUtils.calculateDiscount(
      discountType: discountType,
      discountValue: discountValue,
      maxDiscountAmount: maxDiscountAmount,
      cartTotal: state.subtotal,
    );

    state = state.copyWith(
      coupon: AppliedCoupon(
        id: id,
        code: code,
        discountType: discountType,
        discountValue: discountValue,
        maxDiscountAmount: maxDiscountAmount,
        discountAmount: discount,
      ),
    );
  }

  /// Remove coupon
  void removeCoupon() {
    state = state.copyWith(clearCoupon: true);
  }

  /// Clear entire cart
  void clearCart() {
    state = const CartState();
    _saveLocal();
    _syncToServer();
  }

  // ── Private helpers ──────────────────────────────

  void _saveLocal() {
    final box = Hive.box('cart');
    final map = <String, dynamic>{};
    for (final entry in state.items.entries) {
      map[entry.key] = entry.value.toJson();
    }
    box.put('items', map);
  }

  Future<void> _syncToServer() async {
    await _repo.syncCartToSupabase(state.itemsList);
  }
}

/// The main cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.watch(cartRepositoryProvider));
});

/// Convenience providers
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).cartCount;
});

final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).total;
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});
