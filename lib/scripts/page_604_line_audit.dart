import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n📋 PAGE 604 LINE-BY-LINE CONTENT AUDIT");
  print("=" * 80);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();

  // Get text lines and tokenize
  final sanitizedLines = await textService.getPageLines(604);
  List<String> allTokens = [];
  Map<int, List<String>> textLineTokens = {};
  
  int lineIdx = 1;
  for (var line in sanitizedLines) {
    List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    if (lineTokens.isNotEmpty) {
      textLineTokens[lineIdx] = lineTokens;
      allTokens.addAll(lineTokens);
      lineIdx++;
    }
  }

  // Get all DB glyphs and group by line
  final allGlyphs = await dataService.getPageGlyphs(604);
  Map<int, List<Map<String, dynamic>>> dbLineGlyphs = {};
  
  for (var glyph in allGlyphs) {
    int line = glyph['line_number'] as int? ?? 0;
    dbLineGlyphs.putIfAbsent(line, () => []).add(glyph);
  }

  print("\n📊 SUMMARY:");
  print("Total Text Tokens: ${allTokens.length}");
  print("Total DB Glyphs: ${allGlyphs.length}");
  print("Text Lines with Content: ${textLineTokens.length}");
  print("DB Lines with Glyphs: ${dbLineGlyphs.length}");
  
  print("\n" + "=" * 80);
  print("LINE-BY-LINE CONTENT ANALYSIS:");
  print("=" * 80);

  for (int line = 1; line <= 15; line++) {
    final textTokens = textLineTokens[line] ?? [];
    final dbGlyphs = dbLineGlyphs[line] ?? [];
    
    String firstToken = textTokens.isNotEmpty ? textTokens.first : "---";
    String lastToken = textTokens.isNotEmpty ? textTokens.last : "---";
    
    print("\nLine $line:");
    print("  Text: ${textTokens.length} tokens | First: '$firstToken' | Last: '$lastToken'");
    print("  DB:   ${dbGlyphs.length} glyphs");
    
    if (textTokens.isEmpty && dbGlyphs.isNotEmpty) {
      print("  ⚠️  DB has glyphs but text has NO tokens → Likely HEADER/BISMILLAH line");
    }
    if (textTokens.isNotEmpty && dbGlyphs.isEmpty) {
      print("  ⚠️  Text has tokens but DB has NO glyphs → Misalignment!");
    }
  }

  print("\n" + "=" * 80);
  print("🎯 HEADER GLYPH COUNT (Lines 1-2):");
  print("=" * 80);
  
  int headerGlyphCount = 0;
  for (int line = 1; line <= 2; line++) {
    int count = (dbLineGlyphs[line] ?? []).length;
    headerGlyphCount += count;
    print("Line $line: $count glyphs");
  }
  
  print("\nTotal header glyphs to SKIP: $headerGlyphCount");
  
  // Verify Line 3 alignment
  print("\n" + "=" * 80);
  print("🔍 LINE 3 VERIFICATION (First Verse Line):");
  print("=" * 80);
  
  final line3Tokens = textLineTokens[3] ?? [];
  final line3Glyphs = dbLineGlyphs[3] ?? [];
  
  print("Text tokens on Line 3: ${line3Tokens.length}");
  print("DB glyphs on Line 3: ${line3Glyphs.length}");
  
  if (line3Tokens.isNotEmpty) {
    print("\nFirst token on Line 3: '${line3Tokens.first}'");
    print("Expected: 'قُلْ' (Qul - first word of Surah Al-Ikhlas)");
    
    if (line3Tokens.first.contains('قُلْ') || line3Tokens.first.contains('ق')) {
      print("✅ Confirmed: Text stream starts with 'Qul' on Line 3");
    }
  }
  
  print("\n" + "=" * 80);
  print("💡 RECOMMENDED FIX:");
  print("=" * 80);
  print("Skip the first $headerGlyphCount DB glyphs when mapping text tokens.");
  print("This will align:");
  print("  - Text Token[0] ('Qul') → DB Glyph[$headerGlyphCount] (First glyph on Line 3)");
  print("  - Text Token[1] → DB Glyph[${headerGlyphCount + 1}]");
  print("  - etc.");
  print("=" * 80);
}
