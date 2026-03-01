import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/address.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddressStep extends ConsumerStatefulWidget {
  final Address? initialAddress;
  final Function(Address, String?) onContinue;
  final VoidCallback? onBack;
  final bool showGuestFields;

  const AddressStep({
    super.key,
    this.initialAddress,
    required this.onContinue,
    this.onBack,
    this.showGuestFields = false,
  });

  @override
  ConsumerState<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends ConsumerState<AddressStep> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late final TextEditingController _emailCtrl;
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _addressLine2Ctrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _phoneCtrl;

  String _selectedCountry = 'España';
  bool _saveAsDefault = false;

  // Country options
  final List<String> _countries = [
    'España',
    'Portugal',
    'Francia',
    'Italia',
    'Alemania',
    'Reino Unido',
    'Países Bajos',
    'Bélgica',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _emailCtrl = TextEditingController();
    _fullNameCtrl = TextEditingController();
    _streetCtrl = TextEditingController();
    _addressLine2Ctrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _postalCodeCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();

    // Set initial values if address provided
    if (widget.initialAddress != null) {
      _fullNameCtrl.text = widget.initialAddress!.fullName;
      _streetCtrl.text = widget.initialAddress!.street;
      _addressLine2Ctrl.text = widget.initialAddress!.addressLine2 ?? '';
      _cityCtrl.text = widget.initialAddress!.city;
      _postalCodeCtrl.text = widget.initialAddress!.postalCode;
      _phoneCtrl.text = widget.initialAddress!.phone;
      _selectedCountry = widget.initialAddress!.country;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _fullNameCtrl.dispose();
    _streetCtrl.dispose();
    _addressLine2Ctrl.dispose();
    _cityCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final showGuestFields = widget.showGuestFields && !auth.isAuthenticated;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header
            Text(
              'Dirección de envío',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa los datos de envío para continuar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Guest email field (if not authenticated)
            if (showGuestFields) ...[
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'tu@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
            ],

            // Full name
            TextFormField(
              controller: _fullNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre completo *',
                hintText: 'Juan Pérez',
                prefixIcon: Icon(Icons.person_outlined),
              ),
              validator: Validators.required,
            ),
            const SizedBox(height: 16),

            // Street address
            TextFormField(
              controller: _streetCtrl,
              decoration: const InputDecoration(
                labelText: 'Dirección *',
                hintText: 'Calle Principal, 123',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: Validators.required,
            ),
            const SizedBox(height: 16),

            // Address line 2 (optional)
            TextFormField(
              controller: _addressLine2Ctrl,
              decoration: const InputDecoration(
                labelText: 'Piso, escalera, puerta (opcional)',
                hintText: '2º B',
                prefixIcon: Icon(Icons.apartment_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // City and postal code row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad *',
                      hintText: 'Madrid',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    validator: Validators.required,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _postalCodeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CP *',
                      hintText: '28001',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Requerido';
                      }
                      if (value!.length < 4) {
                        return 'CP inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Country dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCountry,
              decoration: const InputDecoration(
                labelText: 'País *',
                prefixIcon: Icon(Icons.public_outlined),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCountry = value;
                  });
                }
              },
              validator: Validators.required,
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono *',
                hintText: '+34 123 456 789',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'El teléfono es requerido';
                }
                if (value!.length < 9) {
                  return 'Teléfono inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save as default checkbox (for authenticated users)
            if (auth.isAuthenticated)
              CheckboxListTile(
                value: _saveAsDefault,
                onChanged: (value) {
                  setState(() {
                    _saveAsDefault = value ?? false;
                  });
                },
                title: const Text('Guardar como dirección predeterminada'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                if (widget.onBack != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('ATRÁS'),
                    ),
                  ),
                if (widget.onBack != null) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('CONTINUAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final address = Address(
      fullName: _fullNameCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      postalCode: _postalCodeCtrl.text.trim(),
      country: _selectedCountry,
      phone: _phoneCtrl.text.trim(),
      addressLine2: _addressLine2Ctrl.text.trim().isEmpty 
          ? null 
          : _addressLine2Ctrl.text.trim(),
    );

    final guestEmail = widget.showGuestFields ? _emailCtrl.text.trim() : null;
    widget.onContinue(address, guestEmail);
  }
}
