import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/screens/checkout/add_payment_method_screen.dart';
import 'package:arthub_flutter/config/app_styles.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final List<PaymentModel> paymentMethods;
  final PaymentModel? selectedPayment;

  const PaymentMethodsScreen({
    Key? key,
    required this.paymentMethods,
    this.selectedPayment,
  }) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: widget.paymentMethods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.credit_card_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No payment methods added',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPaymentMethodScreen(),
                        ),
                      );
                      if (result != null && result is PaymentModel) {
                        Navigator.pop(context, result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.paymentMethods.length + 1, // +1 for the "Add New" button
              itemBuilder: (context, index) {
                if (index == widget.paymentMethods.length) {
                  return _buildAddNewButton();
                }

                final payment = widget.paymentMethods[index];
                final isSelected = widget.selectedPayment?.id == payment.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, payment),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getCardTypeIcon(payment.cardType)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '•••• ${payment.cardNumber.substring(payment.cardNumber.length - 4)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(payment.cardholderName),
                          Text('Expires: ${payment.expiryDate}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAddNewButton() {
    return Card(
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPaymentMethodScreen(),
            ),
          );
          if (result != null && result is PaymentModel) {
            Navigator.pop(context, result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline),
              const SizedBox(width: 8),
              Text(
                'Add New Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppStyles.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCardTypeIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'american express':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }
} 