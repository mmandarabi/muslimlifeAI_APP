import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify Page 1 Ayah Line Sync', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db';
    final glyphDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
    final textFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*70);
    print('PAGE 1 VERIFICATION (Al-Fatiha)');
    print('='*70);
    
    // Get layout for Page 1
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, surah_number
      FROM pages
      WHERE page_number = 1
      ORDER BY line_number
    ''');
    
    print('\nPage 1 Layout:');
    for (final row in layoutResult) {
      print('  Line ${row['line_number']}: ${row['line_type']} (Surah: ${row['surah_number'] ?? 'N/A'})');
    }
    
    // Get text lines from file
    final allLines = await File(textFilePath).readAsLines();
    final page1Lines = allLines.where((l) => l.trim().startsWith('1,')).toList();
    
    print('\nPage 1 Text File:');
    print('  Total lines: ${page1Lines.length}');
    for (int i = 0; i < page1Lines.length; i++) {
      final content = page1Lines[i].split(',').sublist(1).join(',').trim();
      final tokenCount = content.split(' ').where((s) => s.isNotEmpty).length;
      print('  Line $i: $tokenCount tokens');
    }
    
    // Get expected ayah lines (only ayah type)
    final ayahLines = layoutResult.where((r) => r['line_type'] == 'ayah').toList();
    
    print('\nExpected Ayah Lines: ${ayahLines.length}');
    print('Actual Text Lines: ${page1Lines.length}');
    
    if (ayahLines.length == page1Lines.length) {
      print('\n✅ PASS: Line count matches!');
    } else {
      print('\n❌ FAIL: Line count mismatch!');
      print('   Expected ${ayahLines.length} ayah lines');
      print('   Found ${page1Lines.length} text lines');
    }
    
    // Deep verification - check each line's token count against database
    print('\nDeep Parity Check:');
    bool allMatch = true;
    
    for (int i = 0; i < ayahLines.length && i < page1Lines.length; i++) {
      final lineNum = ayahLines[i]['line_number'] as int;
      
      // Get expected glyph count
      final glyphResult = await glyphDb.rawQuery('''
        SELECT COUNT(*) as c
        FROM glyphs
        WHERE page_number = 1 AND line_number = ?
      ''', [lineNum]);
      
      final expectedCount = glyphResult.first['c'] as int;
      
      // Get actual token count
      final content = page1Lines[i].split(',').sublist(1).join(',').trim();
      final actualCount = content.split(' ').where((s) => s.isNotEmpty).length;
      
      final match = expectedCount == actualCount;
      final status = match ? '✅' : '❌';
      
      print('  $status Line $lineNum: Expected $expectedCount, Got $actualCount');
      
      if (!match) allMatch = false;
    }
    
    await layoutDb.close();
    await glyphDb.close();
    
    print('\n' + '='*70);
    if (allMatch && ayahLines.length == page1Lines.length) {
      print('✅ Page 1 PASSED all verification checks!');
      print('='*70);
    } else {
      print('❌ Page 1 FAILED verification!');
      print('='*70);
      fail('Page 1 verification failed');
    }
  });
}
