import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder UI. You can connect it to your favorite products data later.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No favorites yet!', style: TextStyle(fontSize: 20, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Your favorite products will appear here.'),
          ],
        ),
      ),
    );
  }
}
