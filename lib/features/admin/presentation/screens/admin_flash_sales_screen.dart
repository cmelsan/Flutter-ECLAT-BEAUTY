import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_utils.dart';
import '../providers/admin_provider.dart';
import '../../../flash_sales/presentation/providers/flash_sales_provider.dart';

class AdminFlashSalesScreen extends ConsumerWidget {
  const AdminFlashSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We reuse adminProductsProvider and filter client-side for simplicity
    // Ideally we'd have a specific endpoint or filter in repository
    final productsAsync = ref.watch(adminProductsProvider);
    final isFlashSaleEnabledAsync = ref.watch(flashSaleEnabledStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas Flash'),
        actions: [
          isFlashSaleEnabledAsync.when(
            data: (isEnabled) => Row(
              children: [
                Text(isEnabled ? 'Activo' : 'Inactivo'),
                Switch(
                  value: isEnabled,
                  activeThumbColor: AppColors.error,
                  onChanged: (val) async {
                    final repo = ref.read(adminRepositoryProvider);
                    await repo.updateSetting('flash_sale_enabled', val);
                  },
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (allProducts) {
          // Filter products that initiate flash sales
          // Or just list all products with toggle
          // Let's list all products but show flash status prominently
          if (allProducts.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              final product = allProducts[index];
              final isFlashSale = product['is_flash_sale'] == true;
              final discount = product['flash_sale_discount'] ?? 0;
              final endTime = product['flash_sale_end_time'] != null
                  ? DateTime.parse(product['flash_sale_end_time'])
                  : null;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: isFlashSale 
                              ? AppColors.error 
                              : AppColors.textDisabled.withValues(alpha: 0.1),
                          child: const Icon(Icons.flash_on, color: Colors.white),
                        ),
                        title: Text(product['name'] ?? ''),
                        subtitle: Text(AppUtils.formatPrice(product['price'] ?? 0)),
                        trailing: Switch(
                          value: isFlashSale,
                          activeThumbColor: AppColors.error,
                          onChanged: (val) {
                            if (val) {
                              _showFlashSaleDialog(context, ref, product);
                            } else {
                              _updateFlashSale(context, ref, product['id'], false, 0, null);
                            }
                          },
                        ),
                      ),
                      if (isFlashSale) ...[
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '-$discount%',
                              style: const TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (endTime != null)
                              Text(
                                'Termina: ${DateFormat('dd/MM HH:mm').format(endTime)}',
                                style: const TextStyle(color: AppColors.textSecondary),
                              )
                            else
                              const Text('Sin fecha fin'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showFlashSaleDialog(
    BuildContext context, 
    WidgetRef ref, 
    Map<String, dynamic> product
  ) {
    final discountCtrl = TextEditingController(text: '20');
    DateTime? selectedDate = DateTime.now().add(const Duration(hours: 24));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Configurar Oferta Flash'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: discountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Porcentaje de descuento (%)',
                  helperText: 'Ej: 20 para 20% dto.',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha fin'),
                subtitle: Text(
                  selectedDate != null 
                    ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!) 
                    : 'Seleccionar fecha',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null && context.mounted) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
                    );
                    if (time != null) {
                      setState(() {
                         selectedDate = DateTime(
                           date.year, date.month, date.day, 
                           time.hour, time.minute
                         );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final discount = double.tryParse(discountCtrl.text) ?? 0;
                if (discount > 0 && selectedDate != null) {
                  _updateFlashSale(
                    context, 
                    ref, 
                    product['id'], 
                    true, 
                    discount, 
                    selectedDate
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateFlashSale(
    BuildContext context, 
    WidgetRef ref, 
    String productId, 
    bool isActive,
    double discount,
    DateTime? endTime,
  ) async {
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.updateProduct(productId, {
      'is_flash_sale': isActive,
      'flash_sale_discount': discount,
      'flash_sale_end_time': endTime?.toIso8601String(),
    });

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}')),
      ),
      (_) => ref.invalidate(adminProductsProvider),
    );
  }
}
