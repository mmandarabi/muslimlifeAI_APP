import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Calibrate Word IDs', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // 1. Get Layout DB IDs
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final layoutRows = await layoutDb.rawQuery('SELECT * FROM pages WHERE page_number = 604 ORDER BY line_number');
    
    print('LAYOUT DB (Page 604):');
    for (final row in layoutRows) {
       final line = row['line_number'];
       final type = row['line_type'];
       final first = row['first_word_id'];
       final last = row['last_word_id'];
       print('Line $line ($type): $first -> $last');
    }
    await layoutDb.close();
    
    // 2. Get Hfsdb IDs
    final hfsDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\Hfsdb\\qpc-hafs-word-by-word.db';
    final hfsDb = await databaseFactory.openDatabase(hfsDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get first word of 112
    final start112 = await hfsDb.rawQuery('SELECT * FROM words WHERE surah=112 AND ayah=1 AND word=1');
    // Get last word of 112
    final end112 = await hfsDb.rawQuery('SELECT * FROM words WHERE surah=112 AND ayah=4 ORDER BY word DESC LIMIT 1');
    
    // Get first word of 113
    final start113 = await hfsDb.rawQuery('SELECT * FROM words WHERE surah=113 AND ayah=1 AND word=1');

    print('\nHFSDB:');
    print('Start 112 (1:1): ${start112.first['id']}');
    print('End 112 (4:7): ${end112.first['id']}');
    print('Start 113 (1:1): ${start113.first['id']}');
    
    await hfsDb.close();
  });
}
