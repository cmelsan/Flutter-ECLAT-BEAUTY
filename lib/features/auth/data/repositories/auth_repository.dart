import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_user.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// Sign up with email and password
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user == null) {
        return const Left(AuthFailure('Error al crear la cuenta'));
      }

      // Profile is auto-created by DB trigger on_auth_user_created
      final profile = await _fetchProfile(response.user!.id);
      return Right(profile);
    } catch (e) {
      return Left(AuthFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Sign in with email and password
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(AuthFailure('Error al iniciar sesión'));
      }

      // Migrate guest cart to user
      await _migrateGuestCart(response.user!.id);

      final profile = await _fetchProfile(response.user!.id);
      return Right(profile);
    } catch (e) {
      return Left(AuthFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Sign out
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get current profile
  Future<Either<Failure, AppUser?>> getCurrentProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return const Right(null);

      final profile = await _fetchProfile(user.id);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Request password reset
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Update user profile
  Future<Either<Failure, AppUser>> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('No hay sesión activa'));
      }

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;

      await _client.from('profiles').update(updates).eq('id', userId);

      final profile = await _fetchProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get user addresses
  Future<Either<Failure, List<UserAddress>>> getAddresses() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Right([]);

      final data = await _client
          .from('user_addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false);

      return Right(
        (data as List).map((e) => UserAddress.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Save or update address
  Future<Either<Failure, UserAddress>> saveAddress(UserAddress address) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Left(AuthFailure('No hay sesión activa'));
      }

      // If setting as default, unset other defaults first
      if (address.isDefault) {
        await _client
            .from('user_addresses')
            .update({'is_default': false})
            .eq('user_id', userId)
            .eq('address_type', address.addressType);
      }

      Map<String, dynamic> data;
      if (address.id.isEmpty) {
        // Insert
        data = await _client.from('user_addresses').insert({
          'user_id': userId,
          'address_data': address.addressData,
          'address_type': address.addressType,
          'is_default': address.isDefault,
        }).select().single();
      } else {
        // Update
        data = await _client
            .from('user_addresses')
            .update({
              'address_data': address.addressData,
              'address_type': address.addressType,
              'is_default': address.isDefault,
            })
            .eq('id', address.id)
            .select()
            .single();
      }

      return Right(UserAddress.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Delete address
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await _client.from('user_addresses').delete().eq('id', addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  // ── Private Helpers ──────────────────────────────

  Future<AppUser> _fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return AppUser.fromJson(data);
  }

  Future<void> _migrateGuestCart(String userId) async {
    try {
      // Get stored session ID from local storage
      // This will be implemented by CartProvider/Repository
      // For now, we'll attempt the migration which will handle it
      // CartRepository should be injected here in production
      await _client.rpc('migrate_guest_cart_to_user', params: {
        'p_user_id': userId,
        // p_session_id will be handled by the RPC function
      });
    } catch (e) {
      // Non-critical error, log but don't fail the login
      debugPrint('Warning: Failed to migrate guest cart: $e');
    }
  }
}
