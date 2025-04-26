import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/cart_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final CartModel cart;
  final bool showItems;
  final VoidCallback? onViewItems;

  const OrderSummaryCard({
    Key? key,
    required this.cart,
    this.showItems = true,
    this.onViewItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (showItems) ...[
              ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.images[0],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Qty: ${item.quantity}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  )),
              const Divider(),
            ],
            _buildSummaryRow(
              context,
              'Subtotal',
              '\$${cart.subtotal.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              context,
              'Shipping',
              '\$${cart.shipping.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              context,
              'Tax',
              '\$${cart.tax.toStringAsFixed(2)}',
            ),
            const Divider(),
            _buildSummaryRow(
              context,
              'Total',
              '\$${cart.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            if (!showItems && onViewItems != null) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: onViewItems,
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Items'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Theme.of(context).primaryColor : null,
                ),
          ),
        ],
      ),
    );
  }
} 