// Test Page 1 token-to-glyph mapping with new ORDER BY logic
// Run: dart run scripts/test_page1_mapping.dart

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

void main() async {
  sqfliteFfiInit();
  
  print("\n🧪 PAGE 1 MAPPING TEST (ORDER BY line_number ASC, position DESC)\n${'=' * 70}");
  
  // ========================================
  // 1. Load text tokens from mushaf_v2_map.txt
  // ========================================
  final textFile = File('assets/quran/mushaf_v2_map.txt');
  final lines = await textFile.readAsLines();
  
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
  
  print("📝 TEXT MAP: ${allTokens.length} tokens");
  print("First 10 tokens: ${allTokens.take(10).join(' ')}");
  
  // ========================================
  // 2. Query DB with NEW ORDER BY
  // ========================================
  final dbPath = path.join('assets', 'quran', 'databases', 'ayahinfo.db');
  final db = await databaseFactoryFfi.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
  
  final glyphs = await db.query(
    'glyphs',
    where: 'page_number = ?',
    whereArgs: [1],
    orderBy: 'line_number ASC, position DESC', // NEW: Position descending for RTL
  );
  
  print("\n📊 DATABASE: ${glyphs.length} glyphs");
  print("ORDER BY: line_number ASC, position DESC (RTL)");
  
  // ========================================
  // 3. Show first 10 glyph positions
  // ========================================
  print("\n🔍 First 10 glyphs from DB:");
  for (int i = 0; i < (glyphs.length > 10 ? 10 : glyphs.length); i++) {
    final g = glyphs[i];
    print("  Glyph $i: Line ${g['line_number']}, Pos ${g['position']}, "
          "X=${g['min_x']}-${g['max_x']}, Surah ${g['sura_number']}, Ayah ${g['ayah_number']}");
  }
  
  // ========================================
  // 4. Simulate sequential mapping
  // ========================================
  print("\n🎯 SEQUENTIAL MAPPING TEST:");
  print("Token → Glyph mapping (first 10):");
  
  for (int i = 0; i < 10 && i < allTokens.length && i < glyphs.length; i++) {
    final token = allTokens[i];
    final glyph = glyphs[i];
    print("  [$i] Token '$token' → Line ${glyph['line_number']}, "
          "Pos ${glyph['position']}, Surah ${glyph['sura_number']}, Ayah ${glyph['ayah_number']}");
  }
  
  // ========================================
  // 5. Check if Bismillah (Ayah 1) is first
  // ========================================
  print("\n✅ VALIDATION:");
  
  if (glyphs.isNotEmpty) {
    final firstGlyph = glyphs[0];
    final firstAyah = firstGlyph['ayah_number'];
    
    if (firstAyah == 1) {
      print("  ✅ PASS: First glyph is Ayah 1 (Bismillah)");
    } else {
      print("  ❌ FAIL: First glyph is Ayah $firstAyah, expected Ayah 1");
    }
    
    // Check if Ayah 1 tokens come before Ayah 2
    int ayah1Count = 0;
    int ayah2Start = -1;
    for (int i = 0; i < glyphs.length; i++) {
      if (glyphs[i]['ayah_number'] == 1) {
        ayah1Count++;
      } else if (glyphs[i]['ayah_number'] == 2 && ayah2Start == -1) {
        ayah2Start = i;
        break;
      }
    }
    
    print("  Ayah 1 has $ayah1Count glyphs");
    print("  Ayah 2 starts at glyph index $ayah2Start");
    
    if (ayah2Start == ayah1Count) {
      print("  ✅ PASS: Ayah sequence is correct");
    } else {
      print("  ❌ FAIL: Gap or overlap detected");
    }
  }
  
  // === ========================================
  // 6. Check line distribution
  // ========================================
  print("\n📋 LINE DISTRIBUTION:");
  Map<int, int> glyphsPerLine = {};
  for (var g in glyphs) {
    int line = g['line_number'] as int;
    glyphsPerLine[line] = (glyphsPerLine[line] ?? 0) + 1;
  }
  
  for (var line in glyphsPerLine.keys.toList()..sort()) {
    print("  Line $line: ${glyphsPerLine[line]} glyphs");
  }
  
  await db.close();
  print("\n${'=' * 70}");
}
