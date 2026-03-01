import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// Service to send transactional emails via the Astro backend email endpoints.
///
/// The Astro project already has all HTML templates and the Brevo integration.
/// Flutter simply POSTs the required data to the Astro `/api/emails/*` endpoints
/// so the email logic stays centralized and the Brevo API key stays server-side.
class EmailService {
  static final String _baseUrl = AppConstants.siteUrl;

  /// Resolve the customer email for an order.
  /// For guests it comes from [guestEmail]; for registered users
  /// we look it up in the [profiles] table using [userId].
  /// Falls back to Supabase auth currentUser email as last resort.
  static Future<String> resolveCustomerEmail(
    SupabaseClient client, {
    String? guestEmail,
    String? userId,
  }) async {
    // 1. Guest email on the order
    if (guestEmail != null && guestEmail.isNotEmpty) return guestEmail;
    // 2. Look up from profiles table
    if (userId != null && userId.isNotEmpty) {
      try {
        final profile = await client
            .from('profiles')
            .select('email')
            .eq('id', userId)
            .maybeSingle();
        final email = profile?['email'] as String?;
        if (email != null && email.isNotEmpty) return email;
      } catch (_) {
        // ignore – fall through
      }
    }
    // 3. Current auth user (works for customer-facing screens)
    final authEmail = client.auth.currentUser?.email;
    if (authEmail != null && authEmail.isNotEmpty) return authEmail;
    return '';
  }

  /// Send order confirmation email.
  /// Usually handled automatically by the Stripe webhook, but can be
  /// called manually for re-sends.
  static Future<bool> sendOrderConfirmation({
    required String email,
    required String customerName,
    required String orderNumber,
    required List<Map<String, dynamic>> items,
    required int totalCents,
  }) async {
    return _post('/api/emails/order-confirmation', {
      'email': email,
      'customerName': customerName,
      'orderNumber': orderNumber,
      'items': items,
      'total': totalCents,
    });
  }

  /// Send shipping notification email.
  /// Called from admin when marking an order as shipped.
  static Future<bool> sendShippingNotification({
    required String email,
    required String customerName,
    String? trackingNumber,
    String? trackingUrl,
  }) async {
    return _post('/api/emails/shipping-notification', {
      'email': email,
      'customerName': customerName,
      'trackingNumber': trackingNumber ?? 'En proceso',
      'trackingUrl': trackingUrl ?? '$_baseUrl/mi-cuenta/pedidos',
    });
  }

  /// Send return-initiated confirmation email.
  /// Called after a customer requests a return.
  static Future<bool> sendReturnInitiated({
    required String orderId,
    required String orderNumber,
    required String customerEmail,
    required String customerName,
    required String returnReason,
  }) async {
    return _post('/api/emails/return-initiated', {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'returnReason': returnReason,
    });
  }

  /// Send return-approved email.
  /// Called from admin when approving a return.
  static Future<bool> sendReturnApproved({
    required String email,
    required String customerName,
    required String returnNumber,
  }) async {
    return _post('/api/emails/return-approved', {
      'email': email,
      'customerName': customerName,
      'returnNumber': returnNumber,
    });
  }

  /// Send cancellation email using the generic send endpoint.
  /// The cancel RPC only changes DB state; this sends the notification.
  static Future<bool> sendCancellationNotification({
    required String email,
    required String customerName,
    required String orderNumber,
    required int totalCents,
  }) async {
    // Use the generic send endpoint with a simple cancellation template
    return _post('/api/emails/send', {
      'to': email,
      'subject': '❌ Pedido cancelado #$orderNumber',
      'htmlContent': _cancellationHtml(customerName, orderNumber, totalCents),
    });
  }

  /// Send delivery confirmation email using the generic send endpoint.
  static Future<bool> sendDeliveryConfirmation({
    required String email,
    required String customerName,
  }) async {
    return _post('/api/emails/send', {
      'to': email,
      'subject': '✅ Tu pedido ha sido entregado - ÉCLAT Beauty',
      'htmlContent': _deliveryHtml(customerName),
    });
  }

  /// Send refund-processed email using the generic send endpoint.
  static Future<bool> sendRefundProcessed({
    required String email,
    required String customerName,
    required String orderNumber,
    required int refundAmountCents,
  }) async {
    return _post('/api/emails/send', {
      'to': email,
      'subject': '✓ Reembolso procesado #$orderNumber',
      'htmlContent': _refundHtml(customerName, orderNumber, refundAmountCents),
    });
  }

  // ── Private helpers ───────────────────────────────────

  static Future<bool> _post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return true;
      }
      // Non-blocking: log but don't throw
      // ignore: avoid_print
      print('[EmailService] $path failed (${response.statusCode}): ${response.body}');
      return false;
    } catch (e) {
      // Non-blocking: email failure should never crash the app
      // ignore: avoid_print
      print('[EmailService] $path error: $e');
      return false;
    }
  }

  // ── Inline HTML templates (for generic /api/emails/send) ──

  static String _cancellationHtml(String name, String orderNumber, int totalCents) {
    final total = (totalCents / 100).toStringAsFixed(2);
    return '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: #111; color: white; padding: 32px 40px; text-align: center; border-radius: 8px 8px 0 0; }
    .header h1 { margin: 0; font-size: 20px; letter-spacing: 4px; font-weight: 700; text-transform: uppercase; }
    .content { background: #f9fafb; padding: 30px; border-radius: 0 0 8px 8px; }
    .order-box { background: white; padding: 16px 20px; border-radius: 6px; margin: 20px 0; border: 1px solid #e5e7eb; text-align: center; }
    .footer { text-align: center; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>ÉCLAT Beauty</h1>
      <p style="margin:6px 0 0;font-size:11px;letter-spacing:2px;color:#aaa;text-transform:uppercase">Pedido cancelado</p>
    </div>
    <div class="content">
      <p>Hola <strong>$name</strong>,</p>
      <p>Te confirmamos que tu pedido ha sido cancelado.</p>
      <div class="order-box">
        <p style="font-size:12px;color:#6b7280;text-transform:uppercase;letter-spacing:1px">Pedido</p>
        <p style="font-weight:700;font-size:18px;color:#111">#$orderNumber</p>
        <p style="font-weight:700;color:#111">€$total</p>
      </div>
      <p style="font-size:13px;color:#6b7280">Si se realizó un cargo, el reembolso se procesará en un plazo de 5-7 días hábiles.</p>
      <p>Gracias por confiar en ÉCLAT Beauty.</p>
    </div>
    <div class="footer">
      <p>&copy; 2026 ÉCLAT Beauty. Todos los derechos reservados.</p>
    </div>
  </div>
</body>
</html>
''';
  }

  static String _deliveryHtml(String name) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #ec4899 0%, #f97316 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
    .content { background: #f9fafb; padding: 30px; border-radius: 0 0 8px 8px; }
    .success-box { background: white; padding: 20px; border-radius: 6px; margin: 20px 0; border-left: 4px solid #10b981; text-align: center; }
    .checkmark { font-size: 48px; color: #10b981; margin: 10px 0; }
    .button { display: inline-block; background: #ec4899; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; font-weight: bold; }
    .footer { text-align: center; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>¡Tu pedido ha sido entregado!</h1>
    </div>
    <div class="content">
      <p>Hola <strong>$name</strong>,</p>
      <div class="success-box">
        <div class="checkmark">✓</div>
        <p><strong>Tu pedido ha llegado correctamente</strong></p>
      </div>
      <p>Esperamos que disfrutes de tu compra. Si tienes alguna pregunta, no dudes en contactarnos.</p>
      <p style="margin-top:30px"><strong>¿Cómo fue tu experiencia?</strong></p>
      <p style="color:#999;font-size:14px">Tu opinión es muy importante para nosotros.</p>
      <p style="color:#999;font-size:12px">¿Preguntas? Contáctanos en support@eclatbeauty.com</p>
    </div>
    <div class="footer">
      <p>&copy; 2026 ÉCLAT Beauty. Todos los derechos reservados.</p>
    </div>
  </div>
</body>
</html>
''';
  }

  static String _refundHtml(String name, String orderNumber, int amountCents) {
    final amount = (amountCents / 100).toStringAsFixed(2);
    return '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
    .content { background: #f9fafb; padding: 30px; border-radius: 0 0 8px 8px; }
    .amount-box { background: white; padding: 20px; border-radius: 6px; margin: 20px 0; text-align: center; border-top: 3px solid #ec4899; border-bottom: 3px solid #ec4899; }
    .amount { font-size: 36px; font-weight: bold; color: #10b981; }
    .info-box { background: #f3f4f6; padding: 15px; border-radius: 6px; margin: 15px 0; border-left: 4px solid #ec4899; }
    .footer { text-align: center; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>✓ Reembolso Procesado</h1>
    </div>
    <div class="content">
      <p>Hola <strong>$name</strong>,</p>
      <p>¡Buenas noticias! Tu reembolso ha sido procesado correctamente.</p>
      <div style="background:#f0fdf4;padding:20px;border-radius:6px;margin:20px 0;border-left:4px solid #10b981">
        <p><strong>✓ Pedido #$orderNumber</strong></p>
        <p>Tu solicitud de devolución ha sido validada y aprobada.</p>
      </div>
      <div class="amount-box">
        <p style="font-size:12px;color:#666;text-transform:uppercase;letter-spacing:1px">Cantidad Reembolsada</p>
        <div class="amount">€ $amount</div>
      </div>
      <div class="info-box">
        <p><strong>📅 Información Importante:</strong></p>
        <p>El reembolso se procesará en tu método de pago original en un plazo de <strong>5 a 7 días hábiles</strong>.</p>
      </div>
      <p>Gracias por tu compra y esperamos vuelvas pronto.</p>
      <p style="color:#999;font-size:12px">¿Preguntas? Contáctanos en support@eclatbeauty.com</p>
    </div>
    <div class="footer">
      <p>&copy; 2026 ÉCLAT Beauty. Todos los derechos reservados.</p>
    </div>
  </div>
</body>
</html>
''';
  }
}
