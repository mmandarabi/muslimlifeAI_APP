import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🧪 MUSHAF SMOKE TEST - Industry-Standard Mapping Validation");
  print("=" * 80);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();

  // Test pages: Start, mid-points, special cases, and end
  final testPages = [1, 2, 50, 77, 100, 187, 200, 293, 300, 400, 500, 604];

  print("\nTesting ${testPages.length} key pages...\n");
  print("PAGE | TEXT_TOKENS | DB_GLYPHS | STATUS | NOTES");
  print("-" * 80);

  int passCount = 0;
  int failCount = 0;

  for (final page in testPages) {
    // Get text tokens (flattened)
    final lines = await textService.getPageLines(page);
    List<String> tokens = [];
    for (var line in lines) {
      tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
    }

    // Get DB glyphs
    final glyphs = await dataService.getPageGlyphs(page);

    // Compare counts
    bool matches = tokens.length == glyphs.length;
    String status = matches ? '✅' : '❌';
    String notes = '';

    // Special page annotations
    if (page == 1 || page == 2) {
      notes = "Al-Fatiha (special layout)";
    } else if (page == 77 || page == 187 || page == 293) {
      notes = "Mid-page Surah start";
    } else if (page == 604) {
      notes = "Last 3 Surahs";
    }

    print("${page.toString().padLeft(4)} | ${tokens.length.toString().padLeft(11)} | ${glyphs.length.toString().padLeft(9)} | $status     | $notes");

    if (matches) {
      passCount++;
    } else {
      failCount++;
    }
  }

  print("-" * 80);
  print("\n📊 SMOKE TEST RESULTS:");
  print("=" * 80);
  print("✅ Passed: $passCount / ${testPages.length}");
  print("❌ Failed: $failCount / ${testPages.length}");
  
  if (failCount == 0) {
    print("\n🎉 SUCCESS: All test pages have perfect token→glyph synchronicity!");
    print("The industry-standard mapping is working correctly.");
  } else {
    print("\n⚠️  Some pages still have mismatches.");
    print("These may require drift corrections in MushafTextService._driftMap");
  }
  
  print("=" * 80);
}
