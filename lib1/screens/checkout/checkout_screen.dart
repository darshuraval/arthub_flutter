import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import 'package:arthub_flutter/widgets/address_selection_widget.dart';
import 'package:arthub_flutter/widgets/payment_method_selection_widget.dart';
import 'package:arthub_flutter/models/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  final CartModel cart;

  const CheckoutScreen({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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
        title: const Text('Checkout'),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Shipping Address'),
                const SizedBox(height: 8),
                AddressSelectionWidget(addressType: 'shipping'),
                const SizedBox(height: 24),
                _buildSectionTitle('Billing Address'),
                const SizedBox(height: 8),
                AddressSelectionWidget(addressType: 'billing'),
                const SizedBox(height: 24),
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 8),
                const PaymentMethodSelectionWidget(),
                const SizedBox(height: 32),
                _buildOrderSummary(provider),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canProceed(provider) ? _placeOrder : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildOrderSummary(CheckoutProvider provider) {
    return Card(
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
            _buildSummaryRow('Subtotal', '\$${widget.cart.subtotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Shipping', '\$${widget.cart.shipping.toStringAsFixed(2)}'),
            _buildSummaryRow('Tax', '\$${widget.cart.tax.toStringAsFixed(2)}'),
            const Divider(height: 32),
            _buildSummaryRow(
              'Total',
              '\$${widget.cart.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: style),
        ],
      ),
    );
  }

  bool _canProceed(CheckoutProvider provider) {
    return provider.selectedShippingAddress != null &&
        provider.selectedBillingAddress != null &&
        provider.selectedPaymentMethod != null;
  }

  void _placeOrder() {
    // TODO: Implement order placement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.pop(context);
  }
} 