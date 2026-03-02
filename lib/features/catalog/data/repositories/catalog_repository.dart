import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/brand.dart';

class CatalogRepository {
  final SupabaseClient _client;

  CatalogRepository(this._client);

  // ── Categories ────────────────────────────────────

  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final data = await _client
          .from('categories')
          .select()
          .order('name');
      return Right(
        (data as List).map((e) => Category.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  // ── Brands ────────────────────────────────────────

  Future<Either<Failure, List<Brand>>> getBrands() async {
    try {
      final data = await _client
          .from('brands')
          .select()
          .order('name');
      return Right(
        (data as List).map((e) => Brand.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  // ── Products ──────────────────────────────────────

  Future<Either<Failure, List<Product>>> getProducts({
    String? categorySlug,
    String? brandSlug,
    String? categoryId,
    String? brandId,
    String? searchQuery,
    int? minPrice, // in cents
    int? maxPrice, // in cents
    String? search,
    String sortBy = 'created_at',
    bool ascending = false,
    int page = 0,
    int limit = 12,
  }) async {
    try {
      var query = _client
          .from('products')
          .select('*, category:categories(*), brand:brands(*)');

      List<String> parseIds(String? value) {
        if (value == null || value.trim().isEmpty) return const [];
        return value
            .split(',')
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();
      }

      if (categorySlug != null) {
        // Need to filter by category slug via join
        final cat = await _client
            .from('categories')
            .select('id')
            .eq('slug', categorySlug)
            .maybeSingle();
        if (cat != null) {
          query = query.eq('category_id', cat['id']);
        }
      }

      final categoryIds = parseIds(categoryId);
      if (categoryIds.length == 1) {
        query = query.eq('category_id', categoryIds.first);
      } else if (categoryIds.length > 1) {
        query = query.inFilter('category_id', categoryIds);
      }

      if (brandSlug != null) {
        final brand = await _client
            .from('brands')
            .select('id')
            .eq('slug', brandSlug)
            .maybeSingle();
        if (brand != null) {
          query = query.eq('brand_id', brand['id']);
        }
      }

      final brandIds = parseIds(brandId);
      if (brandIds.length == 1) {
        query = query.eq('brand_id', brandIds.first);
      } else if (brandIds.length > 1) {
        query = query.inFilter('brand_id', brandIds);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('name.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
      }

      if (search != null && search.isNotEmpty) {
        query = query.or('name.ilike.%$search%,description.ilike.%$search%');
      }

      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }

      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      final data = await query
          .order(sortBy, ascending: ascending)
          .range(page * limit, (page + 1) * limit - 1);

      return Right(
        (data as List).map((e) => Product.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get a single product by slug with full details
  Future<Either<Failure, Product>> getProductBySlug(String slug) async {
    try {
      final data = await _client
          .from('products')
          .select('*, category:categories(*), brand:brands(*)')
          .eq('slug', slug)
          .single();
      return Right(Product.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final data = await _client
          .from('products')
          .select('*, category:categories(*), brand:brands(*)')
          .eq('id', id)
          .single();
      return Right(Product.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get featured/best-selling products (for home screen)
  Future<Either<Failure, List<Product>>> getFeaturedProducts({
    int limit = 8,
  }) async {
    try {
      final data = await _client
          .from('products')
          .select('*, category:categories(*), brand:brands(*)')
          .order('created_at', ascending: false)
          .limit(limit);
      debugPrint('\u2705 getFeaturedProducts: ${(data as List).length} products');
      return Right(
        data.map((e) => Product.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('\u274c getFeaturedProducts error: $e');
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Search products
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    return getProducts(searchQuery: query);
  }
}
