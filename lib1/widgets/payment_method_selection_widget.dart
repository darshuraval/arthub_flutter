import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import 'package:arthub_flutter/screens/checkout/add_payment_method_screen.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  final bool showAddButton;

  const PaymentMethodSelectionWidget({
    Key? key,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, provider, child) {
        final paymentMethods = provider.paymentMethods;
        final selectedPayment = provider.selectedPaymentMethod;

        if (paymentMethods.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAddButton)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextButton.icon(
                  onPressed: () => _addPaymentMethod(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment Method'),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final payment = paymentMethods[index];
                return _buildPaymentCard(context, payment, selectedPayment);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.credit_card_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No payment methods found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addPaymentMethod(context),
            child: const Text('Add Payment Method'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    PaymentModel payment,
    PaymentModel? selectedPayment,
  ) {
    final isSelected = selectedPayment?.id == payment.id;
    final provider = Provider.of<CheckoutProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => provider.selectPaymentMethod(payment),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) => provider.selectPaymentMethod(payment),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getCardTypeIcon(payment.cardType)),
                        const SizedBox(width: 8),
                        Text(
                          '•••• ${payment.lastFourDigits}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Expires: ${payment.expiryDate}'),
                    if (payment.cardholderName.isNotEmpty)
                      Text('Name: ${payment.cardholderName}'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editPaymentMethod(context, payment),
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
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Future<void> _addPaymentMethod(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPaymentMethodScreen(),
      ),
    );

    if (result != null && result is PaymentModel) {
      final provider = Provider.of<CheckoutProvider>(context, listen: false);
      await provider.addPaymentMethod(result);
    }
  }

  Future<void> _editPaymentMethod(BuildContext context, PaymentModel payment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPaymentMethodScreen(payment: payment),
      ),
    );

    if (result != null && result is PaymentModel) {
      final provider = Provider.of<CheckoutProvider>(context, listen: false);
      await provider.updatePaymentMethod(result);
    }
  }
} 