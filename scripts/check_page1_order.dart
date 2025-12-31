// Check if text map token order matches DB glyph order
// Run: dart run scripts/check_page1_order.dart

import 'dart:io';

void main() async {
  print("\n🔍 PAGE 1 TOKEN vs GLYPH ORDER CHECK\n${'=' * 70}");
  
  // Get text map tokens
  final file = File('assets/quran/mushaf_v2_map.txt');
  final lines = await file.readAsLines();
  
  List<String> allTokens = [];
  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2) {
      final page = int.tryParse(parts[0]);
      if (page == 1) {
        final text = parts.sublist(1).join(',').trim();
        if (text.isNotEmpty) {
          allTokens.addAll(text.split(' ').where((t) => t.trim().isNotEmpty));
        }
      }
    }
  }
  
  print("📝 TEXT MAP TOKEN ORDER (first 15):");
  for (int i = 0; i < (allTokens.length > 15 ? 15 : allTokens.length); i++) {
    print("  Token $i: ${allTokens[i]}");
  }
  
  print("\n💡 ANALYSIS:");
  print("Total tokens from text map: ${allTokens.length}");
  print("\nExpected: Tokens should be in READING ORDER (right-to-left Arabic)");
  print("If they're in VISUAL/POSITION order (left-to-right), we need to investigate DB sort order.");
  
  print("\n🎯 NEXT STEP:");
  print("Check actual DB query result order. The DB query uses:");
  print("  ORDER BY line_number, position");
  print("\nIf glyphs at same position need sub-sorting (e.g., by min_x),");
  print("we need to add that to the query.");
  
  print("\n${'=' * 70}");
}
