import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('FINAL Page 2 Analysis - QPC V2', () async {
    print('='*70);
    print('COMPLETE PAGE 2 ANALYSIS - QPC V2');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final sourceFile = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get Page 2 layout
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, first_word_id, last_word_id
      FROM pages WHERE page_number = 2 ORDER BY line_number
    ''');
    
    print('\n📐 LAYOUT DB - Page 2 Structure (qpc-v2-15-lines.db):');
    print('   Total lines: ${layoutResult.length}');
    
    final ayahLines = <Map<String, dynamic>>[];
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      print('   Line $lineNum: $lineType');
      
      if (lineType == 'ayah') {
        ayahLines.add(row);
        // Get words for this line
        final words = await wordDb.rawQuery('''
          SELECT text FROM words WHERE id >= ? AND id <= ? ORDER BY id
        ''', [firstId, lastId]);
        
        final text = words.map((w) => w['text']).join(' ');
        print('      Words: $text');
      }
    }
    
    // Read source file
    final rawText = await File(sourceFile).readAsString();
    final page2Lines = rawText.replaceAll('\r\n', '\n').split('\n')
        .where((line) => line.trim().startsWith('2,'))
        .map((line) => line.substring(2).trim())
        .toList();
    
    print('\n📄 SOURCE FILE - Page 2 Content (mushaf_v2_map.txt):');
    print('   Total lines: ${page2Lines.length}');
    for (int i = 0; i < page2Lines.length; i++) {
      print('   Line ${i+1}: ${page2Lines[i]}');
    }
    
    // Summary
    print('\n=${'='*70}');
    print('FINAL VERDICT');
    print('=${'='*70}');
    
    final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
    final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
    final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
    
    print('\nLayout DB (QPC V2):');
    print('   - Total: ${layoutResult.length} lines');
    print('   - Headers: $headerCount');
    print('   - Bismillah: $bismillahCount');
    print('   - Ayah lines: $ayahCount');
    
    print('\nSource File:');
    print('   - Total: ${page2Lines.length} lines');
    
    print('\n🎯 CONCLUSION:');
    if (page2Lines.length == ayahCount) {
      print('✅ Source has AYAH-ONLY (headers/bismillah already removed)');
      print('   → Cleaning script should KEEP all ${page2Lines.length} lines as-is');
    } else if (page2Lines.length == layoutResult.length - headerCount - bismillahCount) {
      print('✅ Source matches ayah count after removing headers');
    } else {
      print('❌ MISMATCH:');
      print('   Expected: $ayahCount ayah lines');
      print('   Found: ${page2Lines.length} lines');
      print('   Difference: ${ayahCount - page2Lines.length} lines missing');
    }
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
