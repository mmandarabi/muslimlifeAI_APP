import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🧪 COMPREHENSIVE MUSHAF VALIDATION - ALL 604 PAGES");
  print("=" * 80);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();

  // ========================================
  // TEST 1: Count Parity (All 604 Pages)
  // ========================================
  print("\n📊 TEST 1: Count Parity Check (All 604 Pages)");
  print("-" * 80);

  List<int> failedPages = [];
  int passedPages = 0;

  for (int page = 1; page <= 604; page++) {
    // Get text tokens (flattened)
    final lines = await textService.getPageLines(page);
    List<String> tokens = [];
    for (var line in lines) {
      tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
    }

    // Get DB glyphs
    final glyphs = await dataService.getPageGlyphs(page);

    // Compare counts
    if (tokens.length != glyphs.length) {
      print("❌ Page $page: Tokens=${tokens.length} vs Glyphs=${glyphs.length} (Drift: ${tokens.length - glyphs.length})");
      failedPages.add(page);
    } else {
      passedPages++;
    }

    // Progress indicator
    if (page % 100 == 0) {
      print("   Processed $page pages...");
    }
  }

  print("\n" + "-" * 80);
  print("RESULTS:");
  print("✅ Passed: $passedPages / 604");
  print("❌ Failed: ${failedPages.length} / 604");
  
  if (failedPages.isNotEmpty) {
    print("\n📋 Failed Pages (need drift corrections):");
    print(failedPages.take(50).join(', '));
    if (failedPages.length > 50) {
      print("... and ${failedPages.length - 50} more");
    }
  }

  // ========================================
  // TEST 2: Critical Pages Deep Test
  // ========================================
  print("\n" + "=" * 80);
  print("📊 TEST 2: Critical Pages Deep Analysis");
  print("-" * 80);

  final criticalPages = [1, 2, 50, 77, 187, 293, 604];

  for (final page in criticalPages) {
    final lines = await textService.getPageLines(page);
    List<String> tokens = [];
    for (var line in lines) {
      tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
    }

    final glyphs = await dataService.getPageGlyphs(page);

    // Group glyphs by line
    Map<int, int> glyphsByLine = {};
    for (var glyph in glyphs) {
      int line = glyph['line_number'] as int? ?? 0;
      glyphsByLine[line] = (glyphsByLine[line] ?? 0) + 1;
    }

    final sortedLines = glyphsByLine.keys.toList()..sort();
    final missingLines = <int>[];
    for (int i = 1; i <= 15; i++) {
      if (!glyphsByLine.containsKey(i)) {
        missingLines.add(i);
      }
    }

    print("\nPage $page:");
    print("  Total tokens: ${tokens.length}");
    print("  Total glyphs: ${glyphs.length}");
    print("  Lines with glyphs: $sortedLines");
    if (missingLines.isNotEmpty) {
      print("  📋 Header lines (no glyphs): $missingLines");
    }
    print("  Status: ${tokens.length == glyphs.length ? '✅ Perfect sync' : '❌ Mismatch'}");
  }

  // ========================================
  // FINAL SUMMARY
  // ========================================
  print("\n" + "=" * 80);
  print("🎯 FINAL VALIDATION SUMMARY");
  print("=" * 80);
  print("Total Pages: 604");
  print("✅ Perfect Sync: $passedPages pages (${(passedPages / 604 * 100).toStringAsFixed(1)}%)");
  print("❌ Need Drift Fix: ${failedPages.length} pages (${(failedPages.length / 604 * 100).toStringAsFixed(1)}%)");
  
  if (passedPages == 604) {
    print("\n🎉 PERFECT! All 604 pages have token→glyph synchronicity!");
    print("The industry-standard mapping is production-ready.");
  } else {
    print("\n📝 Action Required:");
    print("Update MushafTextService._driftMap with corrections for failed pages.");
  }
  
  print("=" * 80);
}
