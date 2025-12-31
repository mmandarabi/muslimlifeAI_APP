import 'package:flutter/material.dart';
import '../../services/mushaf_coordinate_service.dart';

/// Simple painter that draws highlight rectangles over active ayahs
/// Works as an overlay on top of existing Text widgets
class AyahHighlightPainter extends CustomPainter {
  final List<MushafHighlight> highlights;
  final int? activeSurah;
  final int? activeAyah;
  final int? activeWordIndex; // 🆕 Word-level Sync
  final Color highlightColor;
  final double opacity;

  AyahHighlightPainter({
    required this.highlights,
    this.activeSurah,
    this.activeAyah,
    this.activeWordIndex,
    required this.highlightColor,
    this.opacity = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (activeSurah == null || activeAyah == null) return;

    final paint = Paint()
      ..color = highlightColor.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    // Draw highlight rectangles for active ayah
    for (var highlight in highlights) {
      if (highlight.surah == activeSurah && highlight.ayah == activeAyah) {
        // 🆕 WORD SYNC: If word index is active, only paint that specific word
        if (activeWordIndex != null) {
          if (highlight.wordIndex == activeWordIndex) {
            canvas.drawRect(highlight.rect, paint);
          }
        } else {
          // Fallback: Paint entire ayah (all words)
          canvas.drawRect(highlight.rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(AyahHighlightPainter oldDelegate) {
    return oldDelegate.activeSurah != activeSurah ||
           oldDelegate.activeAyah != activeAyah ||
           oldDelegate.activeWordIndex != activeWordIndex ||
           oldDelegate.highlightColor != highlightColor;
  }
}
