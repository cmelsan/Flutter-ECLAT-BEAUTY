import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/product.dart';

/// DataSource for Products table operations
class ProductsDataSource {
  final SupabaseClient _supabase;

  ProductsDataSource(this._supabase);

  /// Fetch products with optional filters
  /// 
  /// Parameters:
  /// - [categorySlug]: Filter by category slug
  /// - [brandSlug]: Filter by brand slug
  /// - [subcategorySlug]: Filter by subcategory slug
  /// - [minPrice]: Minimum price in cents
  /// - [maxPrice]: Maximum price in cents
  /// - [isFlashSale]: Filter only flash sale products
  /// - [search]: Search term for product name/description
  /// - [sortBy]: Sort field (name, price, created_at)
  /// - [sortAscending]: Sort direction
  /// - [page]: Page number (0-indexed)
  /// - [limit]: Items per page
  Future<List<Product>> fetchProducts({
    String? categorySlug,
    String? brandSlug,
    String? subcategorySlug,
    int? minPrice,
    int? maxPrice,
    bool? isFlashSale,
    String? search,
    String sortBy = 'created_at',
    bool sortAscending = false,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      dynamic query = _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''');

      // Apply filters
      if (categorySlug != null) {
        query = query.eq('categories.slug', categorySlug);
      }

      if (brandSlug != null) {
        query = query.eq('brands.slug', brandSlug);
      }

      if (subcategorySlug != null) {
        // Note: Assuming subcategories table exists
        query = query.eq('subcategories.slug', subcategorySlug);
      }

      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }

      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      if (isFlashSale == true) {
        query = query
            .eq('is_flash_sale', true)
            .gt('flash_sale_end_time', DateTime.now().toIso8601String());
      }

      if (search != null && search.isNotEmpty) {
        query = query.or('name.ilike.%$search%,description.ilike.%$search%');
      }

      // Apply sorting
      query = query.order(sortBy, ascending: sortAscending);

      // Apply pagination
      final from = page * limit;
      final to = from + limit - 1;
      query = query.range(from, to);

      final response = await query;

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch a single product by slug
  Future<Product?> fetchProductBySlug(String slug) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''')
          .eq('slug', slug)
          .maybeSingle();

      if (response == null) return null;

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Fetch a single product by ID
  Future<Product?> fetchProductById(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Fetch products by IDs (bulk fetch)
  Future<List<Product>> fetchProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''')
          .inFilter('id', ids);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch flash sale products
  Future<List<Product>> fetchFlashSaleProducts({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''')
          .eq('is_flash_sale', true)
          .gt('flash_sale_end_time', DateTime.now().toIso8601String())
          .order('flash_sale_end_time', ascending: true)
          .limit(limit);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch flash sale products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch flash sale products: $e');
    }
  }

  /// Fetch related products (same category, excluding current product)
  Future<List<Product>> fetchRelatedProducts(
    String productId,
    String categoryId, {
    int limit = 6,
  }) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            category:categories!products_category_id_fkey(id, name, slug),
            brand:brands!products_brand_id_fkey(id, name, slug, logo)
          ''')
          .eq('category_id', categoryId)
          .neq('id', productId)
          .gt('stock', 0)
          .limit(limit);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch related products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch related products: $e');
    }
  }

  /// Create a new product (Admin only)
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _supabase
          .from('products')
          .insert(productData)
          .select()
          .single();

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  /// Update an existing product (Admin only)
  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _supabase
          .from('products')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', productId)
          .select()
          .single();

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete a product (Admin only)
  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase.from('products').delete().eq('id', productId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Update product stock (Admin only)
  Future<void> updateStock(String productId, int newStock) async {
    try {
      await _supabase
          .from('products')
          .update({'stock': newStock})
          .eq('id', productId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update stock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  /// Set flash sale for a product (Admin only)
  Future<void> setFlashSale({
    required String productId,
    required double discount,
    required DateTime endTime,
  }) async {
    try {
      await _supabase.from('products').update({
        'is_flash_sale': true,
        'flash_sale_discount': discount,
        'flash_sale_end_time': endTime.toIso8601String(),
      }).eq('id', productId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to set flash sale: ${e.message}');
    } catch (e) {
      throw Exception('Failed to set flash sale: $e');
    }
  }

  /// Remove flash sale from a product (Admin only)
  Future<void> removeFlashSale(String productId) async {
    try {
      await _supabase.from('products').update({
        'is_flash_sale': false,
        'flash_sale_discount': null,
        'flash_sale_end_time': null,
      }).eq('id', productId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to remove flash sale: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove flash sale: $e');
    }
  }

  /// Get products with low stock (Admin dashboard)
  Future<List<Product>> fetchLowStockProducts({int threshold = 10}) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .lte('stock', threshold)
          .gt('stock', 0)
          .order('stock', ascending: true);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch low stock products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch low stock products: $e');
    }
  }
}
