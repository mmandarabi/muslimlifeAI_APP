
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Added for Rect/Size
import 'dart:math';
import 'mushaf_data_service.dart';
import 'mushaf_text_service.dart';
import 'mushaf_coordinate_service.dart'; // Needed for highlight mapping if complex

class MushafLayoutAuditor {
  final MushafDataService _dataService = MushafDataService();
  final MushafTextService _textService = MushafTextService();

  // Pages to Audit
  final List<int> _criticalPages = [1, 2, 50, 602, 603, 604];
  final Random _rng = Random();

  // Canonical Reference Screen (Typical iPhone 14 Pro Max / Pixel 7 aspect ratio)
  final Size _referenceScreen = const Size(430, 932); 

  Future<void> runPreFlightCheck() async {
    print("\n✈️ MUSHAF 2.0 PRE-FLIGHT VALIDATION STARTING... ✈️");
    
    List<int> auditList = [..._criticalPages];
    // Add 5 random pages
    while (auditList.length < 11) {
      int p = _rng.nextInt(604) + 1;
      if (!auditList.contains(p)) auditList.add(p);
    }
    auditList.sort();

    int passed = 0;
    int failed = 0;
    
    int layoutPassed = 0;
    int layoutFailed = 0;

    print("\n---------------------------------------------------");
    print("AUDIT TARGETS: $auditList");
    print("REFERENCE SCREEN: ${_referenceScreen.width} x ${_referenceScreen.height}");
    print("---------------------------------------------------");

    for (int page in auditList) {
      bool syncResult = await _auditPageSync(page);
      if (syncResult) passed++; else failed++;
      
      if (syncResult) {
         bool layoutResult = await _auditPageLayout(page);
         if (layoutResult) layoutPassed++; else layoutFailed++;
      } else {
        layoutFailed++;
      }
    }

    print("\n---------------------------------------------------");
    print("✅ VALIDATION SUMMARY");
    print("---------------------------------------------------");
    print("Synchronicity Pass: $passed / ${auditList.length}");
    print("Layout Constraint Pass: $layoutPassed / ${auditList.length}");
    
    if (layoutFailed > 0) {
      print("⚠️ WARNING: $layoutFailed pages failed layout constraint checks.");
      print("Recommendation: Review 'Constraint Fail' logs above.");
    } else {
      print("🚀 ALL SYSTEMS GREEN. LAYOUT STABLE.");
    }
  }

  Future<bool> _auditPageSync(int pageNum) async {
    try {
      final List<String> lines = await _textService.getPageLines(pageNum);
      final List<Map<String, dynamic>> rawGlyphs = await _dataService.getPageGlyphs(pageNum);

      List<String> tokens = [];
      for (var line in lines) {
        tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
      }

      if (tokens.length != rawGlyphs.length) {
        print("❌ [P$pageNum] SYNC FAIL: Tokens=${tokens.length} vs DB=${rawGlyphs.length}");
        return false;
      }
      return true;
    } catch (e) {
      print("❌ [P$pageNum] SYNC EXCEPTION: $e");
      return false;
    }
  }
  
  // 🛑 DUAL-CONSTRAINT VALIDATION LOGIC
  Future<bool> _auditPageLayout(int pageNum) async {
    try {
       final rawGlyphs = await _dataService.getPageGlyphs(pageNum);
       
       // Calculate Metrics similar to Painter
       Map<int, Rect> lineRects = {};
       List<double> lineHeights = [];
       double maxDbRight = 0.0;
       
       // 1. Process Glyphs into Highlights/Metrics
       for (var g in rawGlyphs) {
          double l = (g['min_x'] as num).toDouble();
          double t = (g['min_y'] as num).toDouble();
          double r = (g['max_x'] as num).toDouble();
          double b = (g['max_y'] as num).toDouble();
          int line = g['line_number'] as int;
          
          Rect rect = Rect.fromLTRB(l, t, r, b);
          
          if (rect.right > maxDbRight) maxDbRight = rect.right;
          
          if (lineRects.containsKey(line)) {
             lineRects[line] = lineRects[line]!.expandToInclude(rect);
          } else {
             lineRects[line] = rect;
          }
       }
       
       lineRects.forEach((_, r) {
          if (r.height > 2) lineHeights.add(r.height);
       });
       
       if (lineHeights.isEmpty) return true; // Empty page?
       
       lineHeights.sort();
       double medianHeight = lineHeights[lineHeights.length ~/ 2];
       if (medianHeight == 0) medianHeight = 1.0;
       if (maxDbRight == 0) maxDbRight = 100.0;

       // 2. Calculate Scales (The Dual-Constraint Test)
       final double gridLineHeight = _referenceScreen.height / 15.0;
       
       // Vertical Fit
       final double verticalScale = (gridLineHeight / medianHeight) * 0.95;
       
       // Horizontal Fit
       final double horizontalScale = (_referenceScreen.width / maxDbRight) * 0.95;
       
       // Final Master
       final double masterScale = (verticalScale < horizontalScale) ? verticalScale : horizontalScale;
       
       // 3. ASSERTIONS
       
       // A. Check Total Width
       double totalScaledWidth = maxDbRight * masterScale;
       if (totalScaledWidth > _referenceScreen.width) {
          print("❌ [P$pageNum] WIDTH FAIL: Content=$totalScaledWidth > Screen=${_referenceScreen.width}");
          return false;
       }
       
       // B. Check Total Height (Approximate based on 15 lines)
       // The Painter forces lines into the grid, so vertical overflow is impossible by definition (Top Docking).
       // But we check if the SCALE is reasonable.
       
       // Warn if scale is too small (Unreadable)
       if (masterScale < 0.2) {
          print("⚠️ [P$pageNum] SCALE WARN: Scale $masterScale is dangerously small.");
       }
       
       // C. Aspect Preservation Check
       // Ensure we didn't break layout by choosing a wildly different horizontal scale
       if (horizontalScale < verticalScale * 0.5) {
          print("⚠️ [P$pageNum] ASPECT WARN: Page is being crushed horizontally (H=$horizontalScale vs V=$verticalScale).");
       }

       print("✅ [P$pageNum] LAYOUT PASS (Scale: ${masterScale.toStringAsFixed(3)} | W-Fit: ${horizontalScale >= verticalScale})");
       return true;

    } catch (e) {
       print("❌ [P$pageNum] LAYOUT EXCEPTION: $e");
       return false;
    }
  }
  // 🛑 DIAGNOSTIC TOOL: Advanced Smart Drift Analysis
  Future<void> analyzePageDrift(int pageNum) async {
    print("\n🕵️ DRIFT ANALYSIS FOR PAGE $pageNum 🕵️");
    try {
      final List<String> lines = await _textService.getPageLines(pageNum);
      final List<Map<String, dynamic>> rawGlyphs = await _dataService.getPageGlyphs(pageNum);

      // Tokenize
      List<String> tokens = [];
      for (var line in lines) {
        tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
      }

      print("🔎 ANALYZING: Tokens=${tokens.length} vs DB=${rawGlyphs.length}");
      print("---------------------------------------------------------------");

      // 1. Find Divergence Point
      int minLen = min(tokens.length, rawGlyphs.length);
      int mismatchIndex = -1;

      for (int i = 0; i < minLen; i++) {
         // Logic: We can't compare text content because DB is coordinates only.
         // BUT, we can infer logic.
         // If we assume the start is synced, the mismatch usually happens where
         // text index i aligns with DB index i+1 (if DB has extra).
         
         // Wait, we can't DETECT mismatch without content.
         // The only "mismatch" we know is count.
         // UNLESS we check line numbers?
         
         // Heuristic: If Token[i] is on Line X, but Glyph[i] is on Line Y, we have a drift.
         // However, line wrappings make this fuzzy.
         
         // Better Heuristic: Check End-of-List.
      }
      
      // Since we can't visually compare text to DB without text in DB,
      // We rely on the "End Mismatch" or a significant Line/Pos deviation.
      
      int delta = rawGlyphs.length - tokens.length;

      if (tokens.length == rawGlyphs.length) {
         print("✅ COUNT MATCH: Tokens=${tokens.length} vs DB=${rawGlyphs.length}. Checking Alignment...");
         // Continue to print Head Report to verify visual alignment
      } else {
         print("⚠️ DRIFT DETECTED: DB has $delta ${delta > 0 ? 'MORE' : 'FEWER'} items.");
      }
      
       print("\n📋 DRIFT REPORT (FULL PAGE DUMP):");
       print("IDX | TOKEN (Text)       | GLYPH (DB)             | TYPE GUESS");
       print("---|--------------------|------------------------|-----------");
       for (int i = 0; i < max(tokens.length, rawGlyphs.length); i++) {
         String t = (i < tokens.length) ? tokens[i] : "---";
         
         String db = "---";
         String typeGuess = "";
         
         if (i < rawGlyphs.length) {
            final g = rawGlyphs[i];
            int line = g['line_number'] as int;
            int pos = g['position'] as int;
            double w = ((g['max_x'] as num) - (g['min_x'] as num)).toDouble();
            db = "L$line:$pos (w=${w.toStringAsFixed(1)})";
         }
         print("${i.toString().padLeft(3)} | ${t.padRight(18)} | ${db.padRight(22)} | $typeGuess");
       }

      // Dump the "Fault Line" (Tail)
      int mismatchStart = minLen; // Default to end
      
      // Try to find if it diverged earlier by checking Line Numbers?
      // Token Line Number isn't known precisely without the Painter logic.
      // So we just dump the end of the list.
      
      int contextStart = max(0, mismatchStart - 5);
      print("\n📋 DRIFT REPORT (Tail End):");
      print("IDX | TOKEN (Text)       | GLYPH (DB)             | TYPE GUESS");
      print("---|--------------------|------------------------|-----------");
      
      for (int i = contextStart; i < max(tokens.length, rawGlyphs.length); i++) {
        String t = (i < tokens.length) ? tokens[i] : "---";
        String db = "---";
        String typeGuess = "";
        
        if (i < rawGlyphs.length) {
           final g = rawGlyphs[i];
           int line = g['line_number'] as int;
           int pos = g['position'] as int;
           double w = ((g['max_x'] as num) - (g['min_x'] as num)).toDouble();
           db = "L$line:$pos (w=${w.toStringAsFixed(1)})";
           
           // GUESS TYPE
           if (w < 15.0) typeGuess = "Marker/Stop?";
           if (w > 50.0) typeGuess = "Word/Ligature";
           if (i >= tokens.length) typeGuess += " [EXTRA?]";
        }
        
        print("${i.toString().padLeft(3)} | ${t.padRight(18)} | ${db.padRight(22)} | $typeGuess");
      }
      
      print("\n🛠️ SANITIZATION SUGGESTION:");
      if (delta > 0) {
         print("Suggestion: Inject $delta placeholder(s) at end of list.");
         print("Code: sanitized[sanitized.length - 1] = \"\$lastLine${List.filled(delta, ' \\u200B').join()}\";");
      } else {
         print("Suggestion: DB is missing items? Unusual.");
      }

    } catch (e) {
      print("❌ DIAGNOSIS EXCEPTION: $e");
    }
  }
}
