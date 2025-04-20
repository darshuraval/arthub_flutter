import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/cart_model.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/widgets/address_card.dart';
import 'package:arthub_flutter/widgets/payment_method_card.dart';
import 'package:arthub_flutter/widgets/order_summary_card.dart';
import 'package:arthub_flutter/screens/checkout/add_address_screen.dart';
import 'package:arthub_flutter/screens/checkout/add_payment_screen.dart';
import 'package:arthub_flutter/screens/checkout/order_confirmation_screen.dart';

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
  AddressModel? selectedShippingAddress;
  AddressModel? selectedBillingAddress;
  PaymentModel? selectedPaymentMethod;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Address Section
                _buildSectionTitle('Shipping Address'),
                if (selectedShippingAddress != null)
                  AddressCard(
                    address: selectedShippingAddress!,
                    isSelected: true,
                    onEdit: () => _editAddress(true),
                    onDelete: () => setState(() => selectedShippingAddress = null),
                  )
                else
                  _buildAddButton(
                    'Add Shipping Address',
                    () => _addAddress(true),
                  ),
                const SizedBox(height: 24),

                // Billing Address Section
                _buildSectionTitle('Billing Address'),
                if (selectedBillingAddress != null)
                  AddressCard(
                    address: selectedBillingAddress!,
                    isSelected: true,
                    onEdit: () => _editAddress(false),
                    onDelete: () => setState(() => selectedBillingAddress = null),
                  )
                else
                  _buildAddButton(
                    'Add Billing Address',
                    () => _addAddress(false),
                  ),
                const SizedBox(height: 24),

                // Payment Method Section
                _buildSectionTitle('Payment Method'),
                if (selectedPaymentMethod != null)
                  PaymentMethodCard(
                    method: selectedPaymentMethod!,
                    isSelected: true,
                    onTap: () => _editPayment(),
                  )
                else
                  _buildAddButton(
                    'Add Payment Method',
                    _addPayment,
                  ),
                const SizedBox(height: 24),

                // Order Summary Section
                _buildSectionTitle('Order Summary'),
                OrderSummaryCard(cart: widget.cart),
                const SizedBox(height: 24),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _placeOrder : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _addAddress(bool isShipping) async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          addressType: isShipping ? 'shipping' : 'billing',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (isShipping) {
          selectedShippingAddress = result;
        } else {
          selectedBillingAddress = result;
        }
      });
    }
  }

  Future<void> _editAddress(bool isShipping) async {
    final address = isShipping ? selectedShippingAddress : selectedBillingAddress;
    if (address == null) return;

    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          addressType: isShipping ? 'shipping' : 'billing',
          address: address,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (isShipping) {
          selectedShippingAddress = result;
        } else {
          selectedBillingAddress = result;
        }
      });
    }
  }

  Future<void> _addPayment() async {
    final result = await Navigator.push<PaymentModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPaymentScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  Future<void> _editPayment() async {
    final result = await Navigator.push<PaymentModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddPaymentScreen(
          existingPayment: selectedPaymentMethod,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  bool _canProceed() {
    return selectedShippingAddress != null &&
        selectedBillingAddress != null &&
        selectedPaymentMethod != null &&
        !isProcessing;
  }

  Future<void> _placeOrder() async {
    if (!_canProceed()) return;

    setState(() => isProcessing = true);

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      // Create order and payment models
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final payment = PaymentModel(
        id: 'pay_$orderId',
        orderId: orderId,
        userId: widget.cart.userId,
        amount: widget.cart.total,
        status: PaymentStatus.completed,
        paymentMethod: PaymentMethod.creditCard,
        timestamp: DateTime.now(),
        transactionId: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        paymentDetails: {'source': 'app'},
        cardType: selectedPaymentMethod!.cardType,
        cardNumber: selectedPaymentMethod!.cardNumber,
        expiryDate: selectedPaymentMethod!.expiryDate,
        cardholderName: selectedPaymentMethod!.cardholderName,
        isDefault: selectedPaymentMethod!.isDefault,
      );

      // Navigate to order confirmation
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            cart: widget.cart,
            payment: payment,
            orderNumber: orderId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }
} 