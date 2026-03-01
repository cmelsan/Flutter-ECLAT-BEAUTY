import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/app_user.dart';

/// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

/// Auth state enum
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Combined auth state
class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAdmin => user?.isAdmin ?? false;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final result = await _repo.getCurrentProfile();
    result.fold(
      (failure) => state = const AuthState(status: AuthStatus.unauthenticated),
      (user) {
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
        } else {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      },
    );

    // Listen to auth changes
    supabase.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        await refreshProfile();
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> refreshProfile() async {
    final result = await _repo.getCurrentProfile();
    result.fold(
      (_) {},
      (user) {
        if (user != null) {
          state = state.copyWith(user: user);
        }
      },
    );
  }

  Future<void> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repo.requestPasswordReset(email);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<Either<Failure, AppUser>> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repo.updateProfile(
      fullName: fullName,
      phone: phone,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
    return result;
  }
}

/// The main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

/// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAdmin;
});

final currentProfileProvider = Provider<AppUser?>((ref) {
  return ref.watch(authProvider).user;
});

/// User addresses provider
final userAddressesProvider = FutureProvider<List<UserAddress>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final result = await repo.getAddresses();
  return result.fold((f) => [], (addresses) => addresses);
});
