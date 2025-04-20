import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/models/cart_model.dart';
import 'package:arthub_flutter/models/product_model.dart';
import 'package:arthub_flutter/screens/checkout/checkout_screen.dart';
import 'package:arthub_flutter/utils/sample_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // For demo purposes, we'll use a simple list of cart items
  // In a real app, this would come from a provider or database
  late List<CartItem> _cartItems;
  
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }
  
  void _loadCartItems() {
    // For demo, we'll add some sample products to the cart
    setState(() {
      _cartItems = [
        CartItem(
          id: '1',
          product: SampleData.products[0],
          quantity: 1,
          addedAt: DateTime.now(),
        ),
        CartItem(
          id: '2',
          product: SampleData.products[1],
          quantity: 2,
          addedAt: DateTime.now(),
        ),
      ];
    });
  }
  
  void _updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(item);
      return;
    }
    
    setState(() {
      final index = _cartItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _cartItems[index] = CartItem(
          id: item.id,
          product: item.product,
          quantity: newQuantity,
          addedAt: item.addedAt,
        );
      }
    });
  }
  
  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.removeWhere((i) => i.id == item.id);
    });
  }
  
  double _calculateSubtotal() {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }
  
  double _calculateShipping() {
    return 10.0; // Fixed shipping cost for demo
  }
  
  double _calculateTax() {
    return _calculateSubtotal() * 0.1; // 10% tax
  }
  
  double _calculateTotal() {
    return _calculateSubtotal() + _calculateShipping() + _calculateTax();
  }
  
  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }
    
    final cart = CartModel(
      userId: 'user1', // TODO: Get from auth provider
      items: _cartItems,
      lastUpdated: DateTime.now(),
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.images[0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${(item.product.discountedPrice ?? 0.0).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyles.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Quantity Controls
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => _updateQuantity(
                                            item,
                                            item.quantity - 1,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => _updateQuantity(
                                            item,
                                            item.quantity + 1,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Remove Button
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _removeItem(item),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Order Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', '\$${_calculateSubtotal().toStringAsFixed(2)}'),
                      _buildSummaryRow('Shipping', '\$${_calculateShipping().toStringAsFixed(2)}'),
                      _buildSummaryRow('Tax', '\$${_calculateTax().toStringAsFixed(2)}'),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Total',
                        '\$${_calculateTotal().toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _proceedToCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppStyles.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
} 