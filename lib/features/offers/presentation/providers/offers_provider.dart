import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/offers_repository.dart';

part 'offers_provider.freezed.dart';

// ─── State ──────────────────────────────────────────────

@freezed
class OffersState with _$OffersState {
  const factory OffersState({
    @Default(false) bool isEnabled,
    @Default([]) List<Map<String, dynamic>> products,
    @Default(false) bool isLoading,
    String? error,
  }) = _OffersState;
}

// ─── Providers ──────────────────────────────────────────

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository(Supabase.instance.client);
});

/// Real-time stream of `offers_enabled` setting.
final offersEnabledStreamProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(offersRepositoryProvider);
  return repo.watchOffersEnabled();
});

/// Main offers state provider (mirrors flash_sales_provider pattern).
final offersProvider =
    StateNotifierProvider<OffersNotifier, OffersState>((ref) {
  final repo = ref.watch(offersRepositoryProvider);
  final isEnabledAsync = ref.watch(offersEnabledStreamProvider);

  final notifier = OffersNotifier(repo);

  isEnabledAsync.whenData((isEnabled) {
    if (isEnabled) {
      notifier.loadOffers(forceEnabled: true);
    } else {
      notifier.disableOffers();
    }
  });

  return notifier;
});

/// Cached map of productId → discount% from featured_offers.
/// Used by product detail to apply rebaja pricing.
final featuredOffersMapProvider =
    FutureProvider<Map<String, num>>((ref) async {
  final repo = ref.watch(offersRepositoryProvider);

  // Check enabled first
  final enabledResult = await repo.isOffersEnabled();
  final isEnabled = enabledResult.fold((_) => false, (v) => v);
  if (!isEnabled) return {};

  final result = await repo.getFeaturedOffers();
  return result.fold(
    (_) => {},
    (offers) {
      final map = <String, num>{};
      for (final o in offers) {
        final id = o['id'] as String?;
        final disc = o['discount'] as num?;
        if (id != null && disc != null) {
          map[id] = disc;
        }
      }
      return map;
    },
  );
});

// ─── Notifier ───────────────────────────────────────────

class OffersNotifier extends StateNotifier<OffersState> {
  final OffersRepository _repo;

  OffersNotifier(this._repo) : super(const OffersState());

  void disableOffers() {
    state = state.copyWith(isEnabled: false, isLoading: false);
  }

  Future<void> loadOffers({bool forceEnabled = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    if (!forceEnabled) {
      final enabledResult = await _repo.isOffersEnabled();
      final isEnabled = enabledResult.fold((_) => false, (v) => v);

      if (!isEnabled) {
        state = state.copyWith(isLoading: false, isEnabled: false);
        return;
      }
    }

    final productsResult = await _repo.getOfferProducts();
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

        state = state.copyWith(
          isLoading: false,
          isEnabled: true,
          products: products,
        );
      },
    );
  }
}
