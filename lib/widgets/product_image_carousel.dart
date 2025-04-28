import 'package:flutter/material.dart';
import 'credit_card_carousel_indicator.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final int currentIndex;
  final void Function(int)? onPageChanged;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;

  const ProductImageCarousel({
    Key? key,
    required this.imageUrls,
    this.currentIndex = 0,
    this.onPageChanged,
    this.onBack,
    this.onShare,
    this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrls[currentIndex],
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 16,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white70,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBack,
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: onShare,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: onFavorite,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: CreditCardCarouselIndicator(
            count: imageUrls.length,
            currentIndex: currentIndex,
          ),
        ),
      ],
    );
  }
} 