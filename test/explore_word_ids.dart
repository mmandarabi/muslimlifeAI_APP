import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Explore first_word_id and last_word_id', () async {
    print('='*70);
    print('EXPLORING WORD ID FIELDS');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\Hfsdb\\qpc-hafs-word-by-word.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Test Page 604 - Al-Ikhlas
    print('\nPage 604 Line Structure:');
    print('-'*70);
    
    final page604 = await layoutDb.rawQuery('''
      SELECT line_number, line_type, first_word_id, last_word_id, surah_number
      FROM pages
      WHERE page_number = 604
      ORDER BY line_number
    ''');
    
    for (var row in page604) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final firstWordId = row['first_word_id'];
      final lastWordId = row['last_word_id'];
      final surahNum = row['surah_number'];
      
      if (lineType == 'ayah' && firstWordId != null && lastWordId != null) {
        // Try to get words from word database using these IDs
        final words = await wordDb.rawQuery('''
          SELECT id, location, text
          FROM words
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstWordId, lastWordId]);
        
        print('\nLine $lineNum (${lineType}):');
        final wordCount = (lastWordId as int) - (firstWordId as int) + 1;
        print('  Word IDs: $firstWordId to $lastWordId ($wordCount words)');
        print('  Surah: $surahNum');
        
        if (words.isNotEmpty) {
          print('  Text:');
          for (var word in words) {
            print('    ID ${word['id']}: ${word['location']} = ${word['text']}');
          }
        } else {
          print('  ⚠️  No words found in word database for these IDs');
        }
      } else {
        print('\nLine $lineNum ($lineType): first_word_id=$firstWordId, last_word_id=$lastWordId');
      }
    }
    
    // Test a split-ayah scenario - find an ayah that spans multiple lines
    print('\n\n' + '='*70);
    print('TESTING SPLIT-AYAH HANDLING');
    print('='*70);
    
    // Page 2 likely has long ayahs from Al-Baqarah
    final page2 = await layoutDb.rawQuery('''
      SELECT line_number, line_type, first_word_id, last_word_id, surah_number
      FROM pages
      WHERE page_number = 2 AND line_type = 'ayah'
      ORDER BY line_number
      LIMIT 5
    ''');
    
    for (var row in page2) {
      final lineNum = row['line_number'];
      final firstWordId = row['first_word_id'];
      final lastWordId = row['last_word_id'];
      
      if (firstWordId != null && lastWordId != null) {
        final words = await wordDb.rawQuery('''
          SELECT id, location, text
          FROM words
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstWordId, lastWordId]);
        
        print('\nPage 2, Line $lineNum:');
        print('  Word IDs: $firstWordId to $lastWordId');
        if (words.isNotEmpty) {
          final text = words.map((w) => w['text']).join(' ');
          print('  Text: $text');
        }
      }
    }
    
    await layoutDb.close();
    await wordDb.close();
    
    print('\n' + '='*70);
    print('EXPLORATION COMPLETE');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 5)));
}
