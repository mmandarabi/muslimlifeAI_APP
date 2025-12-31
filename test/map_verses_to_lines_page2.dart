import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Map verses to lines on Page 2', () async {
    print('='*70);
    print('PAGE 2: VERSE-TO-LINE MAPPING');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get Page 2 layout - ayah lines only
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, first_word_id, last_word_id
      FROM pages 
      WHERE page_number = 2 AND line_type = 'ayah'
      ORDER BY line_number
    ''');
    
    print('\n📖 VERSE DISTRIBUTION ACROSS LINES:');
    print('='*70);
    
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final firstId = row['first_word_id'] as int;
      final lastId = row['last_word_id'] as int;
      
      // Get all words for this line
      final words = await wordDb.rawQuery('''
        SELECT id, location, surah, ayah, word, text
        FROM words 
        WHERE id >= ? AND id <= ?
        ORDER BY id
      ''', [firstId, lastId]);
      
      // Group by verse (ayah)
      final verseGroups = <int, List<Map<String, dynamic>>>{};
      for (var w in words) {
        final ayah = w['ayah'] as int;
        verseGroups.putIfAbsent(ayah, () => []).add(w);
      }
      
      print('\nLine $lineNum (Word IDs $firstId-$lastId):');
      for (var ayah in verseGroups.keys.toList()..sort()) {
        final versWords = verseGroups[ayah]!;
        final wordCount = versWords.length;
        final wordRange = '${versWords.first['word']}-${versWords.last['word']}';
        final text = versWords.map((w) => w['text']).join(' ');
        
        print('   └─ Verse 2:$ayah (words $wordRange): $wordCount words');
        print('      Text: $text');
      }
    }
    
    // Now show the full verse structure
    print('\n${'='*70}');
    print('COMPLETE VERSE BREAKDOWN:');
    print('='*70);
    
    // Get all words for verses 2:1 through 2:5 (first few verses on page 2)
    for (int ayah = 1; ayah <= 5; ayah++) {
      final verseWords = await wordDb.rawQuery('''
        SELECT id, word, text FROM words 
        WHERE surah = 2 AND ayah = ?
        ORDER BY word
      ''', [ayah]);
      
      final wordIds = verseWords.map((w) => w['id']).toList();
      final text = verseWords.map((w) => w['text']).join(' ');
      
      print('\nVerse 2:$ayah:');
      print('   Total words: ${verseWords.length}');
      print('   Word IDs: ${wordIds.join(', ')}');
      print('   Text: $text');
      
      // Determine which lines this verse appears on
      final linesContaining = <int>[];
      for (var layoutRow in layoutResult) {
        final firstId = layoutRow['first_word_id'] as int;
        final lastId = layoutRow['last_word_id'] as int;
        
        // Check if any word ID from this verse falls in this line's range
        final wordIdsInt = wordIds.cast<int>();
        if (wordIdsInt.any((id) => id >= firstId && id <= lastId)) {
          linesContaining.add(layoutRow['line_number'] as int);
        }
      }
      
      print('   Appears on lines: ${linesContaining.join(', ')}');
    }
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
