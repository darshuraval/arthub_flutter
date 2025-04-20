import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

class ImageUploadBox extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final String? resolution;
  final double size;

  const ImageUploadBox({
    Key? key,
    this.image,
    required this.onTap,
    this.onDelete,
    this.resolution,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: Colors.grey[300]!,
            strokeWidth: 1,
            gap: 5,
          ),
          child: image != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (onDelete != null)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    if (resolution != null)
                      Text(
                        resolution!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5;
    final double dashSpace = gap;
    final double x = size.width;
    final double y = size.height;
    final radius = 10.0;

    Path path = Path();
    
    // Top left corner
    path.moveTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    
    // Top edge
    for (double i = radius; i < x - radius; i += dashWidth + dashSpace) {
      path.moveTo(i, 0);
      path.lineTo(math.min(i + dashWidth, x - radius), 0);
    }
    
    // Top right corner
    path.moveTo(x - radius, 0);
    path.arcToPoint(Offset(x, radius), radius: Radius.circular(radius));
    
    // Right edge
    for (double i = radius; i < y - radius; i += dashWidth + dashSpace) {
      path.moveTo(x, i);
      path.lineTo(x, math.min(i + dashWidth, y - radius));
    }
    
    // Bottom right corner
    path.moveTo(x, y - radius);
    path.arcToPoint(Offset(x - radius, y), radius: Radius.circular(radius));
    
    // Bottom edge
    for (double i = x - radius; i > radius; i -= dashWidth + dashSpace) {
      path.moveTo(i, y);
      path.lineTo(math.max(i - dashWidth, radius), y);
    }
    
    // Bottom left corner
    path.moveTo(radius, y);
    path.arcToPoint(Offset(0, y - radius), radius: Radius.circular(radius));
    
    // Left edge
    for (double i = y - radius; i > radius; i -= dashWidth + dashSpace) {
      path.moveTo(0, i);
      path.lineTo(0, math.max(i - dashWidth, radius));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 