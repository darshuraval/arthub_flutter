import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/product_service.dart';
import 'package:arthub_flutter/screens/user/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  const CategoryProductsScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    final products = await _productService.getProductsByCategory(widget.categoryName);
    setState(() {
      _products = products;
      _loading = false;
    });
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
        centerTitle: true,
        title: Text(widget.categoryName, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                _buildFilterChip(Icons.sort, 'Sort by'),
                SizedBox(width: 8),
                _buildFilterChip(Icons.person, 'Artist'),
                SizedBox(width: 8),
                _buildFilterChip(Icons.dashboard_customize, 'Material'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final p = _products[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 4),
                          child: Material(
                              color: Colors.transparent, 
                              child: InkWell(
                                onTap: () {
                                  print('Tapped!');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(product: p),
                                    ),
                                  );
                                },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(
                                      p['productImage'] ?? 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                      height: 240,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // If network image fails, show asset image
                                        return Image.network(
                                          'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                          height: 240,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            // If asset image fails, show the default network placeholder
                                            return Image.network(
                                              'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                              height: 240,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['productName'] ?? '',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            if (p['oldPrice'] != null && p['oldPrice'] > 0)
                                              Text(
                                                '\u20B9${p['oldPrice'].toString()}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            if (p['oldPrice'] != null && p['oldPrice'] > 0) SizedBox(width: 6),
                                            Text(
                                              '\u20B9${p['price']?.toStringAsFixed(2) ?? '--'}',
                                              style: TextStyle(
                                                color: Color(0xFF21967A),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
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
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: BorderSide(color: Color(0xFF21967A)),
        foregroundColor: Color(0xFF21967A),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        textStyle: TextStyle(fontSize: 14),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
