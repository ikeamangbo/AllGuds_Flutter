import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static const String _publicKey =
      'pk_test_6bc057784a33038b8d507c3e7b2b51e4556aa28a';

  Future<bool> processPayment({
    required String email,
    required double amount,
    required String reference,
  }) async {
    try {
      final uri = Uri.parse('https://checkout.paystack.com/'
          '?email=${Uri.encodeComponent(email)}'
          '&amount=${(amount * 100).toInt()}'
          '&currency=GHS'
          '&ref=$reference'
          '&key=$_publicKey');

      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_self',
      )) {
        throw 'Could not launch Paystack payment';
      }

      // Note: In a production app, you should implement webhook handling
      // to verify the payment status
      return true;
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }
}
