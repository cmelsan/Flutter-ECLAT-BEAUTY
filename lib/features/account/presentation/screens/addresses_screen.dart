import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(userAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressForm(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 64, color: AppColors.textTertiary),
                  SizedBox(height: 16),
                  Text('No tienes direcciones guardadas'),
                  SizedBox(height: 8),
                  Text(
                    'Añade una dirección para agilizar tus compras',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (ctx, i) => _AddressCard(
              address: addresses[i],
              onEdit: () => _showAddressForm(context, address: addresses[i]),
              onDelete: () => _deleteAddress(addresses[i].id),
              onSetDefault: () => _setAsDefault(addresses[i]),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _deleteAddress(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: const Text('¿Estás seguro de que quieres eliminar esta dirección?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.deleteAddress(id);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {
        ref.invalidate(userAddressesProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dirección eliminada')),
          );
        }
      },
    );
  }

  Future<void> _setAsDefault(UserAddress address) async {
    final updated = UserAddress(
      id: address.id,
      userId: address.userId,
      addressData: address.addressData,
      addressType: address.addressType,
      isDefault: true,
      createdAt: address.createdAt,
    );

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.saveAddress(updated);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {
        ref.invalidate(userAddressesProvider);
      },
    );
  }

  void _showAddressForm(BuildContext context, {UserAddress? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _AddressFormSheet(
        address: address,
        onSave: (saved) {
          ref.invalidate(userAddressesProvider);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final UserAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final data = address.addressData;
    final name = data['name'] as String? ?? '';
    final street = data['street'] as String? ?? '';
    final city = data['city'] as String? ?? '';
    final province = data['province'] as String? ?? '';
    final postalCode = data['postal_code'] as String? ?? '';
    final phone = data['phone'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: address.isDefault
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  address.addressType == 'billing'
                      ? Icons.receipt_outlined
                      : Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  address.addressType == 'billing'
                      ? 'Facturación'
                      : 'Envío',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Predeterminada',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                    if (val == 'default') onSetDefault();
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
                    if (!address.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 18),
                            SizedBox(width: 8),
                            Text('Predeterminada'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Eliminar',
                              style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address details
            if (name.isNotEmpty)
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (street.isNotEmpty) Text(street),
            Text('$postalCode $city, $province'),
            if (phone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  phone,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends ConsumerStatefulWidget {
  final UserAddress? address;
  final ValueChanged<UserAddress> onSave;

  const _AddressFormSheet({this.address, required this.onSave});

  @override
  ConsumerState<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends ConsumerState<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _provinceCtrl;
  late TextEditingController _postalCodeCtrl;
  late TextEditingController _phoneCtrl;
  String _addressType = 'shipping';
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.address?.addressData ?? {};
    _nameCtrl = TextEditingController(text: data['name'] as String? ?? '');
    _streetCtrl = TextEditingController(text: data['street'] as String? ?? '');
    _cityCtrl = TextEditingController(text: data['city'] as String? ?? '');
    _provinceCtrl =
        TextEditingController(text: data['province'] as String? ?? '');
    _postalCodeCtrl =
        TextEditingController(text: data['postal_code'] as String? ?? '');
    _phoneCtrl = TextEditingController(text: data['phone'] as String? ?? '');
    _addressType = widget.address?.addressType ?? 'shipping';
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                widget.address == null
                    ? 'Nueva Dirección'
                    : 'Editar Dirección',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Address type toggle
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'shipping',
                    label: Text('Envío'),
                    icon: Icon(Icons.local_shipping_outlined),
                  ),
                  ButtonSegment(
                    value: 'billing',
                    label: Text('Facturación'),
                    icon: Icon(Icons.receipt_outlined),
                  ),
                ],
                selected: {_addressType},
                onSelectionChanged: (val) => setState(() {
                  _addressType = val.first;
                }),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _streetCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dirección (calle, número, piso...)',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _postalCodeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'C.P.',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obligatorio' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obligatorio' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _provinceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Provincia',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                title: const Text('Dirección predeterminada'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Guardar'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final addressData = {
      'name': _nameCtrl.text.trim(),
      'street': _streetCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'province': _provinceCtrl.text.trim(),
      'postal_code': _postalCodeCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
    };

    final address = UserAddress(
      id: widget.address?.id ?? '',
      userId: widget.address?.userId ?? '',
      addressData: addressData,
      addressType: _addressType,
      isDefault: _isDefault,
    );

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.saveAddress(address);

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección guardada')),
        );
        widget.onSave(saved);
      },
    );
  }
}
