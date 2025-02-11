import 'package:flutter/material.dart';
import 'payment.dart'; // Import the PaymentPage

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0, (sum, item) {
      double price = item['price'];
      int quantity = item['quantity'];
      double discount = (quantity >= 10) ? price * 0.2 : (quantity >= 5) ? price * 0.1 : 0.0;
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
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  double price = cartItems[index]['price'];
                  int quantity = cartItems[index]['quantity'];
                  double discount = (quantity >= 10) ? price * 0.2 : (quantity >= 5) ? price * 0.1 : 0.0;
                  double totalPrice = (price * quantity) - discount;

                  return ListTile(
                    title: Text(cartItems[index]['title']),
                    subtitle: Text('Quantity: $quantity\nPrice: \$${price.toStringAsFixed(2)}\nDiscount: \$${discount.toStringAsFixed(2)}\nTotal: \$${totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(totalAmount: totalAmount)),
                );
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}