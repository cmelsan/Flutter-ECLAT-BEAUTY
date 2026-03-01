import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/supabase_storage_service.dart';
import '../providers/admin_provider.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductForm(context, ref),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductAdminCard(product: product);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showProductForm(BuildContext context, WidgetRef ref, {Map<String, dynamic>? product}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProductFormScreen(product: product),
      ),
    );
  }
}

class _ProductAdminCard extends ConsumerWidget {
  final Map<String, dynamic> product;

  const _ProductAdminCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = product['name'] as String? ?? '';
    final price = product['price'] as int? ?? 0;
    final stock = product['stock'] as int? ?? 0;
    final images = product['images'] as List<dynamic>?;
    final primaryImage = (images != null && images.isNotEmpty) ? images[0] as String : null;
    final id = product['id'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: primaryImage != null
                ? Image.network(
                    AppUtils.thumbnailUrl(primaryImage),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  )
                : Container(
                    color: AppColors.surface,
                    child: const Icon(Icons.image_outlined),
                  ),
          ),
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              AppUtils.formatPrice(price),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: stock > 0
                    ? AppColors.inStock.withAlpha(30)
                    : AppColors.outOfStock.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Stock: $stock',
                style: TextStyle(
                  fontSize: 11,
                  color: stock > 0
                      ? AppColors.inStock
                      : AppColors.outOfStock,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            if (action == 'edit') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _ProductFormScreen(product: product),
                ),
              );
            } else if (action == 'delete') {
              _confirmDelete(context, ref, id, name);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String productId,
    String productName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Estás seguro de eliminar "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final repo = ref.read(adminRepositoryProvider);
        await repo.deleteProduct(productId);
        ref.invalidate(adminProductsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

class _ProductFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? product;

  const _ProductFormScreen({this.product});

  @override
  ConsumerState<_ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<_ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _slugController;
  String? _selectedCategoryId;
  String? _selectedBrandId;
  bool _isLoading = false;
  List<String> _imageUrls = [];
  bool _isUploadingImage = false;
  final SupabaseStorageService _storageService = SupabaseStorageService();

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?['name'] as String? ?? '');
    _descriptionController =
        TextEditingController(text: p?['description'] as String? ?? '');
    _priceController = TextEditingController(
      text: p != null
          ? ((p['price'] as int? ?? 0) / 100).toStringAsFixed(2)
          : '',
    );
    _stockController = TextEditingController(
      text: p?['stock']?.toString() ?? '',
    );
    _slugController = TextEditingController(text: p?['slug'] as String? ?? '');
    _selectedCategoryId = p?['category_id'] as String?;
    _selectedBrandId = p?['brand_id'] as String?;
    _imageUrls = List<String>.from(p?['images'] as List<dynamic>? ?? []);

    _nameController.addListener(() {
      if (!_isEditing && _slugController.text.isEmpty) {
        _slugController.text = AppUtils.slugify(_nameController.text);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _slugController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre *'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Nombre requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _slugController,
              decoration: const InputDecoration(labelText: 'Slug *'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Slug requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio (€) *',
                      prefixText: '€ ',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (double.tryParse(v) == null) return 'Precio inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration:
                        const InputDecoration(labelText: 'Stock *'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (int.tryParse(v) == null) return 'Número inválido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Images Section ───────────────────
            Text(
              'Imágenes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._imageUrls.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final url = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          AppUtils.thumbnailUrl(url),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 80,
                            height: 80,
                            color: AppColors.backgroundSecondary,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _imageUrls.removeAt(idx));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                // Add image button
                GestureDetector(
                  onTap: _isUploadingImage ? null : _showImageSourceDialog,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isUploadingImage
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  color: AppColors.textTertiary),
                              Text('Añadir',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  )),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isEditing ? 'Guardar cambios' : 'Crear producto'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la galería'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    setState(() => _isUploadingImage = true);
    
    final result = await _storageService.pickAndUploadImage(
      source: source,
      folder: 'products',
    );
    
    if (!mounted) return;
    setState(() => _isUploadingImage = false);
    
    result.fold(
      (failure) {
        if (failure is! CancellationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toString())),
          );
        }
      },
      (url) {
        setState(() => _imageUrls.add(url));
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final priceInCents =
          (double.parse(_priceController.text) * 100).round();

      final data = {
        'name': _nameController.text.trim(),
        'slug': _slugController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': priceInCents,
        'stock': int.parse(_stockController.text),
        'images': _imageUrls,
        if (_selectedCategoryId != null) 'category_id': _selectedCategoryId,
        if (_selectedBrandId != null) 'brand_id': _selectedBrandId,
      };

      final repo = ref.read(adminRepositoryProvider);

      if (_isEditing) {
        await repo.updateProduct(widget.product!['id'] as String, data);
      } else {
        await repo.createProduct(data);
      }

      ref.invalidate(adminProductsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Producto actualizado' : 'Producto creado',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
