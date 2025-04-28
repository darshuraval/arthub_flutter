import 'package:flutter/material.dart';

class CreditCardCarouselIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const CreditCardCarouselIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? const Color(0xFF2D9B88)
                : Colors.grey[300],
          ),
        );
      }),
    );
  }
} 