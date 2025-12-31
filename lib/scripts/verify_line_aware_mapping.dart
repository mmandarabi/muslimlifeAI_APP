import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🔍 PAGE 604 LINE-AWARE MAPPING VERIFICATION");
  print("=" * 80);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();

  // Get text lines and build token→line map
  final sanitizedLines = await textService.getPageLines(604);
  List<String> allTokens = [];
  Map<int, int> tokenToLine = {}; // token index → line number
  
  int lineNum = 1;
  for (var line in sanitizedLines) {
    List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    for (var token in lineTokens) {
      tokenToLine[allTokens.length] = lineNum;
      allTokens.add(token);
    }
    lineNum++;
  }

  // Get DB glyphs and group by line
  final allGlyphs = await dataService.getPageGlyphs(604);
  Map<int, List<Map<String, dynamic>>> lineToGlyphs = {};
  for (var glyph in allGlyphs) {
    int line = glyph['line_number'] as int? ?? 0;
    lineToGlyphs.putIfAbsent(line, () => []).add(glyph);
  }

  // Group tokens by line
  Map<int, List<int>> lineToTokens = {};
  for (int i = 0; i < allTokens.length; i++) {
    int line = tokenToLine[i] ?? 0;
    lineToTokens.putIfAbsent(line, () => []).add(i);
  }

  print("\n📊 LINE-AWARE MAPPING ANALYSIS:");
  print("Total tokens: ${allTokens.length}");
  print("Total glyphs: ${allGlyphs.length}");
  print("");

  // Show line-by-line mapping
  int totalMapped = 0;
  int totalUnmapped = 0;

  for (int line = 1; line <= 15; line++) {
    final tokensOnLine = lineToTokens[line] ?? [];
    final glyphsOnLine = lineToGlyphs[line] ?? [];
    
    if (tokensOnLine.isEmpty && glyphsOnLine.isEmpty) continue;
    
    int mapped = tokensOnLine.length < glyphsOnLine.length ? tokensOnLine.length : glyphsOnLine.length;
    int unmapped = tokensOnLine.length - mapped;
    
    totalMapped += mapped;
    totalUnmapped += unmapped;
    
    print("Line $line:");
    print("  Text tokens: ${tokensOnLine.length} | DB glyphs: ${glyphsOnLine.length}");
    print("  Mapped: $mapped | Unmapped: $unmapped");
    
    if (unmapped > 0) {
      print("  ⚠️  ${unmapped} tokens will NOT render (no DB coordinates)");
    }
  }

  print("\n" + "=" * 80);
  print("📋 FIRST 20 LINE-AWARE MAPPINGS:");
  print("=" * 80);
  print("TOKEN_IDX | TOKEN | TEXT_LINE | → | DB_LINE | DB_POS | MAPPED?");
  print("-" * 80);

  int mappingCount = 0;
  for (int line = 1; line <= 15 && mappingCount < 20; line++) {
    final tokensOnLine = lineToTokens[line] ?? [];
    final glyphsOnLine = lineToGlyphs[line] ?? [];
    
    for (int i = 0; i < tokensOnLine.length && mappingCount < 20; i++) {
      int tokenIdx = tokensOnLine[i];
      String token = allTokens[tokenIdx];
      String mapped = "NO";
      String dbInfo = "---";
      
      if (i < glyphsOnLine.length) {
        final glyph = glyphsOnLine[i];
        int glyphLine = glyph['line_number'] as int? ?? 0;
        int glyphPos = glyph['position'] as int? ?? 0;
        dbInfo = "L$glyphLine:$glyphPos";
        mapped = "YES";
      }
      
      print("${tokenIdx.toString().padLeft(9)} | ${token.padRight(5)} | ${line.toString().padLeft(9)} | → | ${dbInfo.padRight(7)} | ${mapped.padLeft(7)}");
      mappingCount++;
    }
  }

  print("\n" + "=" * 80);
  print("🎯 SUMMARY:");
  print("=" * 80);
  print("Total mapped: $totalMapped / ${allTokens.length} tokens");
  print("Total unmapped: $totalUnmapped tokens (will not render)");
  
  if (totalUnmapped > 0) {
    print("\n⚠️  Note: Unmapped tokens are on lines where DB has no coordinates");
    print("   (typically Surah headers/Bismillah on Lines 1-2)");
  }
  
  if (totalMapped == allGlyphs.length) {
    print("\n✅ SUCCESS: All DB glyphs have corresponding text tokens!");
  } else {
    print("\n❌ MISMATCH: ${allGlyphs.length} DB glyphs but only $totalMapped mapped tokens");
  }
  
  print("=" * 80);
}
