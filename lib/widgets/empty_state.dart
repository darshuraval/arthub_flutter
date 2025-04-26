import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    Key? key,
    required this.message,
    required this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: onButtonPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2D9B88),
            side: const BorderSide(color: Color(0xFF2D9B88)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }
} 