import 'package:flutter/material.dart';
import '../../services/store_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final StoreService _storeService = StoreService();
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() => _isLoading = true);
    final stores = await _storeService.getAllStores();
    setState(() {
      _stores = stores;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _createOrEditStore({Map<String, dynamic>? store}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _StoreFormDialog(store: store),
    );
    if (result != null) {
      try {
        if (store == null) {
          await _storeService.createStore(
            userId: result['userId'] ?? '',
            storeName: result['storeName'] ?? '',
            storeType: result['storeType'] ?? '',
            address: result['address'] ?? '',
            city: result['city'] ?? '',
            state: result['state'] ?? '',
            country: result['country'] ?? '',
            pincode: result['pincode'] ?? '',
            website: result['website'],
            description: result['description'],
            status: result['status'] ?? 'active',
          );
        } else {
          await _storeService.updateStore(
            storeId: store['storeId'],
            storeName: result['storeName'],
            storeType: result['storeType'],
            address: result['address'],
            city: result['city'],
            state: result['state'],
            country: result['country'],
            pincode: result['pincode'],
            website: result['website'],
            description: result['description'],
            status: result['status'],
          );
        }
        await _loadStores();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(store == null ? 'Store created' : 'Store updated')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save store: $e')),
        );
      }
    }
  }

  Future<void> _deleteStore(String storeId) async {
    try {
      await _storeService.deleteStore(storeId);
      await _loadStores();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Store deleted')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete store: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = _searchQuery.isEmpty
        ? _stores
        : _stores.where((store) =>
            (store['storeName'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (store['city'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (store['storeType'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF339989),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF339989)),
                      hintText: 'Search Store',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = filteredStores[index];
                      return _StoreCard(
                        store: store,
                        onEdit: () => _createOrEditStore(store: store),
                        onDelete: () => _deleteStore(store['storeId']),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrEditStore(),
        backgroundColor: const Color(0xFF339989),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _StoreCard({required this.store, required this.onEdit, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.store, size: 48, color: Color(0xFF339989)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store['storeName'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  store['storeType'] ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  '${store['address'] ?? ''}, ${store['city'] ?? ''}',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  'Status: ${store['status'] ?? 'active'}',
                  style: TextStyle(
                    fontSize: 15,
                    color: (store['status'] == 'active') ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9B88),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('Edit'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreFormDialog extends StatefulWidget {
  final Map<String, dynamic>? store;
  const _StoreFormDialog({this.store});

  @override
  State<_StoreFormDialog> createState() => _StoreFormDialogState();
}

class _StoreFormDialogState extends State<_StoreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _storeNameController;
  late TextEditingController _storeTypeController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _pincodeController;
  late TextEditingController _websiteController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _userIdController;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(text: widget.store?['storeName'] ?? '');
    _storeTypeController = TextEditingController(text: widget.store?['storeType'] ?? '');
    _addressController = TextEditingController(text: widget.store?['address'] ?? '');
    _cityController = TextEditingController(text: widget.store?['city'] ?? '');
    _stateController = TextEditingController(text: widget.store?['state'] ?? '');
    _countryController = TextEditingController(text: widget.store?['country'] ?? '');
    _pincodeController = TextEditingController(text: widget.store?['pincode'] ?? '');
    _websiteController = TextEditingController(text: widget.store?['website'] ?? '');
    _descriptionController = TextEditingController(text: widget.store?['description'] ?? '');
    _statusController = TextEditingController(text: widget.store?['status'] ?? 'active');
    _userIdController = TextEditingController(text: widget.store?['userId'] ?? '');
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeTypeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'storeName': _storeNameController.text.trim(),
      'storeType': _storeTypeController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'country': _countryController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'website': _websiteController.text.trim(),
      'description': _descriptionController.text.trim(),
      'status': _statusController.text.trim(),
      'userId': _userIdController.text.trim(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.store == null ? 'Add Store' : 'Edit Store'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(labelText: 'Store Name'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter store name' : null,
              ),
              TextFormField(
                controller: _storeTypeController,
                decoration: const InputDecoration(labelText: 'Store Type'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode'),
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _saveForm, child: const Text('Save')),
      ],
    );
  }
}