import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Check which Surahs are on Page 596', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*70);
    print('PAGE 596 - WHICH SURAHS?');
    print('='*70);
    
    // Get all words on this page
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, surah_number, first_word_id, last_word_id
      FROM pages 
      WHERE page_number = 596
      ORDER BY line_number
    ''');
    
    final surahs = <int>{};
    
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final surahNum = row['surah_number'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      print('\nLine $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');
      
      if (lineType == 'ayah' && firstId != null) {
        // Get words to see which surah
        final words = await wordDb.rawQuery('''
          SELECT DISTINCT surah FROM words 
          WHERE id >= ? AND id <= ?
        ''', [firstId, lastId]);
        
        for (var w in words) {
          surahs.add(w['surah'] as int);
          print('   Contains Surah ${w['surah']}');
        }
      }
    }
    
    print('\n${'='*70}');
    print('SURAHS ON PAGE 596: ${surahs.toList()..sort()}');
    print('='*70);
    
    // Surah 100 = Al-Adiyat
    // Surah 101 = Al-Qariah
    // Surah 102 = At-Takathur
    // Surah 93 = Ad-Duha
    // Surah 94 = Ash-Sharh/Al-Inshirah
    
    print('\nSurah names:');
    final surahNames = {
      93: 'Ad-Duha',
      94: 'Ash-Sharh',
      100: 'Al-Adiyat',
      101: 'Al-Qariah',
      102: 'At-Takathur',
    };
    
    for (var surahNum in surahs.toList()..sort()) {
      print('  Surah $surahNum: ${surahNames[surahNum] ?? "Unknown"}');
    }
    
    print('\n❓ User said Page 596 has Al-Adiyat, Al-Qariah, At-Takathur');
    print('   (Surahs 100, 101, 102)');
    print('\n📊 Database shows: ${surahs.toList()..sort()}');
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
