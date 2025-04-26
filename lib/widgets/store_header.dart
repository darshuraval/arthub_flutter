import 'package:flutter/material.dart';

class StoreHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onView;

  const StoreHeader({
    Key? key,
    required this.name,
    this.avatarUrl,
    this.onEdit,
    this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: const Color(0xFFE0F2EF),
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '',
                  style: const TextStyle(fontSize: 32, color: Color(0xFF2D9B88)),
                )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: onEdit,
              child: const Text('Edit Store'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D9B88),
                foregroundColor: Colors.white,
              ),
              child: const Text('View Store'),
            ),
          ],
        ),
      ],
    );
  }
} 