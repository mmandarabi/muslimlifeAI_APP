import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify Page 2 with QPC V2 databases', () async {
    print('='*70);
    print('PAGE 2 VERIFICATION - QPC V2 DATABASES');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final sourceFile = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    // Open databases
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('\n📐 LAYOUT DATABASE (qpc-v2-15-lines.db) - Page 2:');
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, is_centered, first_word_id, last_word_id, surah_number
      FROM pages
      WHERE page_number = 2
      ORDER BY line_number
    ''', []);
    
    print('   Total lines: ${layoutResult.length}\n');
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      final surahNum = row['surah_number'];
      final centered = row['is_centered'];
      
      print('   Line $lineNum: $lineType');
      print('      - Surah: $surahNum');
      print('      - Word range: $firstId to $lastId');
      print('      - Centered: $centered');
    }
    
    // Get word data for ayah lines
    print('\n📝 WORD DATABASE (qpc-v2.db) - Extracting Page 2 Text:');
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      if (lineType == 'ayah' && firstId != null && lastId != null) {
        // Query words in range
        final words = await wordDb.rawQuery('''
          SELECT word_index, text
          FROM words
          WHERE word_index >= ? AND word_index <= ?
          ORDER BY word_index
        ''', [firstId, lastId]);
        
        final wordTexts = words.map((w) => w['text']).join(' ');
        final tokenCount = words.length;
        
        print('   Line $lineNum ($lineType): $tokenCount words');
        print('   Text: $wordTexts');
        print('');
      } else if (lineType == 'surah_name') {
        print('   Line $lineNum (HEADER): Surah ${row['surah_number']} name');
      } else if (lineType == 'basmallah') {
        print('   Line $lineNum (BISMILLAH): ﷽');
      }
    }
    
    // Read source file
    print('\n📄 SOURCE FILE (mushaf_v2_map.txt) - Page 2:');
    final rawText = await File(sourceFile).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    
    final page2Lines = allLines.where((line) => line.trim().startsWith('2,')).toList();
    
    print('   Total lines: ${page2Lines.length}\n');
    for (int i = 0; i < page2Lines.length; i++) {
      final content = page2Lines[i].substring(2).trim();
      final preview = content.length > 80 ? content.substring(0, 80) + '...' : content;
      print('   Source Line ${i+1}:');
      print('   $preview');
      print('');
    }
    
    // Summary
    final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
    final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
    final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
    
    print('='*70);
    print('SUMMARY:');
    print('='*70);
    print('Layout DB: ${layoutResult.length} lines ($headerCount header + $bismillahCount bismillah + $ayahCount ayah)');
    print('Source file: ${page2Lines.length} lines');
    print('');
    
    if (page2Lines.length == ayahCount) {
      print('✅ Source has ONLY ayah lines (headers/bismillah already removed)');
      print('   → Cleaning script should KEEP all ${page2Lines.length} lines');
    } else if (page2Lines.length == layoutResult.length) {
      print('✅ Source has ALL lines (including headers/bismillah)');
      print('   → Cleaning script should REMOVE $headerCount header + $bismillahCount bismillah');
      print('   → Output should have $ayahCount ayah lines');
    } else {
      print('❌ MISMATCH: Source has ${page2Lines.length} lines, expected $ayahCount ayah or ${layoutResult.length} total');
    }
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
