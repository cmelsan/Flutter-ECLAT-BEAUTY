import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review.dart';
import '../providers/review_provider.dart';
import '../../../../core/theme/app_colors.dart';

class ReviewForm extends ConsumerStatefulWidget {
  final String productId;
  final Review? existingReview;
  final VoidCallback? onSuccess;

  const ReviewForm({
    super.key,
    required this.productId,
    this.existingReview,
    this.onSuccess,
  });

  @override
  ConsumerState<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends ConsumerState<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _selectedRating = 5;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _selectedRating = widget.existingReview!.rating;
      _commentController.text = widget.existingReview!.comment ?? '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canReviewAsync = ref.watch(canUserReviewProvider(widget.productId));
    final isEditing = widget.existingReview != null;

    // If editing, show form directly
    if (isEditing) {
      return _buildForm(context, true);
    }

    // If creating, check if user can review
    return canReviewAsync.when(
      data: (canReview) {
        if (!canReview) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Compra este producto para dejar una opinión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildForm(context, canReview);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildForm(BuildContext context, bool canSubmit) {
    final isEditing = widget.existingReview != null;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Editar tu opinión' : 'Escribe tu opinión',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Rating selector
              const Text(
                'Calificación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return IconButton(
                    onPressed: canSubmit
                        ? () => setState(() => _selectedRating = rating)
                        : null,
                    icon: Icon(
                      rating <= _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      size: 36,
                      color: rating <= _selectedRating
                          ? AppColors.primary
                          : Colors.grey[400],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              
              // Comment field
              const Text(
                'Comentario (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                enabled: canSubmit,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Cuéntanos tu experiencia con este producto...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'El comentario no puede exceder 500 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSubmit && !_isSubmitting
                      ? _submitReview
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(isEditing ? 'Actualizar opinión' : 'Publicar opinión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final repo = ref.read(reviewRepositoryProvider);
    final comment = _commentController.text.trim();
    final isEditing = widget.existingReview != null;

    final result = isEditing
        ? await repo.updateReview(
            reviewId: widget.existingReview!.id,
            rating: _selectedRating,
            comment: comment.isEmpty ? null : comment,
          )
        : await repo.addReview(
            productId: widget.productId,
            rating: _selectedRating,
            comment: comment.isEmpty ? null : comment,
          );

    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${failure.message}')),
          );
        }
      },
      (review) {
        // Refresh reviews and rating
        ref.invalidate(productReviewsProvider(widget.productId));
        ref.invalidate(productRatingProvider(widget.productId));
        ref.invalidate(userReviewProvider(widget.productId));
        ref.invalidate(canUserReviewProvider(widget.productId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? '¡Opinión actualizada!'
                    : '¡Gracias por tu opinión!',
              ),
            ),
          );
          
          widget.onSuccess?.call();
        }
      },
    );
  }
}
