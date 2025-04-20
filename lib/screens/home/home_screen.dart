import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/custom_search_bar.dart';
import 'package:arthub_flutter/widgets/home_banner.dart';
import 'package:arthub_flutter/widgets/category_card.dart';
import 'package:arthub_flutter/widgets/product_card.dart';

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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return CategoryCard(
                  title: categories[index]['title']!,
                  imageUrl: categories[index]['image']!,
                  onTap: () {},
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
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ProductCard(
                    imageUrl: 'https://example.com/product1.jpg',
                    title: 'Beautiful Artwork 1',
                    price: 299.99,
                    onTap: () {},
                  ),
                  ProductCard(
                    imageUrl: 'https://example.com/product2.jpg',
                    title: 'Beautiful Artwork 2',
                    price: 399.99,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
