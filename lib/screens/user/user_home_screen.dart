import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/product_service.dart';
import 'package:arthub_flutter/screens/user/category_products_screen.dart';
import 'package:arthub_flutter/screens/user/browse_screen.dart';
import 'package:arthub_flutter/screens/user/my_store_screen.dart';
import 'package:arthub_flutter/screens/user/order_history_screen.dart';
import 'package:arthub_flutter/screens/user/profile_screen.dart';
import 'package:arthub_flutter/screens/user/product_details_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  final List<Map<String, String>> _categories = [
    {'name': 'Culture', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.pngs'},
    {'name': 'Mughal', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png'},
    {'name': 'Still Life', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//stillLife.jpg'},
    {'name': 'WildLife', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//stillLife.jpg'},
    {'name': 'Persian', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//persian.webp'},
    {'name': 'Landscape', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//landscape.jpg'},
    {'name': 'Folk', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//Folk.webp'},
    {'name': 'Hindu', 'image': 'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//Hindu.jpeg'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await _productService.getAllProducts();
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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for art, products... ',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 16,
                      top: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'READY TO DELIVER TO\nYOUR HOME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF21967A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {},
                            child: Text('START SHOPPING'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextButton(onPressed: () {}, child: Text('See All')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(_categories.length, (index) {
                    final cat = _categories[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(categoryName: cat['name']!),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              cat['image']!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF21967A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                cat['name']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextButton(onPressed: () {}, child: Text('See All')),
                ],
              ),
              SizedBox(
                height: 210,
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        separatorBuilder: (_, __) => SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return Container(
                            width: 160,
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
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
