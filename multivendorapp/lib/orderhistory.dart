import 'dart:async';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Map<String, dynamic> order;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchOrderStatus();
    });
  }

  Future<void> _fetchOrderStatus() async {
    // Simulating API call
    // Replace this with a real API request to fetch updated order status
    Map<String, dynamic> updatedOrder = await _mockApiCall();

    if (mounted && updatedOrder['status'] != order['status']) {
      setState(() {
        order = updatedOrder;
      });
    }
  }

  Future<Map<String, dynamic>> _mockApiCall() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      ...order,
      'status': 'Paid', // Simulate payment update
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order['orderNumber']}'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number: ${order['orderNumber']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Date: ${order['date']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Status: ${order['status']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: order['status'] == 'Paid' ? Colors.green : Colors.red)),
            const SizedBox(height: 10),
            Text('Total: \$${order['total'].toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...order['items'].map<Widget>((item) {
              return ListTile(
                title: Text(item['name']),
                subtitle: Text('Quantity: ${item['quantity']}'),
                trailing: Text('\$${item['price'].toStringAsFixed(2)}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
