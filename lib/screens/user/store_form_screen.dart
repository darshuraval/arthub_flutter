import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/services/store_service.dart';  

class StoreFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onStoreCreated;
  final Map<String, dynamic>? initialStore;
  final bool readOnly;
  final String storeId;
  const StoreFormScreen({
    required this.storeId,
    required this.onStoreCreated,
    this.initialStore,
    this.readOnly = false,
    Key? key,
  }) : super(key: key);

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descController = TextEditingController();
  final _storeTypeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialStore != null) {
      final s = widget.initialStore!;
      _storeNameController.text = s['storeName'] ?? '';
      _websiteController.text = s['website'] ?? '';
      _descController.text = s['description'] ?? '';
      _storeTypeController.text = s['storeType'] ?? '';
      _addressController.text = s['address'] ?? '';
      _cityController.text = s['city'] ?? '';
      _stateController.text = s['state'] ?? '';
      _countryController.text = s['country'] ?? '';
      _pincodeController.text = s['pincode'] ?? '';
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _websiteController.dispose();
    _descController.dispose();
    _storeTypeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _createStore() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now().toIso8601String();
    final storeId = widget.storeId;
    final user = AuthService().getCurrentUser();
    final userId = user?.email ?? '';
    final store = {
      'storeId': storeId,
      'userId': userId,
      'storeName': _storeNameController.text.trim(),
      'website': _websiteController.text.trim(),
      'description': _descController.text.trim(),
      'storeType': _storeTypeController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'country': _countryController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'status': 'active',
      'created_at': now,
      'updated_at': now,
    };
    widget.onStoreCreated(store);
    await StoreService().createStore(
      userId: store['userId'] ?? '',
      storeName: store['storeName'] ?? '',
      storeType: store['storeType'] ?? '',
      address: store['address'] ?? '',
      city: store['city'] ?? '',
      state: store['state'] ?? '',
      country: store['country'] ?? '',
      pincode: store['pincode'] ?? '',
      website: store['website'],
      description: store['description'],
      status: store['status'] ?? 'active',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Color(0xFF21967A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Store', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.network('https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//store.png', height: 140),
                    const SizedBox(height: 16),
                    const Text(
                      'This information is used to set up your shop',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _inputField('Store Name', _storeNameController, validator: (v) => v == null || v.isEmpty ? 'Required' : null, enabled: !widget.readOnly),
              _inputField('Store Web Address', _websiteController, enabled: !widget.readOnly),
              _inputField('Store Description', _descController, enabled: !widget.readOnly),
              _inputField('Store Type', _storeTypeController, enabled: !widget.readOnly),
              _inputField('Address', _addressController, enabled: !widget.readOnly),
              _inputField('City', _cityController, enabled: !widget.readOnly),
              _inputField('State', _stateController, enabled: !widget.readOnly),
              _inputField('Country', _countryController, enabled: !widget.readOnly),
              _inputField('Pincode', _pincodeController, enabled: !widget.readOnly),
              const SizedBox(height: 32),
              if (!widget.readOnly)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF21967A),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _createStore,
                      child: Text(widget.initialStore == null ? 'Create' : 'Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {FormFieldValidator<String>? validator, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          TextFormField(
            controller: controller,
            validator: validator,
            enabled: enabled,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
