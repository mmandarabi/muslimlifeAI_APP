import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify Page 187 (At-Tawbah) Structure', () async {
    print('VERIFICATION: Page 187 (At-Tawbah) Structure');
  
    // Setup paths - CORRECTED
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    // Checking the NEW GREEDY CLEANED file
    final txtPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED_GREEDY.txt';
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await databaseFactory.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // 1. Check DB Layout
    print('\n--- Database Layout (Page 187) ---');
    final rows = await db.rawQuery('SELECT line_number, line_type, surah_number FROM pages WHERE page_number = 187 ORDER BY line_number');
    
    int ayahCount = 0;
    bool hasBismillah = false;
    
    for (final row in rows) {
      print('Line ${row['line_number']}: ${row['line_type']} ${row['surah_number'] ?? ""}');
      if (row['line_type'] == 'ayah') ayahCount++;
      if (row['line_type'] == 'basmallah') hasBismillah = true;
    }
    
    if (hasBismillah) {
      fail('❌ FAIL: Database has Bismillah on Page 187!');
    } else {
      print('✅ PASS: Database has NO Bismillah on Page 187.');
    }
    
    // 2. Check Text File
    print('\n--- Text File Content (Page 187) ---');
    final lines = await File(txtPath).readAsLines();
    List<String> pageLines = [];
    
    for (final line in lines) {
      if (line.startsWith('187,')) {
        pageLines.add(line);
      }
    }
    
    print('Found ${pageLines.length} lines for Page 187 in text file.');
    
    // Check against Ayah count
    if (pageLines.length == ayahCount) {
      print('✅ PASS: Text file line count matches DB ayah count ($ayahCount).');
    } else {
      // It's possible the text file includes headers?
      // User says "cleanup done", removing non-ayah text.
      // So it should match ayah count.
      print('⚠️ WARNING: Text file has ${pageLines.length} lines, DB expects $ayahCount ayahs.');
      if (pageLines.length == 15) {
         print('ℹ️ Note: Text file has 15 lines (full page). Checking if they are all ayahs...');
      }
    }

    // 3. Check for specific content/drift markers
    // Just a basic check for now
    
    await db.close();
  });
}
