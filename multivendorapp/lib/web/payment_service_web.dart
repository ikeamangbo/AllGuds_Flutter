import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'dart:async';

class PaymentServiceWeb {
  static Future<bool> processWebPayment(
    String email,
    double amount,
    String reference,
  ) async {
    if (!kIsWeb) return false;

    final completer = Completer<bool>();

    js.context.callMethod('PaystackPop.setup', [
      js.JsObject.jsify({
        'key': 'pk_test_6bc057784a33038b8d507c3e7b2b51e4556aa28a',
        'email': email,
        'amount': (amount * 100).toInt(),
        'ref': reference,
        'currency': 'GHS',
        'onClose': () {
          completer.complete(false);
        },
        'callback': (response) {
          completer.complete(response.status == 'success');
        },
      })
    ]);

    return completer.future;
  }
}
