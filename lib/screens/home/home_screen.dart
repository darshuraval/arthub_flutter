import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/custom_search_bar.dart';
import 'package:arthub_flutter/widgets/home_banner.dart';
import 'package:arthub_flutter/widgets/category_card.dart';
import 'package:arthub_flutter/widgets/product_card.dart';
import 'package:arthub_flutter/models/settings_model.dart';
import 'package:arthub_flutter/utils/sample_data.dart';
import 'package:arthub_flutter/screens/product_details/product_details_screen.dart';
import 'package:arthub_flutter/screens/category/all_categories_screen.dart';
import 'package:arthub_flutter/screens/category/category_products_screen.dart';
import 'package:arthub_flutter/screens/cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;
  
  const HomeScreen({
    Key? key,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the first 4 products for preview
    final previewProducts = SampleData.products.take(4).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Arts',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: AppStyles.primaryColor,
              child: const CustomSearchBar(),
            ),
            
            // Banner
            HomeBanner(
              backgroundImages: const [
                'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
                'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
              ],
              onTap: () => onTabChange(1),
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllCategoriesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: AppStyles.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<SettingsModel>(
              builder: (context, settings, child) {
                final displayCategories = SampleData.categories.where(
                  (category) => settings.isCategorySelected(category['title']!)
                ).toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: displayCategories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: displayCategories[index]['title']!,
                      imageUrl: displayCategories[index]['image']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              category: displayCategories[index]['title']!,
                              imageUrl: displayCategories[index]['image']!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            // New Products
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onTabChange(1), // Switch to browse tab
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: AppStyles.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: previewProducts.length,
              itemBuilder: (context, index) {
                final product = previewProducts[index];
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
