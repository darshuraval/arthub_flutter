import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/address_service.dart';
import 'package:intl/intl.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressService _addressService = AddressService();
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _statusFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  static const List<String> _statusOptions = ['All', 'active', 'inactive'];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    final addresses = await _addressService.getAllAddresses();
    setState(() {
      _addresses = addresses;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _createOrEditAddress({Map<String, dynamic>? address}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddressFormDialog(address: address),
    );
    if (result != null) {
      try {
        if (address == null) {
          await _addressService.createAddress(
            userId: result['userId'] ?? '',
            street: result['street'] ?? '',
            city: result['city'] ?? '',
            district: result['district'] ?? '',
            state: result['state'] ?? '',
            country: result['country'] ?? '',
            pincode: result['pincode'] ?? '',
            landmark: result['landmark'],
            status: result['status'] ?? 'active',
          );
        } else {
          await _addressService.updateAddress(
            addressId: address['addressId'],
            street: result['street'],
            city: result['city'],
            district: result['district'],
            state: result['state'],
            country: result['country'],
            pincode: result['pincode'],
            landmark: result['landmark'],
            status: result['status'],
          );
        }
        await _loadAddresses();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(address == null ? 'Address created' : 'Address updated')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save address: $e')),
        );
      }
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      final deleted = await _addressService.deleteAddress(addressId);
      if (!deleted) return;
      await _loadAddresses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address deleted')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete address: $e')),
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
    final filteredAddresses = _addresses.where((address) {
      final matchesSearch = _searchQuery.isEmpty ||
        (address['addressId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['userId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['street'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['city'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['district'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['state'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['country'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (address['pincode'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'All' || (address['status'] ?? '') == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAddresses,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search by any field',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: _statusOptions.map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status[0].toUpperCase() + status.substring(1)),
                  )).toList(),
                  onChanged: (val) => setState(() => _statusFilter = val ?? 'All'),
                  hint: const Text('Status'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Address'),
                  onPressed: () => _createOrEditAddress(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: PaginatedDataTable(
                              header: const Text('Addresses'),
                              columns: const [
                                DataColumn(label: Text('Address ID')),
                                DataColumn(label: Text('User ID')),
                                DataColumn(label: Text('Street')),
                                DataColumn(label: Text('City')),
                                DataColumn(label: Text('District')),
                                DataColumn(label: Text('State')),
                                DataColumn(label: Text('Country')),
                                DataColumn(label: Text('Landmark')),
                                DataColumn(label: Text('Pincode')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Created At')),
                                DataColumn(label: Text('Updated At')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _AddressesDataSource(
                                filteredAddresses,
                                context: context,
                                onEdit: (address) => _createOrEditAddress(address: address),
                                onDelete: (addressId) => _deleteAddress(addressId),
                              ),
                              rowsPerPage: 8,
                              showCheckboxColumn: false,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressesDataSource extends DataTableSource {
  final List<Map<String, dynamic>> addresses;
  final BuildContext context;
  final void Function(Map<String, dynamic> address) onEdit;
  final void Function(String addressId) onDelete;

  _AddressesDataSource(this.addresses, {required this.context, required this.onEdit, required this.onDelete});

  @override
  DataRow getRow(int index) {
    final address = addresses[index];
    final createdAt = address['created_at'] ?? '';
    final updatedAt = address['updated_at'] ?? '';
    Color statusColor;
    switch (address['status']) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'inactive':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(address['addressId'] ?? '')),
        DataCell(Text(address['userId'] ?? '')),
        DataCell(Text(address['street'] ?? '')),
        DataCell(Text(address['city'] ?? '')),
        DataCell(Text(address['district'] ?? '')),
        DataCell(Text(address['state'] ?? '')),
        DataCell(Text(address['country'] ?? '')),
        DataCell(Text(address['landmark'] ?? '')),
        DataCell(Text(address['pincode'] ?? '')),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            address['status'] ?? '',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        )),
        DataCell(Text(_formatDate(createdAt))),
        DataCell(Text(_formatDate(updatedAt))),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(address),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Address'),
                      ],
                    ),
                    content: const Text('Are you sure you want to delete this address? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  onDelete(address['addressId']);
                }
              },
              tooltip: 'Delete',
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => addresses.length;
  @override
  int get selectedRowCount => 0;
}

String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '';
  try {
    final dt = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  } catch (_) {
    return dateStr;
  }
}

class _AddressFormDialog extends StatefulWidget {
  final Map<String, dynamic>? address;
  const _AddressFormDialog({this.address});

  @override
  State<_AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<_AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _landmarkController;
  late TextEditingController _pincodeController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.address?['userId'] ?? '');
    _streetController = TextEditingController(text: widget.address?['street'] ?? '');
    _cityController = TextEditingController(text: widget.address?['city'] ?? '');
    _districtController = TextEditingController(text: widget.address?['district'] ?? '');
    _stateController = TextEditingController(text: widget.address?['state'] ?? '');
    _countryController = TextEditingController(text: widget.address?['country'] ?? '');
    _landmarkController = TextEditingController(text: widget.address?['landmark'] ?? '');
    _pincodeController = TextEditingController(text: widget.address?['pincode'] ?? '');
    _statusController = TextEditingController(text: widget.address?['status'] ?? 'active');
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'userId': _userIdController.text.trim(),
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'district': _districtController.text.trim(),
      'state': _stateController.text.trim(),
      'country': _countryController.text.trim(),
      'landmark': _landmarkController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'status': _statusController.text.trim(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter user ID' : null,
              ),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter street' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter city' : null,
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'District'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter district' : null,
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter state' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter country' : null,
              ),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(labelText: 'Landmark (optional)'),
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter pincode' : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter status' : null,
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