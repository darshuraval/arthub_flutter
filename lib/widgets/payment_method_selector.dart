import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  Widget _buildPaymentOption({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == value;
    
    return InkWell(
      onTap: () => onMethodSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2D9B88).withOpacity(0.1) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF2D9B88) : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? const Color(0xFF2D9B88) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Radio(
              value: value,
              groupValue: selectedMethod,
              onChanged: (String? value) {
                if (value != null) {
                  onMethodSelected(value);
                }
              },
              activeColor: const Color(0xFF2D9B88),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          title: 'Debit / Credit Card',
          value: 'card',
          icon: Icons.credit_card,
        ),
        _buildPaymentOption(
          title: 'Netbanking',
          value: 'netbanking',
          icon: Icons.account_balance,
        ),
        _buildPaymentOption(
          title: 'Cash on Delivery',
          value: 'cod',
          icon: Icons.local_shipping,
        ),
        _buildPaymentOption(
          title: 'Wallet',
          value: 'wallet',
          icon: Icons.account_balance_wallet,
        ),
      ],
    );
  }
} 