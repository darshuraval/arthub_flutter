import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/user/order_success_screen.dart';
import 'package:arthub_flutter/screens/admin/address_management_screen.dart';
import 'add_card_screen.dart';
import 'package:arthub_flutter/services/card_service.dart';
import 'package:arthub_flutter/services/coupon_service.dart';
import 'package:arthub_flutter/services/order_service.dart';
import 'package:arthub_flutter/services/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> selectedAddress;
  final double totalPrice;
  final String productId;
  final String sellerId;
  final String storeId;
  final Map<String, dynamic> product;

  const CheckoutPaymentScreen({
    Key? key,
    required this.selectedAddress,
    required this.totalPrice,
    required this.productId,
    required this.sellerId,
    required this.storeId,
    required this.product,
  }) : super(key: key);

  @override
  _CheckoutPaymentScreenState createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _selectedPaymentMethod = 'Debit / Credit Card';
  late Map<String, dynamic> _currentSelectedAddress;
  final CardService _cardService = CardService();
  final OrderService _orderService = OrderService();
  final PaymentService _paymentService = PaymentService();
  List<Map<String, String>> _cards = [];
  final TextEditingController _couponController = TextEditingController();
  double _discount = 0.0;
  final CouponService _couponService = CouponService();
  String _appliedCouponCode = '';
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _currentSelectedAddress = widget.selectedAddress;
    _loadCards();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Listen for changes in the coupon code input
    _couponController.addListener(() {
      // Convert coupon code to uppercase in real time
      final text = _couponController.text;
      final selection = _couponController.selection;
      if (text != text.toUpperCase()) {
        _couponController.value = TextEditingValue(
          text: text.toUpperCase(),
          selection: TextSelection.collapsed(offset: text.length),
        );
        return; // Prevents double setState
      }
      if (_couponController.text != _appliedCouponCode) {
        setState(() {
          _discount = 0.0;
          _appliedCouponCode = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final cards = await _cardService.getCardsByUserId(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _cards = cards;
    });
  }

  void _addCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCardScreen()),
    );
    if (result != null) {
      await _cardService.addCard(
        cardNumber: result['cardNumber'],
        name: result['name'],
        expiryDate: result['expiryDate'],
        cvc: result['cvc'],
        userId: result['userId'],
        cardType: result['cardType'],
        billingAddress: result['billingAddress'],
        phoneNumber: result['phoneNumber'],
      );
      await _loadCards(); // Ensure cards are reloaded after addition
    }
  }

  Future<void> _removeCard(int index) async {
    // Logic to remove card from Firestore and update local list
    setState(() {
      _cards.removeAt(index);
    });
    // Note: Implement Firestore removal logic here if needed
  }

  void _changeAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressManagementScreen(address: _currentSelectedAddress)),
    );
    if (result != null) {
      setState(() {
        _currentSelectedAddress = result;
      });
    }
  }

  Future<void> _applyCoupon() async {
    try {
      final discount = await _couponService.applyCoupon(
        _couponController.text,
        widget.totalPrice,
      );
      setState(() {
        _discount = discount;
        _appliedCouponCode = _couponController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon applied! Discount: ₹$_discount')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid coupon code')),
      );
    }
  }

  void _openRazorpayCheckout() {
    var options = {
      'key': 'rzp_test_Dvn55mNvfzFqYk', // Replace with your Razorpay key
      'amount': ((widget.totalPrice + 100 + 5 + 2.5 - _discount) * 100).toInt(), // in paise
      'name': 'ArtHub',
      'description': 'Order Payment',
      'prefill': {
        'contact': _currentSelectedAddress['mobile'].toString(),
        'email': FirebaseAuth.instance.currentUser!.email ?? ''
      },
      'theme': {'color': '#21967A'},
      'currency': 'INR',
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final payment = await _paymentService.createPayment(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: widget.sellerId,
        amount: widget.totalPrice + 100 + 5 + 2.5 - _discount,
        paymentMethod: 'Razorpay',
        status: 'Success',
        transactionId: response.paymentId,
      );
      await _orderService.createOrder(
        productId: widget.productId,
        transactionId: payment['transactionId'],
        amount: widget.totalPrice + 100 + 5 + 2.5 - _discount,
        buyerId: FirebaseAuth.instance.currentUser!.uid,
        sellerId: widget.sellerId,
        storeId: widget.storeId,
        paymentMethod: 'Razorpay',
        discount: _discount,
        addressId: _currentSelectedAddress['addressId'],
        couponId: _appliedCouponCode.isNotEmpty ? _appliedCouponCode : null,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(
            orderId: payment['transactionId'],
            productName: widget.product['productName'],
            imageUrl: widget.product['productImage'],
            price: widget.totalPrice,
            address: _currentSelectedAddress['street'] + ', ' + _currentSelectedAddress['city'] + ', ' + _currentSelectedAddress['state'] + ', ' + _currentSelectedAddress['country'] + ', ' + _currentSelectedAddress['pincode'] ?? '',
            mobile: _currentSelectedAddress['mobile'].toString() ?? '',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order creation failed: $e')),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  void _showOrderDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Summary'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product Details: Price - ₹${widget.totalPrice}'),
                const SizedBox(height: 8),
                Text('Seller Details: ${widget.sellerId}'),
                // const SizedBox(height: 8),
                // Text('Store Details: ${widget.storeId}'),
                const SizedBox(height: 8),
                Text('Buyer Details: ${FirebaseAuth.instance.currentUser!.email}'),
                const SizedBox(height: 8),
                const Divider(),
                Text('Payment Details:'),
                const SizedBox(height: 8),
                Text('Payment Method: $_selectedPaymentMethod'),
                const SizedBox(height: 8),
                Text('Address: ${_currentSelectedAddress['street']}, ${_currentSelectedAddress['city']}'),
                const SizedBox(height: 8),
                if (_appliedCouponCode.isNotEmpty)
                  Text('Applied Coupon: $_appliedCouponCode - Discount: ₹$_discount'),
                const SizedBox(height: 8),
                Text('Delivery Charge: ₹100.00'),
                const SizedBox(height: 8),
                Text('Platform Fee: ₹5.00'),
                const SizedBox(height: 8),
                Text('Tax: ₹2.50'),
                const SizedBox(height: 8),
                Text('Total Amount: ₹${widget.totalPrice + 100 + 5 + 2.5 - _discount}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openRazorpayCheckout();
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Option'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _cards.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _cards.length) {
                                    return IconButton(
                                      icon: Icon(Icons.add, size: 50, color: Colors.grey),
                                      onPressed: _addCard,
                                    );
                                  }
                                  final card = _cards[index];
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 300,
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Holder name: ${card['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                              Text('Card number: ${card['cardNumber']}', style: TextStyle(letterSpacing: 1.5)),
                                              Text('Exp. Date: ${card['expiryDate']}'),
                                              Text('CVC: ${card['cvc']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(Icons.remove_circle, color: Colors.red),
                                          onPressed: () => _removeCard(index),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Payment Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ListTile(
                            title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = 'Debit / Credit Card';
                                });
                              },
                              child: Text('Debit / Credit Card'),
                            ),
                            leading: Radio<String>(
                              value: 'Debit / Credit Card',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = 'Netbanking';
                                });
                              },
                              child: Text('Netbanking'),
                            ),
                            leading: Radio<String>(
                              value: 'Netbanking',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: GestureDetector(
                              onTap: null, // Disabled
                              child: Text('Cash on Delivery'),
                            ),
                            leading: Radio<String>(
                              value: 'Cash on Delivery',
                              groupValue: _selectedPaymentMethod,
                              onChanged: null, // Disabled
                              activeColor: Colors.grey,
                            ),
                          ),
                          ListTile(
                            title: GestureDetector(
                              onTap: null, // Disabled
                              child: Text('Wallet'),
                            ),
                            leading: Radio<String>(
                              value: 'Wallet',
                              groupValue: _selectedPaymentMethod,
                              onChanged: null, // Disabled
                              activeColor: Colors.grey,
                            ),
                          ),
                          const Divider(),
                          const Text('Deliver to', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('${_currentSelectedAddress['street']}, ${_currentSelectedAddress['city']}'),
                          Text('${_currentSelectedAddress['state']}, ${_currentSelectedAddress['country']} - ${_currentSelectedAddress['pincode']}'),
                          TextButton(
                            onPressed: _changeAddress,
                            child: const Text('Change Address'),
                          ),
                          const Divider(),
                          const Text('Price Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Price (1 item): ₹${widget.totalPrice}'),
                          TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              labelText: 'Enter Coupon Code',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.check),
                                onPressed: _applyCoupon,
                              ),
                            ),
                          ),
                          const Text('Delivery Charge: ₹100.00'),
                          const Text('Platform Fee: ₹5.00'),
                          const Text('Tax: ₹2.50'),
                          const SizedBox(height: 16),
                          if (_discount > 0) ...[
                            Text('Discount: -₹$_discount'),
                          ],
                          const Divider(),
                          Text('Total Amount: ₹${widget.totalPrice + 100 + 5 + 2.5 - _discount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _showOrderDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21967A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}