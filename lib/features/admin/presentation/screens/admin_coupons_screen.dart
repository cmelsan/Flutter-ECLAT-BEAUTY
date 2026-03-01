import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_provider.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(adminCouponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCouponForm(context, ref),
          ),
        ],
      ),
      body: couponsAsync.when(
        data: (coupons) {
          if (coupons.isEmpty) {
            return const Center(child: Text('No hay cupones creados'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              final isActive = coupon['is_active'] == true;
              final code = coupon['code'] as String;
              final discountType = coupon['discount_type'] as String;
              final discountValue = coupon['discount_value'];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive 
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.textDisabled.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.local_offer, 
                      color: isActive ? AppColors.success : AppColors.textDisabled
                    ),
                  ),
                  title: Text(
                    code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    discountType == 'percentage'
                        ? '$discountValue% descuento'
                        : 'Running out of tokens due to large context windows.',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Editar'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showCouponForm(context, ref, coupon: coupon);
                      } else if (value == 'delete') {
                         _confirmDelete(context, ref, coupon['id']);
                      }
                    },
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

  void _showCouponForm(BuildContext context, WidgetRef ref, {Map<String, dynamic>? coupon}) {
    final codeCtrl = TextEditingController(text: coupon?['code'] ?? '');
    final descCtrl = TextEditingController(text: coupon?['description'] ?? '');
    final valueCtrl = TextEditingController(text: coupon?['discount_value']?.toString() ?? '0');
    final minPurchaseCtrl = TextEditingController(text: coupon?['min_purchase_amount']?.toString() ?? '0');
    
    String discountType = coupon?['discount_type'] ?? 'percentage';
    bool isActive = coupon?['is_active'] ?? true;
    DateTime? validUntil = coupon?['valid_until'] != null 
        ? DateTime.parse(coupon!['valid_until']) 
        : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(coupon == null ? 'Nuevo Cupón' : 'Editar Cupón'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: 'Código'),
                  textCapitalization: TextCapitalization.characters,
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: discountType,
                        items: const [
                          DropdownMenuItem(value: 'percentage', child: Text('Porcentaje')),
                          DropdownMenuItem(value: 'fixed', child: Text('Fijo')),
                        ],
                        onChanged: (val) => setState(() => discountType = val!),
                        decoration: const InputDecoration(labelText: 'Tipo'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: valueCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Valor'),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: minPurchaseCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Compra mínima (opcional)'),
                ),
                 SwitchListTile(
                  title: const Text('Activo'),
                  value: isActive,
                  onChanged: (val) => setState(() => isActive = val),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text('Válido hasta'),
                  subtitle: Text(validUntil != null 
                      ? DateFormat('dd/MM/yyyy').format(validUntil!)
                      : 'Sin fecha límite'),
                  trailing: const Icon(Icons.calendar_today),
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: validUntil ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => validUntil = date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(adminRepositoryProvider);
                final data = {
                  'code': codeCtrl.text.trim().toUpperCase(),
                  'description': descCtrl.text.trim(),
                  'discount_type': discountType,
                  'discount_value': double.tryParse(valueCtrl.text) ?? 0,
                  'min_purchase_amount': double.tryParse(minPurchaseCtrl.text) ?? 0,
                  'is_active': isActive,
                  'valid_until': validUntil?.toIso8601String(),
                };

                if (data['code'] == '') {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('El código es obligatorio')),
                   );
                   return;
                }

                Navigator.pop(ctx); // Close dialog first

                if (coupon == null) {
                  // Create
                  final result = await repo.createCoupon(data);
                  result.fold(
                    (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
                    (_) => ref.invalidate(adminCouponsProvider),
                  );
                } else {
                  // Update
                  final result = await repo.updateCoupon(coupon['id'], data);
                  result.fold(
                    (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
                    (_) => ref.invalidate(adminCouponsProvider),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar cupón?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(adminRepositoryProvider);
              await repo.deleteCoupon(id);
              ref.invalidate(adminCouponsProvider);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
