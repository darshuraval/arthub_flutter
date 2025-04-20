import 'package:flutter/material.dart';

class PaymentOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const PaymentOptionTile({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: icon != null
          ? Icon(
              icon,
              color: isSelected ? const Color(0xFF2A9D8F) : Colors.grey,
              size: 24,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFF2A9D8F) : Colors.black87,
        ),
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF2A9D8F) : Colors.grey,
            width: 2,
          ),
        ),
        child: isSelected
            ? Container(
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2A9D8F),
                ),
              )
            : null,
      ),
    );
  }
} 