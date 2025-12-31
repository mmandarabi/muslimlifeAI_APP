import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🔍 PAGE 604 TOKEN→COORDINATE VALIDATION");
  print("=" * 70);

  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();

  // Get text lines and tokenize
  final sanitizedLines = await textService.getPageLines(604);
  List<String> tokens = [];
  for (var l in sanitizedLines) {
    tokens.addAll(l.split(' ').where((t) => t.trim().isNotEmpty));
  }

  // Get glyphs and filter to VERSE-ONLY (ayah > 0)
  final allGlyphs = await dataService.getPageGlyphs(604);
  final verseGlyphs = allGlyphs.where((g) => (g['sura_id'] as int? ?? 0) > 0 && (g['ayah_id'] as int? ?? 0) > 0).toList();

  print("\n📊 STATISTICS:");
  print("Total Text Tokens: ${tokens.length}");
  print("Total DB Glyphs: ${allGlyphs.length}");
  print("Header Glyphs (ayah==0): ${allGlyphs.length - verseGlyphs.length}");
  print("Verse Glyphs (ayah>0): ${verseGlyphs.length}");
  print("");

  if (tokens.length != verseGlyphs.length) {
    print("❌ CRITICAL: Token count (${tokens.length}) != Verse Glyph count (${verseGlyphs.length})");
    print("   This will cause misalignment!");
  } else {
    print("✅ Token count matches verse glyph count!");
  }

  print("\n" + "=" * 70);
  print("📋 FIRST 10 TOKEN→COORDINATE MAPPINGS:");
  print("=" * 70);
  print("IDX | TOKEN          | SURAH | AYAH | LINE | POS | WIDTH");
  print("-" * 70);

  for (int i = 0; i < 10 && i < tokens.length && i < verseGlyphs.length; i++) {
    final token = tokens[i];
    final glyph = verseGlyphs[i];
    
    int surah = glyph['sura_id'] as int? ?? 0;
    int ayah = glyph['ayah_id'] as int? ?? 0;
    int line = glyph['line_number'] as int? ?? 0;
    int pos = glyph['position'] as int? ?? 0;
    double width = (glyph['width_glyph'] as num?)?.toDouble() ?? 0.0;
    
    print("${i.toString().padLeft(3)} | ${token.padRight(14)} | ${surah.toString().padLeft(5)} | ${ayah.toString().padLeft(4)} | ${line.toString().padLeft(4)} | ${pos.toString().padLeft(3)} | ${width.toStringAsFixed(1).padLeft(6)}");
  }

  print("=" * 70);

  // Critical validation: First token should be "قُلْ" (Qul)
  if (tokens.isNotEmpty && verseGlyphs.isNotEmpty) {
    final firstToken = tokens[0];
    final firstGlyph = verseGlyphs[0];
    int firstLine = firstGlyph['line_number'] as int? ?? 0;
    int firstSurah = firstGlyph['sura_id'] as int? ?? 0;
    int firstAyah = firstGlyph['ayah_id'] as int? ?? 0;

    print("\n🎯 CRITICAL VALIDATION:");
    print("First token: '$firstToken'");
    print("Expected: 'قُلْ' (Qul - the first word of Surah Al-Ikhlas)");
    print("Mapped to: Surah $firstSurah, Ayah $firstAyah, Line $firstLine");
    print("Expected Line: 3 (Line 1-2 are headers/Bismillah)");
    
    if (firstToken.contains('قُلْ') || firstToken.contains('ق')) {
      if (firstLine == 3) {
        print("\n✅ SUCCESS: 'Qul' is correctly mapped to Line 3!");
        print("✅ The skip-header logic is working correctly.");
      } else {
        print("\n❌ FAIL: 'Qul' is mapped to Line $firstLine instead of Line 3!");
        print("❌ Header coordinates are NOT being skipped!");
      }
    } else {
      print("\n⚠️  WARNING: First token '$firstToken' doesn't appear to be 'Qul'");
      print("   This may indicate text preprocessing issues.");
    }
  }
  
  print("\n" + "=" * 70);
}
