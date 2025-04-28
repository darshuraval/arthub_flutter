import 'package:flutter/material.dart';
import 'package:arthub_flutter/widgets/form_input_field.dart';
import 'package:arthub_flutter/widgets/location_button.dart';
import 'package:arthub_flutter/widgets/custom_button.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D9B88),
        elevation: 0,
        title: const Text(
          'Add a new address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LocationButton(
              onPressed: () {
                // Handle get current location
                print('Getting current location...');
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FormInputField(
                    controller: _nameController,
                    labelText: 'Name',
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _phoneController,
                    labelText: 'Phone',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _streetController,
                    labelText: 'Street address',
                    keyboardType: TextInputType.streetAddress,
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _cityController,
                    labelText: 'City',
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _stateController,
                    labelText: 'State',
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _zipcodeController,
                    labelText: 'Zipcode',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: 'Save',
          onPressed: () {
            // Handle save address
            print('Saving address...');
          },
          backgroundColor: const Color(0xFF2D9B88),
          textColor: Colors.white,
        ),
      ),
    );
  }
} 