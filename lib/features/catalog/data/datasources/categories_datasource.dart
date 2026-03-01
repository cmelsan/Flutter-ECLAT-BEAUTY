import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/category.dart';

/// DataSource for Categories table operations
class CategoriesDataSource {
  final SupabaseClient _supabase;

  CategoriesDataSource(this._supabase);

  /// Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Fetch a single category by slug
  Future<Category?> fetchCategoryBySlug(String slug) async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .eq('slug', slug)
          .maybeSingle();

      if (response == null) return null;

      return Category.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  /// Fetch a single category by ID
  Future<Category?> fetchCategoryById(String id) async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Category.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  /// Create a new category (Admin only)
  Future<Category> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await _supabase
          .from('categories')
          .insert(categoryData)
          .select()
          .single();

      return Category.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  /// Update an existing category (Admin only)
  Future<Category> updateCategory(
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _supabase
          .from('categories')
          .update(updates)
          .eq('id', categoryId)
          .select()
          .single();

      return Category.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  /// Delete a category (Admin only)
  /// Note: Will fail if category has associated products (CASCADE constraint)
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _supabase.from('categories').delete().eq('id', categoryId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  /// Get category count (Admin dashboard)
  Future<int> getCategoryCount() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get category count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get category count: $e');
    }
  }
}
