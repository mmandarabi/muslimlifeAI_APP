import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify Page 604 structure matches user description', () async {
    print('='*70);
    print('PAGE 604 VERIFICATION');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get Page 604 layout
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, surah_number, first_word_id, last_word_id
      FROM pages 
      WHERE page_number = 604
      ORDER BY line_number
    ''');
    
    print('\n📐 LAYOUT DB - Page 604 Structure:');
    print('   Total lines: ${layoutResult.length}\n');
    
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final surahNum = row['surah_number'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      print('Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');
      
      if (lineType == 'ayah' && firstId != null && lastId != null) {
        // Get words for this line
        final words = await wordDb.rawQuery('''
          SELECT id, location, surah, ayah, word, text
          FROM words 
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstId, lastId]);
        
        // Group by verse
        final verseGroups = <String, List<Map<String, dynamic>>>{};
        for (var w in words) {
          final key = '${w['surah']}:${w['ayah']}';
          verseGroups.putIfAbsent(key, () => []).add(w);
        }
        
        for (var verseKey in verseGroups.keys) {
          final versWords = verseGroups[verseKey]!;
          final wordRange = 'words ${versWords.first['word']}-${versWords.last['word']}';
          final text = versWords.map((w) => w['text']).join(' ');
          
          print('   └─ Verse $verseKey ($wordRange): ${versWords.length} words');
          print('      $text');
        }
      }
      print('');
    }
    
    // Summary
    final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
    final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
    final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
    
    print('='*70);
    print('SUMMARY:');
    print('='*70);
    print('Total lines: ${layoutResult.length}');
    print('- Headers: $headerCount (Surahs 112, 113, 114)');
    print('- Bismillah: $bismillahCount');
    print('- Ayah lines: $ayahCount');
    print('');
    print('User description says:');
    print('- 3 headers + 3 bismillah + 9 ayah lines = 15 total ✓');
    print('');
    print(ayahCount == 9 ? '✅ MATCHES user description' : '❌ MISMATCH');
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
