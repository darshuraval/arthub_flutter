import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/custom_search_bar.dart';
import 'package:arthub_flutter/widgets/home_banner.dart';
import 'package:arthub_flutter/widgets/category_card.dart';
import 'package:arthub_flutter/widgets/product_card.dart';
import 'package:arthub_flutter/models/settings_model.dart';
import 'package:arthub_flutter/utils/sample_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
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
                'https://example.com/art1.jpg',
                'https://example.com/art2.jpg',
              ],
              onTap: () {},
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
                    onPressed: () {},
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
                      onTap: () {},
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
                    onPressed: () {},
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
              itemCount: SampleData.products.length,
              itemBuilder: (context, index) {
                final product = SampleData.products[index];
                return ProductCard(
                  imageUrl: product['image'] as String,
                  title: product['title'] as String,
                  originalPrice: product['originalPrice'] as double,
                  discountedPrice: product['discountedPrice'] as double?,
                  onTap: () {},
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
