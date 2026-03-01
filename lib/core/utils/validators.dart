/// Form validators for user input
class Validators {
  Validators._();

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  /// Validate password (min 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName es obligatorio'
          : 'Este campo es obligatorio';
    }
    return null;
  }

  /// Validate phone number (Spanish format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    final phoneRegex = RegExp(r'^[6-9]\d{8}$');
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Ingresa un teléfono válido (ej: 612345678)';
    }
    return null;
  }

  /// Validate postal code (Spanish format)
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código postal es obligatorio';
    }
    final postalRegex = RegExp(r'^\d{5}$');
    if (!postalRegex.hasMatch(value)) {
      return 'Ingresa un código postal válido (5 dígitos)';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }
    if (value.length < min) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $min caracteres';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'Este campo'} no puede exceder $max caracteres';
    }
    return null;
  }

  /// Validate numeric input
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }
    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número';
    }
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numericError = numeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    final num = int.parse(value!);
    if (num <= 0) {
      return '${fieldName ?? 'Este campo'} debe ser mayor que 0';
    }
    return null;
  }

  /// Validate price input (accepts "12,50" or "12.50")
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es obligatorio';
    }
    final normalized = value.replaceAll(',', '.');
    if (double.tryParse(normalized) == null) {
      return 'Ingresa un precio válido (ej: 12,50)';
    }
    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida';
    }
    return null;
  }

  /// Validate coupon code (uppercase alphanumeric)
  static String? couponCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa el código del cupón';
    }
    final codeRegex = RegExp(r'^[A-Z0-9]+$');
    if (!codeRegex.hasMatch(value)) {
      return 'El código debe contener solo letras mayúsculas y números';
    }
    return null;
  }
}
