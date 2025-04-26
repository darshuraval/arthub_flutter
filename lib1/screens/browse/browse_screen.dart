import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/product_card.dart';
import 'package:arthub_flutter/utils/sample_data.dart';
import 'package:arthub_flutter/screens/product_details/product_details_screen.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Text(
                'Browse',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Product',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildFilterButton('Sort by', Icons.sort),
                          const SizedBox(width: 8),
                          _buildFilterButton('Artist', Icons.person_outline),
                          const SizedBox(width: 8),
                          _buildFilterButton('Material', Icons.category_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: SampleData.products.length,
                        itemBuilder: (context, index) {
                          final product = SampleData.products[index];
                          return ProductCard(
                            imageUrl: product.images[0],
                            title: product.title,
                            originalPrice: product.originalPrice,
                            discountedPrice: product.discountedPrice,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 