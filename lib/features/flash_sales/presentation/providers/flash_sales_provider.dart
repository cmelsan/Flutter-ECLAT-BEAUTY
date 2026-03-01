import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/flash_sales_repository.dart';

part 'flash_sales_provider.freezed.dart';

@freezed
class FlashSalesState with _$FlashSalesState {
  const factory FlashSalesState({
    @Default(false) bool isEnabled,
    @Default([]) List<Map<String, dynamic>> products,
    @Default(false) bool isLoading,
    DateTime? endTime,
    @Default(Duration.zero) Duration timeRemaining,
    @Default(false) bool isExpired,
    String? error,
  }) = _FlashSalesState;
}

final flashSalesRepositoryProvider = Provider<FlashSalesRepository>((ref) {
  return FlashSalesRepository(Supabase.instance.client);
});

final flashSaleEnabledStreamProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(flashSalesRepositoryProvider);
  return repo.watchFlashSaleEnabled();
});

final flashSalesProvider =
    StateNotifierProvider<FlashSalesNotifier, FlashSalesState>((ref) {
  final repo = ref.watch(flashSalesRepositoryProvider);
  final isEnabledAsync = ref.watch(flashSaleEnabledStreamProvider);
  
  final notifier = FlashSalesNotifier(repo);
  
  isEnabledAsync.whenData((isEnabled) {
    if (isEnabled) {
      notifier.loadFlashSales(forceEnabled: true);
    } else {
      notifier.disableFlashSales();
    }
  });
  
  return notifier;
});

class FlashSalesNotifier extends StateNotifier<FlashSalesState> {
  final FlashSalesRepository _repo;
  Timer? _countdownTimer;

  FlashSalesNotifier(this._repo) : super(const FlashSalesState());

  void disableFlashSales() {
    _countdownTimer?.cancel();
    state = state.copyWith(isEnabled: false, isLoading: false);
  }

  Future<void> loadFlashSales({bool forceEnabled = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    if (!forceEnabled) {
      // Check if enabled
      final enabledResult = await _repo.isFlashSaleEnabled();
      final isEnabled = enabledResult.fold((_) => false, (v) => v);

      if (!isEnabled) {
        state = state.copyWith(isLoading: false, isEnabled: false);
        return;
      }
    }

    // Fetch products
    final productsResult = await _repo.getFlashSaleProducts();
    productsResult.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (products) {
        if (products.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            isEnabled: false,
            products: [],
          );
          return;
        }

        final endTime = FlashSalesRepository.getLatestEndTime(products);
        state = state.copyWith(
          isLoading: false,
          isEnabled: true,
          products: products,
          endTime: endTime,
        );

        _startCountdown();
      },
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    if (state.endTime == null) return;

    _updateTimeRemaining();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTimeRemaining(),
    );
  }

  void _updateTimeRemaining() {
    if (state.endTime == null) return;

    final now = DateTime.now().toUtc();
    final end = state.endTime!.toUtc();
    final difference = end.difference(now);

    if (difference.isNegative) {
      state = state.copyWith(
        timeRemaining: Duration.zero,
        isExpired: true,
      );
      _countdownTimer?.cancel();
    } else {
      state = state.copyWith(
        timeRemaining: difference,
        isExpired: false,
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
