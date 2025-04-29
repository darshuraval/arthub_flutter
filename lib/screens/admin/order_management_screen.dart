import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/admin_service.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final AdminService _adminService = AdminService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (!_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final result = await _adminService.getAllOrders(lastDocument: _lastDocument);
      if (result.data.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = result.lastDoc;
        _orders.addAll(result.data);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateOrderStatus(String userId, String orderId, String currentStatus) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Pending'),
              value: 'pending',
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile(
              title: const Text('Processing'),
              value: 'processing',
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile(
              title: const Text('Shipped'),
              value: 'shipped',
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile(
              title: const Text('Delivered'),
              value: 'delivered',
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile(
              title: const Text('Cancelled'),
              value: 'cancelled',
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, currentStatus),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (newStatus != null && newStatus != currentStatus) {
      try {
        await _adminService.updateOrderStatus(userId, orderId, newStatus);
        setState(() {
          final orderIndex = _orders.indexWhere(
            (order) => order['id'] == orderId && order['userId'] == userId,
          );
          if (orderIndex != -1) {
            _orders[orderIndex]['status'] = newStatus;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order status updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update order status: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
      ),
      body: _isLoading && _orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _orders.clear();
                _lastDocument = null;
                _hasMore = true;
                await _loadOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _orders.length) {
                    _loadOrders();
                    return const Center(child: CircularProgressIndicator());
                  }

                  final order = _orders[index];
                  return Card(
                    child: ListTile(
                      title: Text('Order #${order['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User ID: ${order['userId']}'),
                          Text('Status: ${order['status']}'),
                          Text(
                            'Total: \$${order['total']?.toStringAsFixed(2) ?? '0.00'}',
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (status) => _updateOrderStatus(
                          order['userId'],
                          order['id'],
                          status,
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          const PopupMenuItem(
                            value: 'processing',
                            child: Text('Processing'),
                          ),
                          const PopupMenuItem(
                            value: 'shipped',
                            child: Text('Shipped'),
                          ),
                          const PopupMenuItem(
                            value: 'delivered',
                            child: Text('Delivered'),
                          ),
                          const PopupMenuItem(
                            value: 'cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
} 