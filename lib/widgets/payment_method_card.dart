import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/payment_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentModel method;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentMethodCard({
    Key? key,
    required this.method,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Card Type Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _buildCardTypeIcon(),
                ),
              ),
              const SizedBox(width: 16),
              // Card Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.cardType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '**** **** **** ${method.cardNumber.substring(method.cardNumber.length - 4)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expires ${method.expiryDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Default Badge
              if (method.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTypeIcon() {
    IconData iconData;
    switch (method.cardType.toLowerCase()) {
      case 'visa':
        iconData = Icons.credit_card;
        break;
      case 'mastercard':
        iconData = Icons.credit_card;
        break;
      case 'american express':
        iconData = Icons.credit_card;
        break;
      default:
        iconData = Icons.credit_card;
    }
    return Icon(
      iconData,
      size: 24,
      color: Colors.grey[600],
    );
  }
} 