import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/splash/splash_screen.dart';
import 'package:arthub_flutter/screens/home/home_screen.dart';
import 'package:arthub_flutter/screens/add_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2D9B88),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2D9B88),
          secondary: const Color(0xFF2D9B88),
        ),
      ),
      // home: const SplashScreen(),
      home: const HomeScreen(),
      // home: const AddProductScreen(),
    );
  }
}