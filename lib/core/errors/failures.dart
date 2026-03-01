import 'package:flutter/material.dart';

/// Failure hierarchy for clean error handling
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class StockFailure extends Failure {
  final String productName;
  final int available;
  const StockFailure({
    required this.productName,
    required this.available,
  }) : super('$productName: solo $available disponibles');
}

class CouponFailure extends Failure {
  const CouponFailure(super.message);
}

class PaymentFailure extends Failure {
  const PaymentFailure(super.message);
}

/// Maps Supabase/Postgres errors to user-friendly messages
class ErrorMapper {
  ErrorMapper._();

  static String mapSupabaseError(dynamic error) {
    final msg = error.toString().toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return 'Email o contraseña incorrectos';
    }
    if (msg.contains('user already registered')) {
      return 'Este email ya está registrado';
    }
    if (msg.contains('email not confirmed')) {
      return 'Confirma tu email antes de iniciar sesión';
    }
    if (msg.contains('jwt expired') || msg.contains('token expired')) {
      return 'Tu sesión ha expirado, inicia sesión de nuevo';
    }
    if (msg.contains('insufficient stock') || msg.contains('stock')) {
      return 'Stock insuficiente para uno o más productos';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Error de conexión. Verifica tu internet.';
    }

    return 'Ha ocurrido un error. Inténtalo de nuevo.';
  }
}

/// Extension to show snackbar errors easily
extension FailureX on BuildContext {
  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
