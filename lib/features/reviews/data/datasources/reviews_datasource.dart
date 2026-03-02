import 'package:supabase_flutter/supabase_flutter.dart';

/// DataSource for Reviews table operations
class ReviewsDataSource {
  final SupabaseClient _supabase;

  ReviewsDataSource(this._supabase);

  /// Fetch reviews for a product
  Future<List<Map<String, dynamic>>> fetchProductReviews({
    required String productId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('reviews')
          .select('''
            *,
            user:profiles!reviews_user_id_fkey(id, email)
          ''')
          .eq('product_id', productId)
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
      throw Exception('Failed to fetch reviews: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  /// Fetch user's reviews
  Future<List<Map<String, dynamic>>> fetchUserReviews(String userId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('''
            *,
            product:products!reviews_product_id_fkey(id, name, slug, images)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user reviews: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch user reviews: $e');
    }
  }

  /// Check if user has reviewed a product
  Future<bool> hasUserReviewedProduct({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to check review status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check review status: $e');
    }
  }

  /// Create a new review
  Future<Map<String, dynamic>> createReview({
    required String productId,
    required String userId,
    required int rating,
    String? comment,
  }) async {
    try {
      // Check if user already reviewed this product
      final hasReviewed = await hasUserReviewedProduct(
        userId: userId,
        productId: productId,
      );

      if (hasReviewed) {
        throw Exception('Ya has valorado este producto');
      }

      final response = await _supabase
          .from('reviews')
          .insert({
            'product_id': productId,
            'user_id': userId,
            'rating': rating,
            if (comment != null && comment.isNotEmpty) 'comment': comment,
          })
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation
        throw Exception('Ya has valorado este producto');
      }
      throw Exception('Failed to create review: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Ya has valorado')) {
        rethrow;
      }
      throw Exception('Failed to create review: $e');
    }
  }

  /// Update a review
  Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await _supabase
          .from('reviews')
          .update({
            'rating': rating,
            'comment': comment,
          })
          .eq('id', reviewId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to update review: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  /// Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _supabase.from('reviews').delete().eq('id', reviewId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete review: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  /// Get average rating for a product
  Future<Map<String, dynamic>> getProductRating(String productId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('rating')
          .eq('product_id', productId);

      final reviews = response;
      
      if (reviews.isEmpty) {
        return {
          'average': 0.0,
          'count': 0,
          'distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        };
      }

      final ratings = reviews.map((r) => r['rating'] as int).toList();
      final average = ratings.reduce((a, b) => a + b) / ratings.length;

      // Calculate distribution
      final distribution = <int, int>{};
      for (var i = 1; i <= 5; i++) {
        distribution[i] = ratings.where((r) => r == i).length;
      }

      return {
        'average': average,
        'count': reviews.length,
        'distribution': distribution,
      };
    } on PostgrestException catch (e) {
      throw Exception('Failed to get product rating: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get product rating: $e');
    }
  }

  /// Fetch all reviews (Admin only)
  Future<List<Map<String, dynamic>>> fetchAllReviews({
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('reviews')
          .select('''
            *,
            product:products!reviews_product_id_fkey(id, name, slug, images),
            user:profiles!reviews_user_id_fkey(id, email)
          ''')
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
      throw Exception('Failed to fetch reviews: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }
}
