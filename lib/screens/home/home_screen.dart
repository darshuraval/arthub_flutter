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
                      'See All',
                      style: TextStyle(
                        color: AppStyles.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryCard(
                    title: 'Culture',
                    imageUrl: 'assets/images/categories/culture.jpg',
                    onTap: () {},
                    width: MediaQuery.of(context).size.width / 2 - 24,
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Mughal',
                    imageUrl: 'assets/images/categories/mughal.jpg',
                    onTap: () {},
                    width: MediaQuery.of(context).size.width / 2 - 24,
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Still Life',
                    imageUrl: 'assets/images/categories/still_life.jpg',
                    onTap: () {},
                    width: MediaQuery.of(context).size.width / 2 - 24,
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Wildlife',
                    imageUrl: 'assets/images/categories/wildlife.jpg',
                    onTap: () {},
                    width: MediaQuery.of(context).size.width / 2 - 24,
                  ),
                ],
              ),
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
                      'See All',
                      style: TextStyle(
                        color: AppStyles.primaryColor,
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
