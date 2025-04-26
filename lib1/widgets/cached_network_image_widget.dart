import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final Color placeholderColor;
  final Widget? errorWidget;

  const CachedNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = 8.0,
    this.placeholderColor = const Color(0xFFE0E0E0),
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: placeholderColor,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => errorWidget ?? Container(
          width: width,
          height: height,
          color: placeholderColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.error_outline,
                color: Colors.grey,
                size: 24,
              ),
              SizedBox(height: 4),
              Text(
                'Image not available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 