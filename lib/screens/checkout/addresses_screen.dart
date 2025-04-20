import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/screens/checkout/add_address_screen.dart';
import 'package:arthub_flutter/config/app_styles.dart';

class AddressesScreen extends StatefulWidget {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;

  const AddressesScreen({
    Key? key,
    required this.addresses,
    this.selectedAddress,
  }) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.addresses.length + 1, // +1 for the "Add New" button
        itemBuilder: (context, index) {
          if (index == widget.addresses.length) {
            return _buildAddNewButton();
          }

          final address = widget.addresses[index];
          final isSelected = widget.selectedAddress?.id == address.id;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => Navigator.pop(context, address),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(address.streetAddress),
                    Text('${address.city}, ${address.state} ${address.zipCode}'),
                    Text(address.country),
                    const SizedBox(height: 8),
                    Text(
                      address.phoneNumber,
                      style: const TextStyle(color: Colors.grey),
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

  Widget _buildAddNewButton() {
    return Card(
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAddressScreen(
                addressType: 'shipping',
              ),
            ),
          );
          if (result != null && result is AddressModel) {
            Navigator.pop(context, result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline),
              const SizedBox(width: 8),
              Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppStyles.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 