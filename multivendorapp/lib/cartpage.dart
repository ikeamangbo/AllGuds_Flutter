import 'package:flutter/material.dart';
import 'checkout.dart';

const Color primaryColor = Color(0xFF029fae);

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: primaryColor, // Use the primary color
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      double price = widget.cartItems[index]['price'];
                      int quantity = widget.cartItems[index]['quantity'];
                      double discount = _calculateDiscount(price, quantity);
                      double totalPrice = _calculateTotalPrice(price, quantity);

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset(
                            widget.cartItems[index]['imagePath'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(widget.cartItems[index]['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (widget.cartItems[index]
                                                ['quantity'] >
                                            1) {
                                          widget.cartItems[index]['quantity']--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                      'Quantity: ${widget.cartItems[index]['quantity']}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        widget.cartItems[index]['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Text('Price: \$${price.toStringAsFixed(2)}'),
                              Text(
                                  'Discount: \$${discount.toStringAsFixed(2)}'),
                              Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                widget.cartItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CheckoutPage(cartItems: widget.cartItems)),
                      );
                    },
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
              ],
            ),
    );
  }

  double _calculateDiscount(double price, int quantity) {
    if (quantity >= 10) {
      return price * 0.2; // 20% discount for 10 or more items
    } else if (quantity >= 5) {
      return price * 0.1; // 10% discount for 5 or more items
    } else {
      return 0.0; // No discount for less than 5 items
    }
  }

  double _calculateTotalPrice(double price, int quantity) {
    double discount = _calculateDiscount(price, quantity);
    return (price * quantity) - discount;
  }
}
