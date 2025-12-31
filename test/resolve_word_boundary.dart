import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Resolve Word Boundary (Hfsdb vs Layout)', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final hfsDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\Hfsdb\\qpc-hafs-word-by-word.db';
    final hfsDb = await databaseFactory.openDatabase(hfsDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Check words around the Line 3 / Line 4 boundary.
    // Layout DB said:
    // Line 3 ends at Word ID 83625
    // Line 4 starts at Word ID 83626
    
    print('Checking Word IDs 83624 to 83627 in Hfsdb...');
    
    // Hfsdb table likely 'words' with 'id' column (verified earlier)
    final splitWords = await hfsDb.rawQuery('''
       SELECT id, surah, ayah, word, text 
       FROM words 
       WHERE id BETWEEN 83624 AND 83627
    ''');
    
    for (final w in splitWords) {
       print('Word ${w['id']}: Surah ${w['surah']} Ayah ${w['ayah']} Word ${w['word']} -> "${w['text']}"');
    }
    
    await hfsDb.close();
  });
}
