import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/screens/checkout/add_payment_method_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentModel> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load payment methods from storage/backend
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    // TODO: Implement loading payment methods from storage/backend
    setState(() {
      _paymentMethods = [];
    });
  }

  void _addPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPaymentMethodScreen(),
      ),
    );

    if (result != null && result is PaymentModel) {
      setState(() {
        _paymentMethods.add(result);
      });
    }
  }

  void _editPaymentMethod(PaymentModel paymentMethod) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPaymentMethodScreen(
          paymentMethod: paymentMethod,
        ),
      ),
    );

    if (result != null && result is PaymentModel) {
      setState(() {
        final index = _paymentMethods.indexWhere((pm) => pm.id == result.id);
        if (index != -1) {
          _paymentMethods[index] = result;
        }
      });
    }
  }

  void _deletePaymentMethod(PaymentModel paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeWhere((pm) => pm.id == paymentMethod.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: _paymentMethods.isEmpty
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
                    onPressed: _addPaymentMethod,
                    child: const Text('Add Payment Method'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final paymentMethod = _paymentMethods[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Icon(
                      _getCardTypeIcon(paymentMethod.cardType),
                      size: 32,
                    ),
                    title: Text(
                      '•••• ${paymentMethod.cardNumber.substring(paymentMethod.cardNumber.length - 4)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Expires ${paymentMethod.expiryDate}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (paymentMethod.isDefault)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text('Default'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editPaymentMethod(paymentMethod),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePaymentMethod(paymentMethod),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPaymentMethod,
        child: const Icon(Icons.add),
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
} 