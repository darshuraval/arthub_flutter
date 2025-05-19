import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders = await _orderService.getAllOrders();
    setState(() {
      _orders = orders.map((order) => {
        'orderId': order['orderId'],
        'userId': order['userId'],
        'total': order['total'],
        'status': order['status'],
        'created_at': order['created_at'],
        'updated_at': order['updated_at'],
        'productId': order['productId'],
        'amount': order['amount'],
        'buyerId': order['buyerId'],
        'sellerId': order['sellerId'],
        'storeId': order['storeId'],
        'paymentMethod': order['paymentMethod'],
        'discount': order['discount'],
      }).toList();
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _createOrEditOrder({Map<String, dynamic>? order}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _OrderFormDialog(order: order),
    );
    if (result != null) {
      try {
        final now = DateTime.now().toIso8601String();
        if (order == null) {
          final orderId = DateTime.now().millisecondsSinceEpoch.toString();
          final newOrder = {
            'orderId': orderId,
            'userId': result['userId'] ?? '',
            'total': double.tryParse(result['total'] ?? '0') ?? 0.0,
            'status': result['status'] ?? 'pending',
            'transactionId': result['transactionId'] ?? '',
            'created_at': now,
            'updated_at': now,
            'productId': result['productId'] ?? '',
            'amount': double.tryParse(result['total'] ?? '') ?? 0.0,
            'buyerId': result['userId'] ?? '',
            'sellerId': result['sellerId'] ?? '',
            'storeId': result['storeId'] ?? '',
            'paymentMethod': result['paymentMethod'] ?? '',
            'discount': (result['discount'] ?? '').isEmpty ? null : double.tryParse(result['discount']),
          };
          await _orderService.createOrder(
            productId: result['productId'] ?? '',
            transactionId: result['transactionId'] ?? '',
            amount: double.tryParse(result['total'] ?? '0') ?? 0.0,
            buyerId: result['userId'] ?? '',
            sellerId: result['sellerId'] ?? '',
            storeId: result['storeId'] ?? '',
            paymentMethod: result['paymentMethod'] ?? '',
            discount: result['discount'] != null && result['discount'] != '' ? double.tryParse(result['discount']) : 0.0,
            status: result['status'] ?? 'pending',
            addressId: null,
            couponId: null,
          );
        } else {
          await _orderService.updateOrder(
            orderId: order['orderId'],
            productId: result['productId'] ?? order['productId'],
            transactionId: result['transactionId'] ?? order['transactionId'],
            amount: double.tryParse(result['total'] ?? order['amount'].toString()) ?? order['amount'],
            buyerId: result['userId'] ?? order['buyerId'],
            sellerId: result['sellerId'] ?? order['sellerId'],
            storeId: result['storeId'] ?? order['storeId'],
            paymentMethod: result['paymentMethod'] ?? order['paymentMethod'],
            discount: result['discount'] != null && result['discount'] != '' ? double.tryParse(result['discount']) : order['discount'],
            status: result['status'] ?? order['status'],
          );
        }
        await _loadOrders();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(order == null ? 'Order created' : 'Order updated')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save order: $e')),
        );
      }
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      final deleted = await _orderService.deleteOrder(orderId);
      if (!deleted) return;
      await _loadOrders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order deleted')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
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
    final filteredOrders = _searchQuery.isEmpty
        ? _orders
        : _orders.where((order) =>
            (order['orderId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (order['userId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (order['status'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      hintText: 'Search Order',
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
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _OrderCard(
                        order: order,
                        onEdit: () => _createOrEditOrder(order: order),
                        onDelete: () => _deleteOrder(order['orderId']),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrEditOrder(),
        backgroundColor: const Color(0xFF339989),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _OrderCard({required this.order, required this.onEdit, required this.onDelete, Key? key}) : super(key: key);

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
          const Icon(Icons.receipt_long, size: 48, color: Color(0xFF339989)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order['orderId'] ?? ''}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text('Product ID: ${order['productId'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Amount: ₹${order['amount'] ?? 0}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Buyer ID: ${order['buyerId'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Seller ID: ${order['sellerId'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Store ID: ${order['storeId'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Payment Method: ${order['paymentMethod'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text('Discount: ${order['discount'] ?? ''}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  'Status: ${order['status'] ?? 'pending'}',
                  style: TextStyle(
                    fontSize: 15,
                    color: (order['status'] == 'completed') ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
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

class _OrderFormDialog extends StatefulWidget {
  final Map<String, dynamic>? order;
  const _OrderFormDialog({this.order});

  @override
  State<_OrderFormDialog> createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<_OrderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productIdController;
  late TextEditingController _totalController;
  late TextEditingController _userIdController;
  late TextEditingController _sellerIdController;
  late TextEditingController _storeIdController;
  late TextEditingController _paymentMethodController;
  late TextEditingController _discountController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(text: widget.order?['productId'] ?? '');
    _totalController = TextEditingController(text: widget.order?['amount']?.toString() ?? '');
    _userIdController = TextEditingController(text: widget.order?['buyerId'] ?? '');
    _sellerIdController = TextEditingController(text: widget.order?['sellerId'] ?? '');
    _storeIdController = TextEditingController(text: widget.order?['storeId'] ?? '');
    _paymentMethodController = TextEditingController(text: widget.order?['paymentMethod'] ?? '');
    _discountController = TextEditingController(text: widget.order?['discount']?.toString() ?? '');
    _statusController = TextEditingController(text: widget.order?['status'] ?? 'pending');
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _totalController.dispose();
    _userIdController.dispose();
    _sellerIdController.dispose();
    _storeIdController.dispose();
    _paymentMethodController.dispose();
    _discountController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'productId': _productIdController.text.trim(),
      'total': _totalController.text.trim(),
      'userId': _userIdController.text.trim(),
      'sellerId': _sellerIdController.text.trim(),
      'storeId': _storeIdController.text.trim(),
      'paymentMethod': _paymentMethodController.text.trim(),
      'discount': _discountController.text.trim(),
      'status': _statusController.text.trim(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.order == null ? 'Add Order' : 'Edit Order'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(labelText: 'Product ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter product ID' : null,
              ),
              TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter amount' : null,
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'Buyer ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter buyer ID' : null,
              ),
              TextFormField(
                controller: _sellerIdController,
                decoration: const InputDecoration(labelText: 'Seller ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter seller ID' : null,
              ),
              TextFormField(
                controller: _storeIdController,
                decoration: const InputDecoration(labelText: 'Store ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter store ID' : null,
              ),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter payment method' : null,
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount (optional)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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