
import 'package:flutter/material.dart';
import '../../services/mushaf_coordinate_service.dart';

class MushafPagePainter extends CustomPainter {
  // Reference canvas dimensions from research documents
  // Note: Current database uses 1024x1656, keep for compatibility
  static const double REF_WIDTH = 1024.0;  // From MushafCoordinateService
  static const double REF_HEIGHT = 1656.0; // From MushafCoordinateService

  final List<MushafHighlight> highlights;
  final Map<int, Rect> lineBounds;
  final List<String> textLines;
  final int pageNumber;
  final int? activeSurah;
  final int? activeAyah;
  final int? activeWordIndex; // 🆕 PHASE 2: Word-level highlighting
  final bool debugMode; 
  final Color backgroundColor;
  final Color textColor;
  final double fontScale; 

  // 🛑 PERFORMANCE: Pre-calculated metrics to avoid jank during repaint
  late final List<String> _allTokens;
  late final Map<int, int> _tokenLineMap; // Maps token index → source line number
  late final Map<int, Rect> _lineRects;
  late final double _medianHeight;
  late final double _maxDbRight;

  MushafPagePainter({
    required this.highlights,
    required this.lineBounds,
    required this.textLines,
    required this.pageNumber,
    this.activeSurah,
    this.activeAyah,
    this.activeWordIndex, // 🆕 PHASE 2: Word-level highlighting
    this.debugMode = false, // Default false for production
    required this.backgroundColor,
    required this.textColor,
    this.fontScale = 1.0,
  }) {
    _precomputeMetrics();
  }

  void _precomputeMetrics() {
    // 🔧 FIXED: Flatten all tokens sequentially (ignore text line boundaries)
    // This allows sequential mapping to DB lines regardless of text map structure
    _allTokens = [];
    for (String line in textLines) {
      List<String> lineTokens = line
        .split(' ')
        .where((t) => t.trim().isNotEmpty)
        .where((t) => t != 'None' && t != 'null')  // 🛑 FIX: Filter out None/null values
        .toList();
      _allTokens.addAll(lineTokens);
    }
    
    // No longer need to track which text line each token came from
    _tokenLineMap = {}; // Keep empty for compatibility

    if (highlights.isEmpty) {
      _lineRects = {};
      _medianHeight = 1.0;
      _maxDbRight = 100.0;
      return;
    }

    // 2. Metrics Calculation
    Map<int, List<MushafHighlight>> lineMap = {};
    _lineRects = {};
    List<double> lineHeights = [];
    double globalMaxRight = 0.0;

    // Group & Find Max Right
    for (var h in highlights) {
      if (h.lineNumber > 0 && h.lineNumber <= 15) {
        lineMap.putIfAbsent(h.lineNumber, () => []).add(h);
      }
      if (h.rect.right > globalMaxRight) {
        globalMaxRight = h.rect.right;
      }
    }
    _maxDbRight = globalMaxRight > 0 ? globalMaxRight : 1.0;

    // Line Rects & Heights
    lineMap.forEach((lineNum, tokens) {
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      
      for (var t in tokens) {
        if (t.rect.left < minX) minX = t.rect.left;
        if (t.rect.top < minY) minY = t.rect.top;
        if (t.rect.right > maxX) maxX = t.rect.right;
        if (t.rect.bottom > maxY) maxY = t.rect.bottom;
      }
      
      final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
      _lineRects[lineNum] = rect;
      
      if (rect.height > 2) {
          lineHeights.add(rect.height);
      }
    });

    // Median Height
    if (lineHeights.isNotEmpty) {
      lineHeights.sort();
      _medianHeight = lineHeights[lineHeights.length ~/ 2];
      if (_medianHeight == 0) _medianHeight = 1.0;
    } else {
      _medianHeight = 1.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background
    Paint bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (highlights.isEmpty || _allTokens.isEmpty) return;

    // 🛑 M1: Calculate scale factors using reference canvas
    final double scaleX = size.width / REF_WIDTH;
    final double scaleY = size.height / REF_HEIGHT;
    
    // 🛑 DEBUG: Verify lineBounds on first paint of page 604
    if (pageNumber == 604 && lineBounds.isNotEmpty) {
      final sortedLines = lineBounds.keys.toList()..sort();
      print('=== Page $pageNumber lineBounds (M1 Debug) ===');
      print('Scale: X=$scaleX, Y=$scaleY');
      for (int i = 0; i < sortedLines.length && i < 3; i++) {
        final lineNum = sortedLines[i];
        final bound = lineBounds[lineNum]!;
        print('Line $lineNum: top=${bound.top.toStringAsFixed(1)}, height=${bound.height.toStringAsFixed(1)}');
      }
      print('==========================================');
    }

    final double gridLineHeight = size.height / 15.0;

    // 1. Vertical Fit Scale (Matches Grid Height)
    // Tuner 1.0 for Edge-to-Edge
    final double verticalScale = (gridLineHeight / _medianHeight) * 1.0; 

    // 2. Horizontal Fit Scale (Matches Screen Width)
    // Tuner 1.0 for Edge-to-Edge
    final double horizontalScale = (size.width / _maxDbRight) * 1.0;

    // 3. Final Master Scale (Contain Strategy: Use Minimum to ensure NO clipping)
    final double masterScale = verticalScale < horizontalScale ? verticalScale : horizontalScale;

    // 4. Precision Centering
    // Calculate the actual width the content will take
    final double actualScaledWidth = _maxDbRight * masterScale;
    final double globalXOffset = (size.width - actualScaledWidth) / 2;

    // Setup Paints
    Paint highlightPaint = Paint()
      ..color = const Color(0xff574500).withOpacity(0.15) 
      ..style = PaintingStyle.fill;

    Paint debugPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Render Logic
    _paintTextWithDualAxisScale(
      canvas, size, 
      masterScale, gridLineHeight, globalXOffset,
      highlightPaint, debugPaint
    );

    // 🛑 PAINTER HEADER REMOVED: Managed by Widget Layer (SurahHeaderWidget)

    // Grid Lines (Debug Only)
    if (debugMode) {
      final Paint gridPaint = Paint()
        ..color = const Color(0xFF00FF00).withOpacity(0.3) 
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
        
      for (int i = 0; i <= 15; i++) {
        double y = i * gridLineHeight;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }
  }

  void _paintTextWithDualAxisScale(
    Canvas canvas, Size size, 
    double masterScale,
    double gridLineHeight,
    double globalXOffset,
    Paint highlightPaint,
    Paint debugPaint
  ) {
    final String fontFamily = "QCF2${pageNumber.toString().padLeft(3, '0')}";

    // ========================================
    // INDUSTRY-STANDARD MAPPING ALGORITHM
    // Based on Quran.com & Ayah App architecture
    // ========================================
    
    // Step 1: Group glyphs by line number (identifies which lines have coordinates)
    Map<int, List<MushafHighlight>> glyphsByLine = {};
    for (var h in highlights) {
      if (h.lineNumber > 0) {
        glyphsByLine.putIfAbsent(h.lineNumber, () => []).add(h);
      }
    }
    
    // 🔧 PATCH: Page 50 Line 15 Vertical Alignment Fix
    if (pageNumber == 50 && glyphsByLine.containsKey(15)) {
       final glyphs = glyphsByLine[15]!;
       double minTop = double.infinity;
       for (var g in glyphs) if (g.rect.top < minTop) minTop = g.rect.top;
       for (int i = 0; i < glyphs.length; i++) {
          if (glyphs[i].rect.top > minTop + 10) {
             glyphs[i] = MushafHighlight(surah: glyphs[i].surah, ayah: glyphs[i].ayah, rect: Rect.fromLTWH(glyphs[i].rect.left, minTop, glyphs[i].rect.width, glyphs[i].rect.height), lineNumber: glyphs[i].lineNumber);
          }
       }
    }
    
    // ========================================
    // 🔧 FIXED: Sequential-within-line batching
    // Maps tokens to glyphs in order, respecting DB line boundaries
    // ========================================
    
    // Pre-calculate uniform line heights for consistent font sizing
    Map<int, double> lineHeights = {};
    for (int dbLine in glyphsByLine.keys) {
      double maxHeight = 0;
      for (var glyph in glyphsByLine[dbLine]!) {
        if (glyph.rect.height > maxHeight) {
          maxHeight = glyph.rect.height;
        }
      }
      lineHeights[dbLine] = maxHeight * masterScale;
    }
    
    int tokenIndex = 0;
    
    // Process DB lines in order
    for (int dbLine in glyphsByLine.keys.toList()..sort()) {
      final lineGlyphs = glyphsByLine[dbLine]!;
      final uniformLineHeight = lineHeights[dbLine]!;
      
      // Map next N tokens to this line's N glyphs
      for (int pos = 0; pos < lineGlyphs.length && tokenIndex < _allTokens.length; pos++) {
        final glyph = lineGlyphs[pos];
        final String word = _allTokens[tokenIndex];
        
        if (glyph.lineNumber <= 0) {
          tokenIndex++;
          continue;
        }
        
        final Rect lineBounds = _lineRects[glyph.lineNumber] ?? glyph.rect;

        // 🛑 M1: Grid-locked Y-positioning (ALL glyphs on line align to same baseline)
        final double targetGridY = (glyph.lineNumber - 1) * gridLineHeight;
        
        // Preserve relative offset of this glyph from the line's top
        final double glyphOffsetFromLineTop = glyph.rect.top - lineBounds.top;
        final double finalY = targetGridY + glyphOffsetFromLineTop;
        
        // 🛑 DEBUG: Log for first glyph on line 3
        if (pageNumber == 604 && glyph.lineNumber == 3 && pos == 0) {
          print('M1 Fix: Line ${glyph.lineNumber}, lineBounds.top=${lineBounds.top.toStringAsFixed(1)}, glyph.top=${glyph.rect.top.toStringAsFixed(1)}, offset=${glyphOffsetFromLineTop.toStringAsFixed(1)}, finalY=${finalY.toStringAsFixed(1)}');
        }

        // 1. Unified Scaling for X-axis only (Y already scaled)
        double scaledWidth = glyph.rect.width * masterScale;
        
        // 3. Screen-Space Rect
        Rect screenRect = Rect.fromLTWH(
          (glyph.rect.left * masterScale) + globalXOffset, 
          finalY,  // Use calculated grid-aligned Y
          scaledWidth, 
          uniformLineHeight
        );

        // 4. Text Configuration - Use uniform line height for font size
        final textPainter = TextPainter(
          text: TextSpan(
            text: word,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: uniformLineHeight,  // Consistent size across line
              color: textColor,
              height: 1.0, 
            ),
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        )..layout();

        // 5. Width Protection
        double widthScale = 1.0;
        if (textPainter.width > screenRect.width) {
          widthScale = screenRect.width / textPainter.width;
        }

        // 6. Draw Highlight/Debug
        // 🆕 PHASE 2: Word-level highlighting support
        bool isActive = false;
        
        if (glyph.surah == activeSurah && glyph.ayah == activeAyah) {
          if (activeWordIndex != null) {
            // Word-level highlighting: Only highlight if this is the active word
            // We need to track which word within the ayah we're rendering
            // The tokenIndex represents the sequential position, but we need the word position within the ayah
            
            // Count how many words we've seen for this specific ayah so far
            int wordPositionInAyah = 0;
            for (int i = 0; i < tokenIndex; i++) {
              // Check if this previous token belongs to the same ayah
              final prevGlyph = _findGlyphAtTokenIndex(i, glyphsByLine, dbLine);
              if (prevGlyph != null && prevGlyph.surah == glyph.surah && prevGlyph.ayah == glyph.ayah) {
                wordPositionInAyah++;
              }
            }
            
            // Highlight if this word's position matches the active word index
            // Note: wordIndex in WordSegment is 1-based, so we add 1 to our 0-based count
            isActive = (wordPositionInAyah + 1 == activeWordIndex);
          } else {
            // Fallback: Highlight entire ayah (legacy behavior)
            isActive = true;
          }
        }
        
        if (isActive) {
          canvas.drawRect(screenRect, highlightPaint);
        }
        if (debugMode) {
          canvas.drawRect(screenRect, debugPaint);
        }

        // 7. Paint Text
        canvas.save();
        canvas.translate(screenRect.center.dx, screenRect.top);
        canvas.scale(widthScale, 1.0);
        textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
        canvas.restore();
        
        tokenIndex++;
      }
    }
    
    // Diagnostic: Check for unmapped tokens

  }

  // 🆕 PHASE 2: Helper method to find glyph at a specific token index
  MushafHighlight? _findGlyphAtTokenIndex(int targetIndex, Map<int, List<MushafHighlight>> glyphsByLine, int currentDbLine) {
    int tokenIdx = 0;
    
    // Process DB lines in order (same as main rendering loop)
    for (int dbLine in glyphsByLine.keys.toList()..sort()) {
      final lineGlyphs = glyphsByLine[dbLine]!;
      
      for (int pos = 0; pos < lineGlyphs.length; pos++) {
        if (tokenIdx == targetIndex) {
          return lineGlyphs[pos];
        }
        tokenIdx++;
        
        // Early exit if we've passed the target
        if (tokenIdx > targetIndex) return null;
      }
      
      // Early exit if we've passed the current line
      if (dbLine >= currentDbLine) break;
    }
    
    return null;
  }

  // 🛑 _paintHeaders REMOVED

  @override
  bool shouldRepaint(covariant MushafPagePainter oldDelegate) {
     return oldDelegate.activeSurah != activeSurah ||
            oldDelegate.activeAyah != activeAyah ||
            oldDelegate.activeWordIndex != activeWordIndex || // 🆕 PHASE 2
            oldDelegate.debugMode != debugMode ||
            oldDelegate.highlights != highlights || // Assume highlights ref update if page changed
            oldDelegate.textLines != textLines ||
            oldDelegate.pageNumber != pageNumber;
  }
}
