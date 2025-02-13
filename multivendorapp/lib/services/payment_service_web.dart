// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/foundation.dart';

class PaymentServiceWeb {
  static const String _publicKey =
      'pk_test_6bc057784a33038b8d507c3e7b2b51e4556aa28a';

  static Future<bool> processPayment({
    required String email,
    required double amount,
    required String reference,
  }) async {
    if (!kIsWeb) return false;

    final completer = Completer<bool>();

    // Create a script element for Paystack
    final script = html.ScriptElement()
      ..src = 'https://js.paystack.co/v1/inline.js'
      ..type = 'text/javascript';

    html.document.head!.append(script);

    script.onLoad.listen((_) {
      // Initialize Paystack payment
      final options = {
        'key': _publicKey,
        'email': email,
        'amount': (amount * 100).toInt(),
        'ref': reference,
        'currency': 'GHS',
        'onClose': () {
          completer.complete(false);
        },
        'callback': (response) {
          completer.complete(response['status'] == 'success');
        },
      };

      // Call Paystack
      html.window.postMessage({
        'type': 'paystack-payment',
        'options': options,
      }, '*');
    });

    return completer.future;
  }
}
