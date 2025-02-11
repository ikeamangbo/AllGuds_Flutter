import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Method App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentMethodPage(),
    );
  }
}

// 📌 Payment Details Page
class PaymentDetailsPage extends StatelessWidget {
  final String paymentMethod;

  const PaymentDetailsPage({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$paymentMethod Details'),
        backgroundColor: const Color(0xFF029fae),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Enter $paymentMethod Details'),
            const SizedBox(height: 20),

            // Show relevant input fields based on the selected payment method
            if (paymentMethod == 'Credit Card') _buildCreditCardFields(),
            if (paymentMethod == 'PayPal') _buildPayPalFields(),
            if (paymentMethod == 'Google Pay') _buildGooglePayFields(),
            if (paymentMethod == 'Apple Pay') _buildApplePayFields(),

            const SizedBox(height: 30),

            // Confirm Payment Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle payment processing
                },
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Confirm Payment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF029fae),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Apple Pay Fields
  Widget _buildApplePayFields() {
    return Column(
      children: [
        _buildTextField(label: "Apple Pay ID", icon: Icons.phone_iphone),
      ],
    );
  }

  // Credit Card Fields
  Widget _buildCreditCardFields() {
    return Column(
      children: [
        _buildTextField(label: "Card Number", icon: Icons.credit_card),
        const SizedBox(height: 15),
        _buildTextField(label: "Expiry Date", icon: Icons.calendar_today),
        const SizedBox(height: 15),
        _buildTextField(label: "CVV", icon: Icons.lock, obscureText: true),
      ],
    );
  }

  // Google Pay Fields
  Widget _buildGooglePayFields() {
    return Column(
      children: [
        _buildTextField(label: "Google Pay ID", icon: Icons.phone),
      ],
    );
  }

  // PayPal Fields
  Widget _buildPayPalFields() {
    return Column(
      children: [
        _buildTextField(label: "PayPal Email", icon: Icons.email),
      ],
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // General Text Field
  Widget _buildTextField(
      {required String label,
      required IconData icon,
      bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

// 📌 Payment Method Selection Page
class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        backgroundColor: const Color(0xFF029fae),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Select Payment Method'),
          _buildPaymentMethodTile(context, 'Credit Card', Icons.credit_card),
          _buildPaymentMethodTile(context, 'PayPal', Icons.payment),
          _buildPaymentMethodTile(context, 'Google Pay', Icons.payments),
          _buildPaymentMethodTile(context, 'Apple Pay', Icons.apple),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(
      BuildContext context, String method, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(method),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentDetailsPage(paymentMethod: method),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
