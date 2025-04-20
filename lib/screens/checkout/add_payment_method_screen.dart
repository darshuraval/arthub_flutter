import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arthub_flutter/models/payment_model.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentModel? paymentMethod;

  const AddPaymentMethodScreen({
    Key? key,
    this.paymentMethod,
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
    _cardNumberController = TextEditingController(text: widget.paymentMethod?.cardNumber);
    _expiryController = TextEditingController(text: widget.paymentMethod?.expiryDate);
    _cvvController = TextEditingController(text: widget.paymentMethod?.cvv);
    _nameController = TextEditingController(text: widget.paymentMethod?.cardHolderName);
    _isDefault = widget.paymentMethod?.isDefault ?? false;
    _selectedCardType = widget.paymentMethod?.cardType ?? 'Visa';
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
        title: Text(widget.paymentMethod == null ? 'Add Payment Method' : 'Edit Payment Method'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                decoration: InputDecoration(
                  labelText: 'Card Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Visa', 'Mastercard', 'American Express']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCardType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    _getCardTypeIcon(_selectedCardType),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter card number';
                  }
                  if (value!.replaceAll(' ', '').length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter expiry date';
                        }
                        if (value!.length != 5) {
                          return 'Invalid expiry date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter CVV';
                        }
                        if (value!.length < 3) {
                          return 'Invalid CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter cardholder name' : null,
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.paymentMethod == null
                        ? 'Add Payment Method'
                        : 'Save Changes',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCardTypeIcon(String cardType) {
    switch (cardType) {
      case 'Visa':
        return Icons.credit_card;
      case 'Mastercard':
        return Icons.credit_card;
      case 'American Express':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  void _savePaymentMethod() {
    if (!_formKey.currentState!.validate()) return;

    final paymentMethod = PaymentModel(
      id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: 'temp_order', // This will be updated when actually used in an order
      userId: 'user1', // TODO: Get from auth provider
      amount: 0.0, // This will be updated when used in an order
      status: PaymentStatus.pending,
      paymentMethod: PaymentMethod.creditCard,
      timestamp: DateTime.now(),
      transactionId: '', // This will be generated when payment is processed
      paymentDetails: {
        'cardType': _selectedCardType,
        'last4': _cardNumberController.text.replaceAll(' ', '').substring(
          _cardNumberController.text.replaceAll(' ', '').length - 4,
        ),
      },
      cardType: _selectedCardType,
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
      cardHolderName: _nameController.text,
      isDefault: _isDefault,
      createdAt: widget.paymentMethod?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, paymentMethod);
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