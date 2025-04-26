import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const ProfileMenuItem({
    Key? key,
    required this.label,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.black87,
            fontWeight: label == 'Logout' ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 