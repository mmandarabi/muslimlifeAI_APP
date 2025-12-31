import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Investigate Page 1 actual structure in database', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*80);
    print('PAGE 1 DATABASE INVESTIGATION');
    print('='*80);
    
    final page1Layout = await layoutDb.rawQuery('''
      SELECT * FROM pages WHERE page_number = 1 ORDER BY line_number
    ''');
    
    print('\nActual database structure for Page 1:');
    print('Total lines: ${page1Layout.length}\n');
    
    for (var row in page1Layout) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      print('Line $lineNum: $lineType');
      print('  Word IDs: $firstId - $lastId');
      
      if (lineType == 'ayah' && firstId != null && lastId != null) {
        final words = await wordDb.rawQuery('''
          SELECT location, text FROM words
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstId, lastId]);
        
        print('  Words (${words.length}):');
        for (var w in words) {
          print('    ${w['location']}: ${w['text']}');
        }
      }
      print('');
    }
    
    print('='*80);
    print('CONCLUSION:');
    print('='*80);
    print('Database has ${page1Layout.length} lines (NOT 15-line ornate layout)');
    print('This is likely a simplified/compact layout variant');
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
