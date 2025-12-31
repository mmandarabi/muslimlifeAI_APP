// Page 1 Diagnostic Script
// Analyzes line distribution mismatch between text map and DB
// Run: dart run scripts/diagnose_page1.dart

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  
  print("\n🔍 PAGE 1 (Al-Fatiha) LINE MAPPING DIAGNOSTIC\n${'=' * 70}");
  
  // 1. Load DB glyphs
  final dbPath = path.join('assets', 'quran', 'databases', 'ayahinfo.db');
  final db = await databaseFactoryFfi.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
  
  final glyphs = await db.query(
    'glyphs',
    where: 'page_number = ?',
    whereArgs: [1],
    orderBy: 'line_number, position',
  );
  
  print("\n📊 DATABASE ANALYSIS (Page 1)");
  print("Total glyphs: ${glyphs.length}");
  
  // Group by line
  Map<int, List<Map<String, dynamic>>> glyphsByLine = {};
  for (var g in glyphs) {
    int line = g['line_number'] as int;
    glyphsByLine.putIfAbsent(line, () => []).add(g);
  }
  
  print("\nGlyphs per DB line:");
  for (var line in glyphsByLine.keys.toList()..sort()) {
    print("  Line $line: ${glyphsByLine[line]!.length} glyphs");
  }
  
  // 2. Load text map
  final textFile = File('assets/quran/mushaf_v2_map.txt');
  final lines = await textFile.readAsLines();
  
  List<String> pageLines = [];
  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2) {
      final page = int.tryParse(parts[0]);
      if (page == 1) {
        final text = parts.sublist(1).join(',').trim();
        if (text.isNotEmpty) {
          pageLines.add(text);
        }
      }
    }
  }
  
  print("\n📝 TEXT MAP ANALYSIS (Page 1)");
  print("Total text lines: ${pageLines.length}");
  
  // Simulate MushafTextService processing
  // Check if P1 has top padding
  bool hasTopPadding = false; // P1 not in _topPaddingMap
  
  if (hasTopPadding) {
    print("⚠️  Top padding would be applied (shifting lines down)");
  } else {
    print("✅ No top padding for P1");
  }
  
  print("\nText lines content:");
  for (int i = 0; i < pageLines.length; i++) {
    final tokens = pageLines[i].split(' ').where((t) => t.trim().isNotEmpty).length;
    print("  Line ${i+1}: $tokens tokens - ${pageLines[i].substring(0, pageLines[i].length > 40 ? 40 : pageLines[i].length)}...");
  }
  
  // 3. Token analysis
  print("\n🔢 TOKEN-TO-LINE MAPPING");
  List<String> allTokens = [];
  Map<int, int> tokenToLine = {};
  int currentLine = 1;
  
  for (String line in pageLines) {
    List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    for (var token in lineTokens) {
      tokenToLine[allTokens.length] = currentLine;
      allTokens.add(token);
    }
    currentLine++;
  }
  
  print("Total tokens extracted: ${allTokens.length}");
  print("\nTokens by line:");
  Map<int, List<int>> tokensByLine = {};
  for (int i = 0; i < allTokens.length; i++) {
    int line = tokenToLine[i] ?? 0;
    if (line > 0) {
      tokensByLine.putIfAbsent(line, () => []).add(i);
    }
  }
  
  for (var line in tokensByLine.keys.toList()..sort()) {
    print("  Text Line $line: ${tokensByLine[line]!.length} tokens");
  }
  
  // 4. MISMATCH ANALYSIS
  print("\n⚠️  MISMATCH ANALYSIS");
  print("${'=' * 70}");
  
  final dbLines = glyphsByLine.keys.toList()..sort();
  final textLines = tokensByLine.keys.toList()..sort();
  
  print("DB has glyphs on lines: $dbLines");
  print("Text has tokens on lines: $textLines");
  
  print("\nLine-by-line comparison:");
  for (int line = 1; line <= 15; line++) {
    final dbCount = glyphsByLine[line]?.length ?? 0;
    final textCount = tokensByLine[line]?.length ?? 0;
    final status = dbCount > 0 && textCount > 0 ? "✅" : 
                   dbCount > 0 && textCount == 0 ? "❌ MISSING TEXT" :
                   dbCount == 0 && textCount > 0 ? "❌ MISSING GLYPHS" : "⚪";
    print("  Line $line: DB=$dbCount glyphs, Text=$textCount tokens $status");
  }
  
  print("\n💡 DIAGNOSIS");
  if (!dbLines.contains(1) || !dbLines.contains(2)) {
    print("  • DB does NOT have glyphs on Lines 1-2 (likely header/decoration)");
  } else {
    print("  • DB HAS glyphs on Lines 1-2");
  }
  
  if (!textLines.contains(1) || !textLines.contains(2)) {
    print("  • Text map does NOT have tokens on Lines 1-2");
  } else {
    print("  • Text map HAS tokens on Lines 1-2");
  }
  
  await db.close();
  print("\n${'=' * 70}");
}
