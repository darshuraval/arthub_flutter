import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import 'package:arthub_flutter/widgets/address_selection_widget.dart';
import 'package:arthub_flutter/widgets/payment_method_selection_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CheckoutProvider>(context, listen: false);
      provider.loadAddresses();
      provider.loadPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Addresses'),
            const SizedBox(height: 8),
            const AddressSelectionWidget(addressType: 'shipping'),
            const SizedBox(height: 24),
            _buildSectionTitle('Billing Addresses'),
            const SizedBox(height: 8),
            const AddressSelectionWidget(addressType: 'billing'),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Methods'),
            const SizedBox(height: 8),
            const PaymentMethodSelectionWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
} 