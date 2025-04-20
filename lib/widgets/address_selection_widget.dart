import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import 'package:arthub_flutter/screens/checkout/add_address_screen.dart';

class AddressSelectionWidget extends StatelessWidget {
  final String addressType;
  final bool showAddButton;

  const AddressSelectionWidget({
    Key? key,
    required this.addressType,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, provider, child) {
        final addresses = provider.addresses
            .where((address) => address.addressType == addressType)
            .toList();
        final selectedAddress = addressType == 'shipping'
            ? provider.selectedShippingAddress
            : provider.selectedBillingAddress;

        if (addresses.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAddButton)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextButton.icon(
                  onPressed: () => _addAddress(context),
                  icon: const Icon(Icons.add),
                  label: Text('Add ${addressType == 'shipping' ? 'Shipping' : 'Billing'} Address'),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(context, address, selectedAddress);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${addressType == 'shipping' ? 'shipping' : 'billing'} address found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addAddress(context),
            child: Text('Add ${addressType == 'shipping' ? 'Shipping' : 'Billing'} Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressModel address,
    AddressModel? selectedAddress,
  ) {
    final isSelected = selectedAddress?.id == address.id;
    final provider = Provider.of<CheckoutProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          if (addressType == 'shipping') {
            provider.selectShippingAddress(address);
          } else {
            provider.selectBillingAddress(address);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) {
                  if (addressType == 'shipping') {
                    provider.selectShippingAddress(address);
                  } else {
                    provider.selectBillingAddress(address);
                  }
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(address.streetAddress),
                    Text('${address.city}, ${address.state} ${address.zipCode}'),
                    Text(address.country),
                    if (address.phoneNumber.isNotEmpty)
                      Text('Phone: ${address.phoneNumber}'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editAddress(context, address),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addAddress(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(addressType: addressType),
      ),
    );

    if (result != null && result is AddressModel) {
      final provider = Provider.of<CheckoutProvider>(context, listen: false);
      await provider.addAddress(result);
    }
  }

  Future<void> _editAddress(BuildContext context, AddressModel address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          addressType: addressType,
          address: address,
        ),
      ),
    );

    if (result != null && result is AddressModel) {
      final provider = Provider.of<CheckoutProvider>(context, listen: false);
      await provider.updateAddress(result);
    }
  }
} 