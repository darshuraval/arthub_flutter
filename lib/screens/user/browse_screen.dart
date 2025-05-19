import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/product_service.dart';
import 'package:arthub_flutter/screens/user/product_details_screen.dart';

class BrowseScreen extends StatefulWidget {
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}
class _BrowseScreenState extends State<BrowseScreen> {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String? _error;

  String _sortOption = 'Name Asc';
  String? _selectedCategory;
  String? _selectedShop;
  String _searchQuery = '';

  List<String> get _categories => _products
      .map((p) => p['category']?.toString() ?? '')
      .where((c) => c.isNotEmpty)
      .toSet()
      .toList();
  List<String> get _shops => _products
      .map((p) => p['shop']?.toString() ?? '')
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList();

  List<Map<String, dynamic>> get _filteredSortedProducts {
    List<Map<String, dynamic>> filtered = List.from(_products);
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered.where((p) => p['category'] == _selectedCategory).toList();
    }
    if (_selectedShop != null && _selectedShop!.isNotEmpty) {
      filtered = filtered.where((p) => p['shop'] == _selectedShop).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
        (p['productName'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    switch (_sortOption) {
      case 'Name Asc':
        filtered.sort((a, b) => (a['productName'] ?? '').compareTo(b['productName'] ?? ''));
        break;
      case 'Name Desc':
        filtered.sort((a, b) => (b['productName'] ?? '').compareTo(a['productName'] ?? ''));
        break;
      case 'Price Low-High':
        filtered.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'Price High-Low':
        filtered.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
    }
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    try {
      final products = await _productService.getAllProducts();
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF6F6F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8), 
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Product',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: TextStyle(fontSize: 16),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _sortOption,
                  items: [
                    DropdownMenuItem(value: 'Name Asc', child: Text('Name Asc')),
                    DropdownMenuItem(value: 'Name Desc', child: Text('Name Desc')),
                    DropdownMenuItem(value: 'Price Low-High', child: Text('Price Low-High')),
                    DropdownMenuItem(value: 'Price High-Low', child: Text('Price High-Low')),
                  ],
                  onChanged: (val) {
                    setState(() => _sortOption = val!);
                  },
                  underline: Container(),
                  style: TextStyle(color: Color(0xFF21967A), fontWeight: FontWeight.bold),
                  icon: Icon(Icons.sort, color: Color(0xFF21967A)),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: Text('Category'),
                  items: [
                    DropdownMenuItem(value: null, child: Text('All Categories')),
                    ..._categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedCategory = val);
                  },
                  underline: Container(),
                  style: TextStyle(color: Color(0xFF21967A)),
                  icon: Icon(Icons.category_outlined, color: Color(0xFF21967A)),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedShop,
                  hint: Text('Shop'),
                  items: [
                    DropdownMenuItem(value: null, child: Text('All Shops')),
                    ..._shops.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedShop = val);
                  },
                  underline: Container(),
                  style: TextStyle(color: Color(0xFF21967A)),
                  icon: Icon(Icons.storefront, color: Color(0xFF21967A)),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: $_error'))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filteredSortedProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = _filteredSortedProducts[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            child: Material(
                              color: Colors.transparent, 
                              child: InkWell(
                                onTap: () {
                                  print('Tapped!');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(product: product),
                                    ),
                                  );
                                },
                            child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.network(
                                        product['productImage'] ?? 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.network(
                                            'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.network(
                                                'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                                height: 120,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['productName'] ?? '',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            product['artist'] ?? '',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '\u20B9${product['price']?.toStringAsFixed(2) ?? '--'}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF21967A)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}




class _FilterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  const _FilterButton({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: BorderSide(color: Color(0xFF21967A)),
        foregroundColor: Color(0xFF21967A),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(text),
    );
  }
}