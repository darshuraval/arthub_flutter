import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Management'),
      ),
      body: const Center(
        child: Text('Address Screen Content'),
      ),
    );
  }
} 