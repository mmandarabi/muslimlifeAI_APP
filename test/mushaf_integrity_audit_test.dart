import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Full 604-Page Mushaf Integrity Audit', () async {
    print("\n🚀 MUSHAF 2.0 INTEGRITY AUDIT (RTL Sort + Uniform Fonts) 🚀");
    print("=" * 70);

    final textService = MushafTextService();
    final dataService = MushafDataService();
    
    await textService.initialize();
    await dataService.init();
    
    int passCount = 0;
    List<int> failedPages = [];
    List<String> failureReasons = [];

    for (int page = 1; page <= 604; page++) {
      final sanitizedLines = await textService.getPageLines(page);
      
      // Tokenize (same logic as painter)
      List<String> tokens = [];
      for (var l in sanitizedLines) {
        tokens.addAll(l.split(' ').where((t) => t.trim().isNotEmpty));
      }

      // Fetch Glyph Info with RTL sort
      final glyphs = await dataService.getPageGlyphs(page);
      
      if (tokens.length == glyphs.length) {
        passCount++;
        if (page % 50 == 0 || page == 1 || page == 604) {
          print("✅ Page $page: ${tokens.length} tokens = ${glyphs.length} glyphs");
        }
      } else {
        failedPages.add(page);
        final reason = "Page $page: ${tokens.length} tokens ≠ ${glyphs.length} glyphs (Δ ${tokens.length - glyphs.length})";
        failureReasons.add(reason);
        print("❌ $reason");
      }
    }

    print("\n" + "=" * 70);
    print("📊 FINAL REPORT:");
    print("   ✅ PASSED: $passCount / 604 pages");
    print("   ❌ FAILED: ${failedPages.length} pages");
    
    if (failedPages.isNotEmpty) {
      print("\n🔴 Failed Pages: ${failedPages.join(', ')}");
      print("\nReasons:");
      for (var reason in failureReasons) {
        print("   • $reason");
      }
    } else {
      print("\n🎉 ALL 604 PAGES VERIFIED!");
      print("   • RTL sort (min_x DESC) working universally");
      print("   • Sequential mapping handling all page structures");
      print("   • Token-glyph parity: 100%");
    }
    print("=" * 70);

    // Assert all pages pass
    expect(passCount, equals(604), 
      reason: '${failedPages.length} pages failed integrity check');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
