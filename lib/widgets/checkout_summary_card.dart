import 'package:flutter/material.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final String currencySymbol;

  const CheckoutSummaryCard({
    Key? key,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    this.discount = 0.0,
    this.currencySymbol = '\$',
  }) : super(key: key);

  double get total => subtotal + tax + shippingCost - discount;

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '${isDiscount ? "-" : ""}$currencySymbol${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : (isTotal ? Colors.black : Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal', subtotal),
          _buildPriceRow('Tax', tax),
          _buildPriceRow('Shipping', shippingCost),
          if (discount > 0) _buildPriceRow('Discount', discount, isDiscount: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }
} 