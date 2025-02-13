import 'package:flutter/material.dart';
import 'services/payment_service_stub.dart';
import 'homepage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _emailController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _handlePaystackPayment(double amount) async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final success = await PaymentService().processPayment(
        email: _emailController.text.trim(),
        amount: amount,
        reference: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (success) {
        // Payment initiated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment page opened successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open payment page')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(0, (sum, item) {
      double price = item['price'];
      int quantity = item['quantity'];
      double discount = (quantity >= 10)
          ? price * 0.2
          : (quantity >= 5)
              ? price * 0.1
              : 0.0;
      return sum + ((price * quantity) - discount);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  double price = widget.cartItems[index]['price'];
                  int quantity = widget.cartItems[index]['quantity'];
                  double discount = (quantity >= 10)
                      ? price * 0.2
                      : (quantity >= 5)
                          ? price * 0.1
                          : 0.0;
                  double totalPrice = (price * quantity) - discount;

                  return ListTile(
                    title: Text(widget.cartItems[index]['title']),
                    subtitle: Text(
                        'Quantity: $quantity\nPrice: \$${price.toStringAsFixed(2)}\nDiscount: \$${discount.toStringAsFixed(2)}\nTotal: \$${totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email for Payment',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _handlePaystackPayment(totalAmount),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Pay with Paystack'),
            ),
          ],
        ),
      ),
    );
  }
}
