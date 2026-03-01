import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/brand.dart';

/// DataSource for Brands table operations
class BrandsDataSource {
  final SupabaseClient _supabase;

  BrandsDataSource(this._supabase);

  /// Fetch all brands
  Future<List<Brand>> fetchBrands() async {
    try {
      final response = await _supabase
          .from('brands')
          .select('*')
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Brand.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch brands: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }

  /// Fetch a single brand by slug
  Future<Brand?> fetchBrandBySlug(String slug) async {
    try {
      final response = await _supabase
          .from('brands')
          .select('*')
          .eq('slug', slug)
          .maybeSingle();

      if (response == null) return null;

      return Brand.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch brand: $e');
    }
  }

  /// Fetch a single brand by ID
  Future<Brand?> fetchBrandById(String id) async {
    try {
      final response = await _supabase
          .from('brands')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Brand.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch brand: $e');
    }
  }

  /// Create a new brand (Admin only)
  Future<Brand> createBrand(Map<String, dynamic> brandData) async {
    try {
      final response = await _supabase
          .from('brands')
          .insert(brandData)
          .select()
          .single();

      return Brand.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create brand: $e');
    }
  }

  /// Update an existing brand (Admin only)
  Future<Brand> updateBrand(
    String brandId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _supabase
          .from('brands')
          .update(updates)
          .eq('id', brandId)
          .select()
          .single();

      return Brand.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update brand: $e');
    }
  }

  /// Delete a brand (Admin only)
  Future<void> deleteBrand(String brandId) async {
    try {
      await _supabase.from('brands').delete().eq('id', brandId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete brand: $e');
    }
  }

  /// Get brand count (Admin dashboard)
  Future<int> getBrandCount() async {
    try {
      final response = await _supabase
          .from('brands')
          .select('*')
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get brand count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get brand count: $e');
    }
  }
}
