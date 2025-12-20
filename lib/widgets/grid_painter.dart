import 'package:flutter/material.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';

class GridPainter extends CustomPainter {
  final double opacity;
  final double spacing;
  final Color? color;

  GridPainter({
    this.opacity = 0.05,
    this.spacing = 40.0,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (color ?? AppColors.primary).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.opacity != opacity || oldDelegate.spacing != spacing;
  }
}
