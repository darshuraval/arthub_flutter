import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/models/cart_model.dart';
import 'package:arthub_flutter/models/payment_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CartModel cart;
  final PaymentModel payment;
  final String orderNumber;

  const OrderConfirmationScreen({
    Key? key,
    required this.cart,
    required this.payment,
    required this.orderNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order Confirmation Text
            const Center(
              child: Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Order #$orderNumber',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Order Details
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                    _buildDetailRow('Shipping', '\$${cart.shipping.toStringAsFixed(2)}'),
                    _buildDetailRow('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Total',
                      '\$${cart.total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Details
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Card Type', payment.cardType),
                    _buildDetailRow(
                      'Card Number',
                      '**** **** **** ${payment.cardNumber.substring(payment.cardNumber.length - 4)}',
                    ),
                    _buildDetailRow('Expiry Date', payment.expiryDate),
                    _buildDetailRow('Cardholder', payment.cardholderName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppStyles.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
} 