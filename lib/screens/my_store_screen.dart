import 'package:flutter/material.dart';
import 'package:arthub_flutter/widgets/form_input_field.dart';
import 'package:arthub_flutter/widgets/custom_button.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({Key? key}) : super(key: key);

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  final _storeNameController = TextEditingController();
  final _webAddressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storeTypeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _webAddressController.dispose();
    _descriptionController.dispose();
    _storeTypeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
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
          'My Store',
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
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF2D9B88),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/store_setup.png', // Make sure to add this image
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This information is used to set up your shop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FormInputField(
                    controller: _storeNameController,
                    labelText: 'Store Name',
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _webAddressController,
                    labelText: 'Store Web Address',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _descriptionController,
                    labelText: 'Store Description',
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _storeTypeController,
                    labelText: 'Store Type',
                  ),
                  const SizedBox(height: 24),
                  FormInputField(
                    controller: _addressController,
                    labelText: 'Address',
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
                    controller: _countryController,
                    labelText: 'Country',
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
          text: 'Create',
          onPressed: () {
            // Handle store creation
            print('Creating store...');
          },
          backgroundColor: const Color(0xFF2D9B88),
          textColor: Colors.white,
        ),
      ),
    );
  }
} 