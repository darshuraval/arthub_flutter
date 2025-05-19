import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/coupon_service.dart';

class CouponsScreen extends StatefulWidget {
  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final CouponService _couponService = CouponService();
  List<Map<String, dynamic>> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() => _isLoading = true);
    final coupons = await _couponService.getAllCoupons();
    setState(() {
      _coupons = coupons;
      _isLoading = false;
    });
  }

  Future<void> _createOrEditCoupon({Map<String, dynamic>? coupon}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _CouponFormDialog(coupon: coupon),
    );
    if (result != null) {
      try {
        if (coupon == null) {
          await _couponService.createCoupon(
            couponCode: result['couponCode'],
            couponType: result['couponType'],
            discount: double.parse(result['discount']),
            userId: result['userId'],
          );
        } else {
          await _couponService.updateCoupon(
            coupon['couponId'],
            result,
          );
        }
        await _loadCoupons();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(coupon == null ? 'Coupon created' : 'Coupon updated')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save coupon: $e')),
        );
      }
    }
  }

  Future<void> _deleteCoupon(String couponId) async {
    try {
      await _couponService.deleteCoupon(couponId);
      await _loadCoupons();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete coupon: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Coupons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createOrEditCoupon(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _coupons.length,
              itemBuilder: (context, index) {
                final coupon = _coupons[index];
                return ListTile(
                  title: Text(coupon['couponCode']),
                  subtitle: Text('Type: ${coupon['couponType']} - Discount: ${coupon['discount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _createOrEditCoupon(coupon: coupon),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCoupon(coupon['couponId']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _CouponFormDialog extends StatefulWidget {
  final Map<String, dynamic>? coupon;

  _CouponFormDialog({this.coupon});

  @override
  _CouponFormDialogState createState() => _CouponFormDialogState();
}

class _CouponFormDialogState extends State<_CouponFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _couponCodeController;
  late TextEditingController _discountController;
  late TextEditingController _userIdController;
  String _couponType = 'percent';

  @override
  void initState() {
    super.initState();
    _couponCodeController = TextEditingController(text: widget.coupon?['couponCode'] ?? '');
    _couponType = widget.coupon?['couponType'] ?? 'percent';
    _discountController = TextEditingController(text: widget.coupon?['discount']?.toString() ?? '');
    _userIdController = TextEditingController(text: widget.coupon?['userId'] ?? '');
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    _discountController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'couponCode': _couponCodeController.text.trim(),
      'couponType': _couponType,
      'discount': _discountController.text.trim(),
      'userId': _userIdController.text.trim(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.coupon == null ? 'Add Coupon' : 'Edit Coupon'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _couponCodeController,
                decoration: const InputDecoration(labelText: 'Coupon Code'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter coupon code' : null,
              ),
              DropdownButtonFormField<String>(
                value: _couponType,
                items: const [
                  DropdownMenuItem(value: 'percent', child: Text('Percent')),
                  DropdownMenuItem(value: 'amount', child: Text('Amount')),
                ],
                onChanged: (value) {
                  setState(() {
                    _couponType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Coupon Type'),
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter discount' : null,
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID (optional)'),
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