import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/address_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressManagementScreen extends StatefulWidget {
  final Map<String, dynamic>? address;

  const AddressManagementScreen({Key? key, this.address}) : super(key: key);

  @override
  _AddressManagementScreenState createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  final AddressService _addressService = AddressService();
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    if (widget.address != null) {
      _selectedAddress = widget.address;
    }
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

  Future<void> _addOrEditAddress({Map<String, dynamic>? address}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressFormScreen(address: address)),
    );
    if (result == true) {
      _loadAddresses();
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    await _addressService.deleteAddress(addressId);
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Addresses'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: RadioListTile(
                    value: address,
                    groupValue: _selectedAddress,
                    onChanged: (value) {
                      setState(() {
                        _selectedAddress = value;
                      });
                      Navigator.pop(context, _selectedAddress);
                    },
                    title: Text('${address['street']}, ${address['city']}'),
                    subtitle: Text('${address['state']}, ${address['country']} - ${address['pincode']}'),
                    secondary: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _addOrEditAddress(address: address);
                        } else if (value == 'delete') {
                          _deleteAddress(address['addressId']);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Assuming product price and delivery fee are passed as arguments
                // Text('Product Price: ${widget.product['price']}'),
                // Text('Delivery Fee: ${widget.deliveryFee.toStringAsFixed(2)}'),
                // const Divider(),
                // Text('Total: ${(widget.product['price'] + widget.deliveryFee).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditAddress(),
        backgroundColor: const Color(0xFF21967A),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddressFormScreen extends StatefulWidget {
  final Map<String, dynamic>? address;

  const AddressFormScreen({Key? key, this.address}) : super(key: key);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final AddressService _addressService = AddressService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!['street'];
      _cityController.text = widget.address!['city'];
      _stateController.text = widget.address!['state'];
      _countryController.text = widget.address!['country'];
      _pincodeController.text = widget.address!['pincode'];
      _landmarkController.text = widget.address!['landmark'] ?? '';
      _districtController.text = widget.address!['district'] ?? '';
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      if (widget.address == null) {
        await _addressService.createAddress(
          userId: FirebaseAuth.instance.currentUser!.uid,
          street: _streetController.text,
          city: _cityController.text,
          district: _districtController.text,
          state: _stateController.text,
          country: _countryController.text,
          pincode: _pincodeController.text,
          landmark: _landmarkController.text,
        );
      } else {
        await _addressService.updateAddress(
          addressId: widget.address!['addressId'],
          street: _streetController.text,
          city: _cityController.text,
          district: _districtController.text,
          state: _stateController.text,
          country: _countryController.text,
          pincode: _pincodeController.text,
          landmark: _landmarkController.text,
        );
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a street' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a city' : null,
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'District'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a district' : null,
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a state' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a country' : null,
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a pincode' : null,
              ),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(labelText: 'Landmark'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21967A),
                  padding: const EdgeInsets.symmetric(vertical:15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save Adderess",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
