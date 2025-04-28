import 'package:flutter/material.dart';

class ProductDetailsTable extends StatelessWidget {
  final Map<String, String> details;
  const ProductDetailsTable({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth()},
      children: details.entries.map((e) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                e.key,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                e.value,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
} 