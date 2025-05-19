import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/user/checkout_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = product['price'] ?? '';
    final oldPrice = product['discount'] != null && product['discount'] > 0
        ? (price + (product['discount'] ?? 0))
        : null;
    final discountPercent = product['discount'] != null && product['discount'] > 0 && price > 0
        ? ((product['discount'] / (price + product['discount'])) * 100).round()
        : null;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF21967A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((product['productImage'] ?? '').isNotEmpty)
              Image.network(
                product['productImage'],
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (ctx, e, st) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['productName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('₹${product['price'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF21967A))),
                      if (oldPrice != null) ...[
                        const SizedBox(width: 12),
                        Text('₹$oldPrice', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        if (discountPercent != null) ...[
                          const SizedBox(width: 6),
                          Text('$discountPercent% off', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ]
                      ]
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          (product['artist'] ?? 'A').toString().isNotEmpty ? (product['artist'] ?? 'A').toString()[0].toUpperCase() : 'A',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(product['artist'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21967A),
                          shape: StadiumBorder(),
                          minimumSize: const Size(70, 34),
                        ),
                        child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(product['productDescription'] ?? '', style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 18),
                  const Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _detailItem('Price Type', product['priceType'] ?? '')),
                      Expanded(child: _detailItem('Category', product['category'] ?? '')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _detailItem('Artist', product['artist'] ?? '')),
                      Expanded(child: _detailItem('Extra', product['extra']?['details']?.join(', ') ?? '')),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Additional Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  _detailItem('Delivery Details', product['deliveryDetails']?['location'] ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          product: product
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21967A),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Buy Now', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
