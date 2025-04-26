import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/config/app_styles.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentModel? payment;

  const AddPaymentMethodScreen({
    Key? key,
    this.payment,
  }) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;
  late TextEditingController _nameController;
  bool _isDefault = false;
  String _selectedCardType = 'Visa';

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(text: widget.payment?.cardNumber);
    _expiryController = TextEditingController(text: widget.payment?.expiryDate);
    _cvvController = TextEditingController(text: widget.payment?.cvv);
    _nameController = TextEditingController(text: widget.payment?.cardholderName);
    _isDefault = widget.payment?.isDefault ?? false;
    if (widget.payment != null) {
      _selectedCardType = widget.payment!.cardType;
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.payment != null ? 'Edit Payment Method' : 'Add Payment Method',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedCardType,
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Visa', 'Mastercard', 'American Express']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCardType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                    return 'Please enter valid expiry date (MM/YY)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  if (value.length < 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Set as default payment method'),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePaymentMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.payment != null ? 'Update Card' : 'Add Card',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      final payment = PaymentModel(
        id: widget.payment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        cardType: _selectedCardType,
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryController.text,
        cvv: _cvvController.text,
        cardholderName: _nameController.text,
        isDefault: _isDefault,
        createdAt: widget.payment?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      Navigator.pop(context, payment);
    }
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('/', '');
    if (text.length >= 2) {
      return TextEditingValue(
        text: '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
    return newValue;
  }
} 