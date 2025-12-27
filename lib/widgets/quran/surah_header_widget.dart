import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class SurahHeaderWidget extends StatelessWidget {
  final int surahId;
  final String surahNameArabic;
  final String surahNameEnglish;

  const SurahHeaderWidget({
    super.key,
    required this.surahId,
    required this.surahNameArabic,
    required this.surahNameEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accent;
    final textColor = AppColors.getTextPrimary(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      height: 80, // Reduced height for better page proportion
      decoration: BoxDecoration(
        color: const Color(0xFF202124), // Raisin Black Base fallback
        image: const DecorationImage(
          image: AssetImage('assets/images/surah_header_bg2.gif'),
          fit: BoxFit.cover,
          opacity: 0.9, // Slight darkening to ensure text pop
        ),
        border: Border.symmetric(
          horizontal: BorderSide(color: gold.withOpacity(0.15), width: 0.8),
        ),
      ),
      child: Stack(
        children: [
          // 1. Procedural Filigree Layer
          Positioned.fill(
            child: CustomPaint(
              painter: OrnateSurahHeaderPainter(
                color: gold.withOpacity(0.15),
              ),
            ),
          ),
          
          // 2. Text Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  surahNameArabic,
                  style: TextStyle(
                    fontFamily: 'KFGQPCUthmanic',
                    fontSize: 28,
                    color: gold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  surahNameEnglish,
                  style: GoogleFonts.outfit(
                    fontSize: 11, // Reduced from 14
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrnateSurahHeaderPainter extends CustomPainter {
  final Color color;

  OrnateSurahHeaderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // A. The Main Ornate Frame (Structured Borders)
    final framePath = Path();
    const inset = 6.0;
    
    // Top & Bottom Double Lines
    canvas.drawLine(const Offset(inset * 2, inset), Offset(size.width - inset * 2, inset), paint);
    canvas.drawLine(const Offset(inset * 2, inset + 3), Offset(size.width - inset * 2, inset + 3), paint..strokeWidth = 0.4);
    
    canvas.drawLine(Offset(inset * 2, size.height - inset), Offset(size.width - inset * 2, size.height - inset), paint..strokeWidth = 0.8);
    canvas.drawLine(Offset(inset * 2, size.height - inset - 3), Offset(size.width - inset * 2, size.height - inset - 3), paint..strokeWidth = 0.4);

    // B. Filigree Corners (Abstract curves matching the screenshot)
    _drawCornerFiligree(canvas, size, color);

    // D. Decorative Left/Right End-Caps
    _drawEndCaps(canvas, size, paint);
  }

  void _drawCornerFiligree(Canvas canvas, Size size, Color color) {
     final p = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 0.8;
     const r = 24.0;
     const inset = 6.0;

     // Top Left
     canvas.drawArc(Rect.fromLTWH(inset, inset, r, r), 3.14, 1.57, false, p);
     // Top Right
     canvas.drawArc(Rect.fromLTWH(size.width - inset - r, inset, r, r), -1.57, 1.57, false, p);
     // Bottom Left
     canvas.drawArc(Rect.fromLTWH(inset, size.height - inset - r, r, r), 1.57, 1.57, false, p);
     // Bottom Right
     canvas.drawArc(Rect.fromLTWH(size.width - inset - r, size.height - inset - r, r, r), 0, 1.57, false, p);
  }

  void _drawEndCaps(Canvas canvas, Size size, Paint paint) {
     const capWidth = 10.0;
     const inset = 6.0;
     
     // Left Cap
     final leftPath = Path();
     leftPath.moveTo(inset, inset + 10);
     leftPath.lineTo(inset + capWidth, inset);
     leftPath.lineTo(inset + capWidth, size.height - inset);
     leftPath.lineTo(inset, size.height - inset - 10);
     canvas.drawPath(leftPath, paint);

     // Right Cap
     final rightPath = Path();
     rightPath.moveTo(size.width - inset, inset + 10);
     rightPath.lineTo(size.width - inset - capWidth, inset);
     rightPath.lineTo(size.width - inset - capWidth, size.height - inset);
     rightPath.lineTo(size.width - inset, size.height - inset - 10);
     canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
