import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? chipLabel;

  const SectionHeader({
    Key? key,
    required this.title,
    this.chipLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (chipLabel != null) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              chipLabel!,
              style: const TextStyle(
                color: Color(0xFF2D9B88),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ],
    );
  }
} 