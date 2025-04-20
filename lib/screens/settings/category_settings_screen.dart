import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/models/settings_model.dart';

class CategorySettingsScreen extends StatelessWidget {
  const CategorySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> allCategories = [
      {'title': 'Culture', 'image': 'https://example.com/images/culture.jpg'},
      {'title': 'Mughal', 'image': 'https://example.com/images/mughal.jpg'},
      {'title': 'Still Life', 'image': 'https://example.com/images/still_life.jpg'},
      {'title': 'Wildlife', 'image': 'https://example.com/images/wildlife.jpg'},
      {'title': 'Persian', 'image': 'https://example.com/images/persian.jpg'},
      {'title': 'Landscape', 'image': 'https://example.com/images/landscape.jpg'},
      {'title': 'Folk', 'image': 'https://example.com/images/folk.jpg'},
      {'title': 'Hindu', 'image': 'https://example.com/images/hindu.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Settings'),
        actions: [
          Consumer<SettingsModel>(
            builder: (context, settings, child) {
              return TextButton(
                onPressed: () => settings.resetToDefault(),
                child: const Text(
                  'Reset to Default',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SettingsModel>(
        builder: (context, settings, child) {
          return ListView.builder(
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              return CheckboxListTile(
                title: Text(category['title']!),
                value: settings.isCategorySelected(category['title']!),
                onChanged: (bool? value) {
                  settings.toggleCategory(category['title']!);
                },
                activeColor: AppStyles.primaryColor,
              );
            },
          );
        },
      ),
    );
  }
} 