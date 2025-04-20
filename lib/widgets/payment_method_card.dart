import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/payment_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback? onTap;
  final Map<String, dynamic>? paymentDetails;

  const PaymentMethodCard({
    Key? key,
    required this.method,
    this.isSelected = false,
    this.onTap,
    this.paymentDetails,
  }) : super(key: key);

  IconData _getPaymentIcon() {
    switch (method) {
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.debitCard:
        return Icons.account_balance;
      case PaymentMethod.paypal:
        return Icons.payment;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_wallet;
      case PaymentMethod.upi:
        return Icons.phone_android;
    }
  }

  String _getPaymentTitle() {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.upi:
        return 'UPI';
    }
  }

  String _getMaskedDetails() {
    if (paymentDetails == null) return '';
    
    switch (method) {
      case PaymentMethod.creditCard:
      case PaymentMethod.debitCard:
        final last4 = paymentDetails!['last4'] ?? '****';
        final cardType = paymentDetails!['cardType'] ?? 'Card';
        return '$cardType •••• $last4';
      case PaymentMethod.paypal:
        return paymentDetails!['email'] ?? '';
      case PaymentMethod.bankTransfer:
        return '${paymentDetails!['bankName'] ?? 'Bank'} - ${paymentDetails!['accountNumber'] ?? '****'}';
      case PaymentMethod.upi:
        return paymentDetails!['upiId'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentIcon(),
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPaymentTitle(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (paymentDetails != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _getMaskedDetails(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 