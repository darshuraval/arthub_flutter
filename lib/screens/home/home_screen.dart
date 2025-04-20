import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/custom_search_bar.dart';
import 'package:arthub_flutter/widgets/home_banner.dart';
import 'package:arthub_flutter/widgets/category_card.dart';
import 'package:arthub_flutter/widgets/product_card.dart';
import 'package:arthub_flutter/models/settings_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        'title': 'Culture',
        'image': 'https://example.com/images/culture.jpg',
      },
      {
        'title': 'Mughal',
        'image': 'https://example.com/images/mughal.jpg',
      },
      {
        'title': 'Still Life',
        'image': 'https://example.com/images/still_life.jpg',
      },
      {
        'title': 'WildLife',
        'image': 'https://example.com/images/wildlife.jpg',
      },
      {
        'title': 'Persian',
        'image': 'https://example.com/images/persian.jpg',
      },
      {
        'title': 'Landscape',
        'image': 'https://example.com/images/landscape.jpg',
      },
      {
        'title': 'Folk',
        'image': 'https://example.com/images/folk.jpg',
      },
      {
        'title': 'Hindu',
        'image': 'https://example.com/images/hindu.jpg',
      },
    ];

    final List<Map<String, dynamic>> products = [
      {
        'id': '1',
        'title': 'Beautiful Artwork 1',
        'price': 299.99,
        'image': 'https://example.com/product1.jpg'
      },
      {
        'id': '2',
        'title': 'Beautiful Artwork 2',
        'price': 399.99,
        'image': 'https://example.com/product2.jpg'
      },
    ];

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
                final displayCategories = categories.where(
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  imageUrl: product['image'] as String,
                  title: product['title'] as String,
                  price: product['price'] as double,
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
