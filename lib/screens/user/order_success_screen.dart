import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final String imageUrl;
  final double price;
  final String address;
  final String mobile;

  const OrderSuccessScreen({
    Key? key,
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.address,
    required this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Thanks for Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(productName),
                subtitle: Text('₹${price.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 24),
            Text('Order ID - $orderId', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Delivery Address'),
              subtitle: Text(address),
              trailing: Text('Mobile: $mobile'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
