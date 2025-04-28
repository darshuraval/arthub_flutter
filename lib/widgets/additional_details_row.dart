import 'package:flutter/material.dart';

class AdditionalDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  const AdditionalDetailsRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.black87, fontSize: 15),
        ),
      ],
    );
  }
} 