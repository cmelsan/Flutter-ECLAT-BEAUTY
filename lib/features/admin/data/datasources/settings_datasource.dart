import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Settings table operations (Admin configuration)
class SettingsDataSource {
  final SupabaseClient _supabase;

  SettingsDataSource(this._supabase);

  /// Fetch application settings
  Future<Map<String, dynamic>?> fetchSettings() async {
    try {
      final response = await _supabase
          .from('settings')
          .select('*')
          .limit(1)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch settings: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch settings: $e');
    }
  }

  /// Update application settings (Admin only)
  Future<Map<String, dynamic>> updateSettings(
    Map<String, dynamic> updates,
  ) async {
    try {
      // Get the first (and should be only) settings record
      final existing = await fetchSettings();

      if (existing == null) {
        // Create initial settings if none exist
        final response = await _supabase
            .from('settings')
            .insert(updates)
            .select()
            .single();

        return response;
      } else {
        // Update existing settings
        final response = await _supabase
            .from('settings')
            .update(updates)
            .eq('id', existing['id'])
            .select()
            .single();

        return response;
      }
    } on PostgrestException catch (e) {
      throw Exception('Failed to update settings: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  /// Check if offers are enabled
  Future<bool> areOffersEnabled() async {
    try {
      final settings = await fetchSettings();
      return settings?['offers_enabled'] == true;
    } catch (e) {
      return false; // Default to false if error
    }
  }

  /// Check if flash sales are enabled
  Future<bool> areFlashSalesEnabled() async {
    try {
      final settings = await fetchSettings();
      return settings?['flash_sale_enabled'] == true;
    } catch (e) {
      return false; // Default to false if error
    }
  }

  /// Get flash sale duration in hours
  Future<int> getFlashSaleDuration() async {
    try {
      final settings = await fetchSettings();
      return settings?['flash_sale_duration_hours'] as int? ?? 24;
    } catch (e) {
      return 24; // Default to 24 hours
    }
  }

  /// Toggle offers enabled status
  Future<Map<String, dynamic>> toggleOffers(bool enabled) async {
    return updateSettings({'offers_enabled': enabled});
  }

  /// Toggle flash sales enabled status
  Future<Map<String, dynamic>> toggleFlashSales(bool enabled) async {
    return updateSettings({'flash_sale_enabled': enabled});
  }

  /// Set flash sale duration
  Future<Map<String, dynamic>> setFlashSaleDuration(int hours) async {
    return updateSettings({'flash_sale_duration_hours': hours});
  }
}
