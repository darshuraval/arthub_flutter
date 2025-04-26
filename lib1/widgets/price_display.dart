import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final double originalPrice;
  final double? discountedPrice;
  
  const PriceDisplay({
    Key? key,
    required this.originalPrice,
    this.discountedPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\$${discountedPrice?.toStringAsFixed(0) ?? originalPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (discountedPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            '\$${originalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
} 