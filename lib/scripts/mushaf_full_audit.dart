import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🚀 MUSHAF 2.0 FINAL INTEGRITY AUDIT 🚀");
  print("=" * 70);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();
  
  int passCount = 0;
  List<int> failedPages = [];
  List<String> failureReasons = [];

  for (int page = 1; page <= 604; page++) {
    final sanitizedLines = await textService.getPageLines(page);
    
    // Tokenize
    List<String> tokens = [];
    for (var l in sanitizedLines) {
      tokens.addAll(l.split(' ').where((t) => t.trim().isNotEmpty));
    }

    // Fetch Glyph Info
    final List<Map<String, dynamic>> glyphs = await dataService.getPageGlyphs(page);

    // Verify synchronicity
    if (tokens.length == glyphs.length) {
      passCount++;
      if (page % 100 == 0) {
        print("✅ Page $page: PASS (${tokens.length} tokens)");
      }
    } else {
      failedPages.add(page);
      int drift = glyphs.length - tokens.length;
      String reason = "P$page: ${tokens.length} tokens vs ${glyphs.length} glyphs (drift: $drift)";
      failureReasons.add(reason);
      print("❌ $reason");
    }
  }

  print("\n" + "=" * 70);
  print("📊 FINAL AUDIT RESULTS");
  print("=" * 70);
  print("✅ PASSED: $passCount / 604 pages");
  print("❌ FAILED: ${failedPages.length} pages");
  
  if (failedPages.isEmpty) {
    print("\n🎉 SUCCESS! All 604 pages are perfectly synchronized!");
    print("🟢 MUSHAF 2.0 INTEGRITY: 100%");
  } else {
    print("\n⚠️  Failed pages: $failedPages");
    print("\nFailure details:");
    for (var reason in failureReasons) {
      print("  • $reason");
    }
  }
  
  print("=" * 70);
}
