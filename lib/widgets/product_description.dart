import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  final String description;
  const ProductDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
    );
  }
} 