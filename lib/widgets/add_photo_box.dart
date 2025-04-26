import 'package:flutter/material.dart';

class AddPhotoBox extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const AddPhotoBox({
    Key? key,
    this.imageUrl,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!, width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 32, color: Colors.grey),
            SizedBox(height: 4),
            Text('Add', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 2),
            Text('1600 x 1200 for hi res', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 