import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/address_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arthub_flutter/screens/admin/address_management_screen.dart';
import 'checkout_payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arthub_flutter/services/store_service.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final double deliveryFee;

  const CheckoutScreen({Key? key, required this.product, this.deliveryFee = 0.0}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final AddressService _addressService = AddressService();
  final StoreService _storeService = StoreService();
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;
  String? _storeOwnerId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _fetchStoreOwnerId();
  }

  Future<void> _loadAddresses() async {
    final addresses = await _addressService.getAddressesByUserId(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _addresses = addresses;
      if (_selectedAddress == null && _addresses.isNotEmpty) {
        _selectedAddress = _addresses.first;
      }
    });
  }

  Future<void> _fetchStoreOwnerId() async {
    try {
      final storeId = widget.product['storeId'];
      final storeData = await _storeService.getStoreById(storeId);
      if (storeData != null) {
        final ownerId = storeData['userId'];
        setState(() {
          _storeOwnerId = ownerId;
        });
      }
    } catch (e) {
      print('Error fetching store owner ID: $e');
    }
  }

  Future<void> _addOrEditAddress({Map<String, dynamic>? address}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressManagementScreen(address: _selectedAddress),
      ),
    );
    if (result != null) {
      _loadAddresses();
      setState(() {
        _selectedAddress = result;
      });
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    await _addressService.deleteAddress(addressId);
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.product['price'] + widget.deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(widget.product['productImage'], width: 100, height: 100, fit: BoxFit.cover),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['productName'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${widget.product['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF21967A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Delivery Fee: \$${widget.deliveryFee.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (_selectedAddress != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_selectedAddress!['street']}, ${_selectedAddress!['city']}'),
                      Text('${_selectedAddress!['state']}, ${_selectedAddress!['country']} - ${_selectedAddress!['pincode']}'),
                      TextButton(
                        onPressed: () => _addOrEditAddress(address: _selectedAddress),
                        child: const Text('Change Address'),
                      ),
                    ],
                  )
                else
                  TextButton(
                    onPressed: _addOrEditAddress,
                    child: const Text('Add New Address'),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          Text('Product ID: ${widget.product['productId'] ?? 'Unknown'}'),
          Text('Store Owner User ID: ${_storeOwnerId ?? 'Unknown'}'),
          Text('Store ID: ${widget.product['storeId'] ?? 'Unknown'}'),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPaymentScreen(
                      selectedAddress: _selectedAddress!,
                      productId: widget.product['productId'],
                      sellerId: _storeOwnerId ?? 'Unknown',
                      storeId: widget.product['storeId'],
                      totalPrice: widget.product['price'] ?? 0.0,
                      product: widget.product,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3DCC9),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Continue to Payment', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}