import 'dart:convert';
import '../../../cart/domain/entities/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

/// Service to interact with the Stripe backend API and PaymentSheet
class StripeService {
  final String _baseUrl;

  StripeService({String? baseUrl})
      : _baseUrl = baseUrl ?? AppConstants.siteUrl;

  /// Initialize Stripe Payment Sheet using Astro Mobile API
  Future<Either<Failure, void>> initPaymentSheet({
    required String orderId,
    required List<CartItem> items,
    required String email,
    int discountAmount = 0, // Changed to int (cents)
    String? couponId,
  }) async {
    try {
      // 1. Call Astro Mobile Payment API
      final response = await http.post(
        Uri.parse('$_baseUrl/api/mobile-payment'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderId': orderId,
          'items': items.map((e) => {
             // Structure compatible with Astro API
             'productId': e.productId,
             'quantity': e.quantity, 
          }).toList(),
          'email': email,
          'discountAmount': discountAmount, 
          'couponId': couponId,
        }),
      );
      
      if (response.statusCode != 200) {
         debugPrint('Error from server: ${response.statusCode} - ${response.body}');
         try {
           final error = jsonDecode(response.body);
           return Left(ServerFailure(error['error'] ?? 'Server error: ${response.statusCode}'));
         } catch (_) {
           return Left(ServerFailure('Server error: ${response.statusCode}'));
         }
      }

      final data = jsonDecode(response.body);
      debugPrint('Response from server: $data');

      final clientSecret = data['paymentIntent'] as String?;
      final ephemeralKey = data['ephemeralKey'] as String?;
      final customerId = data['customer'] as String?; 
      
      if (clientSecret == null || ephemeralKey == null || customerId == null) {
        return const Left(ServerFailure('Invalid response from payment server'));
      }

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Eclat Beauty',
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          style: ThemeMode.light,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error initializing payment: $e'));
    }
  }

  /// Present the Payment Sheet to the user
  Future<Either<Failure, void>> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return const Right(null);
    } catch (e) {
      if (e is StripeException) {
        return Left(PaymentFailure('Pago cancelado o fallido: ${e.error.localizedMessage}'));
      }
      return Left(PaymentFailure('Error al procesar el pago: $e'));
    }
  }

  /// Create a Stripe Checkout Session via the backend API
  /// Returns the checkout URL to redirect the user to
  Future<Either<Failure, String>> createCheckoutSession({
    required List<Map<String, dynamic>> items,
    required String orderId,
    required String email,
    int discountAmount = 0,
    int? finalTotal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/create-checkout-session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'items': items,
          'orderId': orderId,
          'email': email,
          'discountAmount': discountAmount,
          if (finalTotal != null) 'finalTotal': finalTotal,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['url'] as String?;
        if (url != null) {
          return Right(url);
        }
        return const Left(ServerFailure('No se recibió URL de pago'));
      } else {
        final data = jsonDecode(response.body);
        return Left(ServerFailure(
          data['error'] as String? ?? 'Error al crear sesión de pago',
        ));
      }
    } catch (e) {
      return Left(ServerFailure('Error de conexión: $e'));
    }
  }

  /// Verify a checkout session status (optional, for extra safety)
  Future<Either<Failure, bool>> verifySession(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/checkout/verify?session_id=$sessionId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(data['paid'] == true);
      }
      return const Right(false);
    } catch (e) {
      return const Right(false);
    }
  }
}
