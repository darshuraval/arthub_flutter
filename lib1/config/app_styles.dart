import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFF2D9B88);
  static const Color backgroundColor = Color(0xFF2D9B88);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;

  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColorPrimary,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: textColorSecondary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static BorderRadius borderRadius = BorderRadius.circular(30);

  static const EdgeInsets screenPadding = EdgeInsets.all(20.0);

  static InputDecoration textFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }
} 