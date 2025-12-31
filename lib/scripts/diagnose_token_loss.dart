import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('\n🔍 DIAGNOSING TOKEN LOSS - Page 604\n');
  print('=' * 80);
  
  final textService = MushafTextService();
  final dataService = MushafDataService();
  
  await textService.initialize();
  
  // Get text lines (after sanitization)
  final lines = await textService.getPageLines(604);
  
  print('\n📄 TEXT MAP ANALYSIS:');
  print('Total lines: ${lines.length}');
  
  List<String> allTokens = [];
  Map<int, List<String>> tokensByLine = {};
  
  int lineNum = 1;
  for (var line in lines) {
    var tokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    if (tokens.isNotEmpty) {
      tokensByLine[lineNum] = tokens;
      allTokens.addAll(tokens);
    }
    lineNum++;
  }
  
  print('Total tokens: ${allTokens.length}');
  print('\nTokens per line:');
  for (int i = 1; i <= 15; i++) {
    final count = tokensByLine[i]?.length ?? 0;
    final preview = tokensByLine[i]?.take(3).join(' ') ?? '(empty)';
    print('  Line $i: $count tokens - $preview...');
  }
  
  // Get database glyphs
  print('\n📐 DATABASE ANALYSIS:');
  final glyphs = await dataService.getPageGlyphs(604);
  print('Total glyphs: ${glyphs.length}');
  
  Map<int, int> glyphsByLine = {};
  for (var glyph in glyphs) {
    int line = glyph['line_number'] as int? ?? 0;
    glyphsByLine[line] = (glyphsByLine[line] ?? 0) + 1;
  }
  
  print('\nG glyphs per line:');
  for (int i = 1; i <= 15; i++) {
    final count = glyphsByLine[i] ?? 0;
    print('  Line $i: $count glyphs');
  }
  
  // Compare
  print('\n⚠️  MISMATCH ANALYSIS:');
  print('=' * 80);
  int totalRendered = 0;
  int totalLost = 0;
  
  for (int i = 1; i <= 15; i++) {
    final tokenCount = tokensByLine[i]?.length ?? 0;
    final glyphCount = glyphsByLine[i] ?? 0;
    final rendered = tokenCount < glyphCount ? tokenCount : glyphCount;
    final lost = tokenCount - rendered;
    
    totalRendered += rendered;
    totalLost += lost;
    
    if (lost > 0) {
      print('  ❌ Line $i: $tokenCount tokens vs $glyphCount glyphs → LOSING $lost tokens!');
    } else if (tokenCount > 0) {
      print('  ✅ Line $i: $tokenCount tokens vs $glyphCount glyphs');
    }
  }
  
  print('\n📊 SUMMARY:');
  print('  Total tokens in text: ${allTokens.length}');
  print('  Total glyphs in DB: ${glyphs.length}');
  print('  Tokens that will render: $totalRendered');
  print('  Tokens that will be LOST: $totalLost');
  print('=' * 80);
  
  if (totalLost > 0) {
    print('\n🔧 ROOT CAUSE: Line-level distribution mismatch!');
    print('   The text map and database don\'t agree on which lines contain content.');
    print('   Example: If text has 10 tokens on Line 5 but DB has 5 glyphs on Line 5,');
    print('   the painter will only render 5 tokens and lose the other 5.');
  }
}
