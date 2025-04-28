import 'package:flutter/material.dart';

class ArtistInfoRow extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback? onFollow;

  const ArtistInfoRow({
    Key? key,
    required this.name,
    this.avatarUrl,
    this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF2D9B88),
          child: Text(name.isNotEmpty ? name[0] : ''),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: onFollow,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D9B88),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Follow'),
        ),
      ],
    );
  }
} 