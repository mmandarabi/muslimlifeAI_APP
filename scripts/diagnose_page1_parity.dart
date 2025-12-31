// Page 1 Structure Diagnostic
// Verifies token-glyph parity before implementing sequential mapping
// Run: dart run scripts/diagnose_page1_parity.dart

import 'dart:io';

void main() async {
  print("\n🔍 PAGE 1 STRUCTURE DIAGNOSTIC\n${'=' * 70}");
  
  // ========================================
  // 1. COUNT TEXT TOKENS
  // ========================================
  final file = File('assets/quran/mushaf_v2_map.txt');
  final lines = await file.readAsLines();
  
  List<String> textLines = [];
  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2) {
      final page = int.tryParse(parts[0]);
      if (page == 1) {
        final text = parts.sublist(1).join(',').trim();
        if (text.isNotEmpty) {
          textLines.add(text);
        }
      }
    }
  }
  
  print("📝 TEXT MAP STRUCTURE (Page 1)");
  print("Total text lines: ${textLines.length}\n");
  
  int totalTokens = 0;
  for (int i = 0; i < textLines.length; i++) {
    final tokens = textLines[i].split(' ').where((t) => t.trim().isNotEmpty).toList();
    print('Text Line ${i+1}: ${tokens.length} tokens - ${tokens.take(3).join(' ')}...');
    totalTokens += tokens.length;
  }
  print('\n📊 Total tokens in text map: $totalTokens');
  
  // ========================================
  // 2. SIMULATE DB GLYPH COUNT
  // ========================================
  // We already know from earlier diagnostic: P1 should have glyphs
  // From the KI and user feedback, P1 is an 8-line page
  // The question is: does it have 36 glyphs to match 36 tokens?
  
  print("\n📊 EXPECTED DB STRUCTURE (Based on User Info)");
  print("Page 1 is exceptional: 8 lines total");
  print("Line 1: surah_name header (NO glyphs)");
  print("Lines 2-8: Ayahs 1-7 (WITH glyphs)");
  
  print("\n🎯 CRITICAL CHECK");
  print("Text map tokens: $totalTokens");
  print("Expected glyphs: ~36 (if 7 ayahs with average 5 tokens each)");
  
  if (totalTokens == 36) {
    print("\n✅ MATCH LIKELY");
    print("If DB has 36 glyphs, sequential approach will work!");
  } else if (totalTokens == 7) {
    print("\n❌ MISMATCH DETECTED");
    print("Text map has only 7 tokens (one per line)");
    print("This suggests the text file has 1 token per ayah, not full word breakdown");
    print("Sequential approach will fail!");
  } else {
    print("\n⚠️ UNEXPECTED COUNT");
    print("Need to check actual DB glyph count to validate");
  }
  
  print("\n${'=' * 70}");
}
