import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _cardTypeController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addCard() {
    final cardDetails = {
      'cardNumber': _cardNumberController.text,
      'name': _nameController.text,
      'expiryDate': _expiryDateController.text,
      'cvc': _cvcController.text,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'cardType': _cardTypeController.text,
      'billingAddress': _billingAddressController.text,
      'phoneNumber': _phoneNumberController.text,
    };
    Navigator.pop(context, cardDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Holder name: Darshan Raval'),
                    Text('Card number: 5501 22** **** 4487'),
                    Text('Exp. Date: 16/19'),
                    Text('CVC: 111'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _expiryDateController,
              decoration: const InputDecoration(labelText: 'Expires Date'),
            ),
            TextField(
              controller: _cvcController,
              decoration: const InputDecoration(labelText: 'CVC'),
            ),
            TextField(
              controller: _cardTypeController,
              decoration: const InputDecoration(labelText: 'Card Type'),
            ),
            TextField(
              controller: _billingAddressController,
              decoration: const InputDecoration(labelText: 'Billing Address'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF21967A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add Credit Card', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
