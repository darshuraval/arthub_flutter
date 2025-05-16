import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/payment_service.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PaymentService _paymentService = PaymentService();
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _methodFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _statusOptions = ['All', 'completed', 'pending', 'failed'];
  static const List<String> _methodOptions = ['All', 'card', 'paypal', 'bank', 'cash'];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() => _isLoading = true);
    final payments = await _paymentService.getAllPayments();
    setState(() {
      _payments = payments;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _createOrEditPayment({Map<String, dynamic>? payment}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _PaymentFormDialog(payment: payment),
    );
    if (result != null) {
      try {
        if (payment == null) {
          await _paymentService.createPayment(
            senderId: result['senderId'] ?? '',
            receiverId: result['receiverId'] ?? '',
            amount: double.tryParse(result['amount'] ?? '') ?? 0.0,
            paymentMethod: result['paymentMethod'] ?? '',
            transactionId: (result['transactionId'] ?? '').isEmpty ? null : result['transactionId'],
            paidAt: (result['paid_at'] ?? '').isEmpty ? null : result['paid_at'],
            status: result['status'] ?? 'pending',
          );
        } else {
          await _paymentService.updatePayment(
            transactionId: payment['transactionId'],
            amount: double.tryParse(result['amount'] ?? payment['amount'].toString()) ?? payment['amount'],
            paymentMethod: result['paymentMethod'] ?? payment['paymentMethod'],
            paidAt: (result['paid_at'] ?? payment['paid_at'] ?? '').isEmpty ? payment['paid_at'] : result['paid_at'],
            status: result['status'] ?? payment['status'],
          );
        }
        await _loadPayments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(payment == null ? 'Payment created' : 'Payment updated')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save payment: $e')),
        );
      }
    }
  }

  Future<void> _deletePayment(String transactionId) async {
    try {
      final deleted = await _paymentService.deletePayment(transactionId);
      if (!deleted) return;
      await _loadPayments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment deleted')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete payment: $e')),
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
    final filteredPayments = _payments.where((payment) {
      final matchesSearch = _searchQuery.isEmpty ||
        (payment['transactionId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (payment['senderId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (payment['receiverId'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'All' || (payment['status'] ?? '') == _statusFilter;
      final matchesMethod = _methodFilter == 'All' || (payment['paymentMethod'] ?? '') == _methodFilter;
      return matchesSearch && matchesStatus && matchesMethod;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPayments,
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
                      hintText: 'Search by Transaction ID, Sender, or Receiver',
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
                DropdownButton<String>(
                  value: _methodFilter,
                  items: _methodOptions.map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method[0].toUpperCase() + method.substring(1)),
                  )).toList(),
                  onChanged: (val) => setState(() => _methodFilter = val ?? 'All'),
                  hint: const Text('Method'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment'),
                  onPressed: () => _createOrEditPayment(),
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
                              header: const Text  ('Payments'),
                              columns: const [
                                DataColumn(label: Text('Transaction ID')),
                                DataColumn(label: Text('Sender')),
                                DataColumn(label: Text('Receiver')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Payment Method')),
                                DataColumn(label: Text('Paid At')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Created At')),
                                DataColumn(label: Text('Updated At')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _PaymentsDataSource(
                                filteredPayments,
                                context: context,
                                onEdit: (payment) => _createOrEditPayment(payment: payment),
                                onDelete: (transactionId) => _deletePayment(transactionId),
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

class _PaymentsDataSource extends DataTableSource {
  final List<Map<String, dynamic>> payments;
  final BuildContext context;
  final void Function(Map<String, dynamic> payment) onEdit;
  final void Function(String transactionId) onDelete;

  _PaymentsDataSource(this.payments, {required this.context, required this.onEdit, required this.onDelete});

  @override
  DataRow getRow(int index) {
    final payment = payments[index];
    final amount = payment['amount'] ?? '';
    final currency = amount is num ? NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount) : amount.toString();
    final paidAt = payment['paid_at'] ?? '';
    final createdAt = payment['created_at'] ?? '';
    final updatedAt = payment['updated_at'] ?? '';
    Color statusColor;
    switch (payment['status']) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'failed':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(payment['transactionId'] ?? '')),
        DataCell(Text(payment['senderId'] ?? '')),
        DataCell(Text(payment['receiverId'] ?? '')),
        DataCell(Text(currency)),
        DataCell(Text(payment['paymentMethod'] ?? '')),
        DataCell(Text(_formatDate(paidAt))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            payment['status'] ?? '',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        )),
        DataCell(Text(_formatDate(createdAt))),
        DataCell(Text(_formatDate(updatedAt))),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(payment),
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
                        Text('Delete Payment'),
                      ],
                    ),
                    content: const Text('Are you sure you want to delete this payment? This action cannot be undone.'),
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
                  onDelete(payment['transactionId']);
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
  int get rowCount => payments.length;
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

class _PaymentFormDialog extends StatefulWidget {
  final Map<String, dynamic>? payment;
  const _PaymentFormDialog({this.payment});

  @override
  State<_PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<_PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _senderIdController;
  late TextEditingController _receiverIdController;
  late TextEditingController _amountController;
  late TextEditingController _paymentMethodController;
  late TextEditingController _transactionIdController;
  late TextEditingController _paidAtController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _senderIdController = TextEditingController(text: widget.payment?['senderId'] ?? '');
    _receiverIdController = TextEditingController(text: widget.payment?['receiverId'] ?? '');
    _amountController = TextEditingController(text: widget.payment?['amount']?.toString() ?? '');
    _paymentMethodController = TextEditingController(text: widget.payment?['paymentMethod'] ?? '');
    _transactionIdController = TextEditingController(text: widget.payment?['transactionId'] ?? '');
    _paidAtController = TextEditingController(text: widget.payment?['paid_at'] ?? '');
    _statusController = TextEditingController(text: widget.payment?['status'] ?? 'pending');
  }

  @override
  void dispose() {
    _senderIdController.dispose();
    _receiverIdController.dispose();
    _amountController.dispose();
    _paymentMethodController.dispose();
    _transactionIdController.dispose();
    _paidAtController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'senderId': _senderIdController.text.trim(),
      'receiverId': _receiverIdController.text.trim(),
      'amount': _amountController.text.trim(),
      'paymentMethod': _paymentMethodController.text.trim(),
      'transactionId': _transactionIdController.text.trim(),
      'paid_at': _paidAtController.text.trim(),
      'status': _statusController.text.trim(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.payment == null ? 'Add Payment' : 'Edit Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _senderIdController,
                decoration: const InputDecoration(labelText: 'Sender ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter sender ID' : null,
              ),
              TextFormField(
                controller: _receiverIdController,
                decoration: const InputDecoration(labelText: 'Receiver ID'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter receiver ID' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter amount' : null,
              ),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter payment method' : null,
              ),
              TextFormField(
                controller: _transactionIdController,
                decoration: const InputDecoration(labelText: 'Transaction ID (optional)'),
              ),
              TextFormField(
                controller: _paidAtController,
                decoration: const InputDecoration(labelText: 'Paid At (optional)'),
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