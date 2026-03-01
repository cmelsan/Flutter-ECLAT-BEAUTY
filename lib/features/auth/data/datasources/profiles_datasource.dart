import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Profiles table operations
class ProfilesDataSource {
  final SupabaseClient _supabase;

  ProfilesDataSource(this._supabase);

  /// Fetch current user's profile
  Future<Map<String, dynamic>?> fetchCurrentProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Fetch profile by user ID
  Future<Map<String, dynamic>?> fetchProfileById(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return false;

      return response['is_admin'] == true;
    } on PostgrestException catch (e) {
      throw Exception('Failed to check admin status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check admin status: $e');
    }
  }

  /// Fetch all user profiles (Admin only)
  Future<List<Map<String, dynamic>>> fetchAllProfiles({
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('profiles')
          .select('*')
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch profiles: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch profiles: $e');
    }
  }

  /// Set admin status for a user (Super Admin only)
  Future<Map<String, dynamic>> setAdminStatus({
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      final response = await _supabase
          .from('profiles')
          .update({'is_admin': isAdmin})
          .eq('id', userId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to update admin status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update admin status: $e');
    }
  }

  /// Get total user count (Admin dashboard)
  Future<int> getTotalUserCount() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*')
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get user count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user count: $e');
    }
  }
}
