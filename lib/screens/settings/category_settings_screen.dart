import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';

class CategorySettingsScreen extends StatefulWidget {
  const CategorySettingsScreen({Key? key}) : super(key: key);

  @override
  State<CategorySettingsScreen> createState() => _CategorySettingsScreenState();
}

class _CategorySettingsScreenState extends State<CategorySettingsScreen> {
  final List<Map<String, dynamic>> allCategories = [
    {'id': 1, 'name': 'Culture', 'image': 'assets/images/categories/culture.jpg'},
    {'id': 2, 'name': 'Mughal', 'image': 'assets/images/categories/mughal.jpg'},
    {'id': 3, 'name': 'Still Life', 'image': 'assets/images/categories/still_life.jpg'},
    {'id': 4, 'name': 'Wildlife', 'image': 'assets/images/categories/wildlife.jpg'},
    {'id': 5, 'name': 'Persian', 'image': 'assets/images/categories/persian.jpg'},
    {'id': 6, 'name': 'Landscape', 'image': 'assets/images/categories/landscape.jpg'},
    {'id': 7, 'name': 'Folk', 'image': 'assets/images/categories/folk.jpg'},
    {'id': 8, 'name': 'Hindu', 'image': 'assets/images/categories/hindu.jpg'},
    {'id': 9, 'name': 'Modern', 'image': 'assets/images/categories/modern.jpg'},
    {'id': 10, 'name': 'Abstract', 'image': 'assets/images/categories/abstract.jpg'},
    {'id': 11, 'name': 'Portrait', 'image': 'assets/images/categories/portrait.jpg'},
    {'id': 12, 'name': 'Religious', 'image': 'assets/images/categories/religious.jpg'},
    {'id': 13, 'name': 'Contemporary', 'image': 'assets/images/categories/contemporary.jpg'},
    {'id': 14, 'name': 'Traditional', 'image': 'assets/images/categories/traditional.jpg'},
    {'id': 15, 'name': 'Digital', 'image': 'assets/images/categories/digital.jpg'},
  ];

  Set<int> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose between 2 and 8 categories to display on your home screen',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedCategories.length < 2 || selectedCategories.length > 8
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${selectedCategories.length} categories selected',
                    style: TextStyle(
                      color: selectedCategories.length < 2 || selectedCategories.length > 8
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allCategories.length,
              itemBuilder: (context, index) {
                final category = allCategories[index];
                final isSelected = selectedCategories.contains(category['id']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppStyles.primaryColor : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategories.remove(category['id']);
                        } else if (selectedCategories.length < 8) {
                          selectedCategories.add(category['id']);
                        }
                      });
                    },
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(category['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      category['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: AppStyles.primaryColor,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: Colors.grey[400],
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: selectedCategories.length >= 2 && selectedCategories.length <= 8
              ? () {
                  // Save selected categories and pop
                  Navigator.pop(context, selectedCategories.toList());
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
} 