import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Check if QPC V2 database has special markers', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*70);
    print('CHECKING FOR SPECIAL MARKERS IN QPC V2 DATABASE');
    print('='*70);
    
    // Check for Sajdah marker
    final sajdahCheck = await wordDb.rawQuery('''
      SELECT COUNT(*) as count FROM words WHERE text LIKE '%۩%'
    ''');
    
    print('\nSajdah marker (۩):');
    print('  Count in database: ${sajdahCheck.first['count']}');
    
    // Check for Saktah marker
    final saktahCheck = await wordDb.rawQuery('''
      SELECT COUNT(*) as count FROM words WHERE text LIKE '%ۜ%'
    ''');
    
    print('\nSaktah marker (ۜ):');
    print('  Count in database: ${saktahCheck.first['count']}');
    
    // Sample some words to see format
    print('\n📝 Sample words from database:');
    final sample = await wordDb.rawQuery('SELECT text FROM words LIMIT 20');
    for (var word in sample) {
      print('  ${word['text']}');
    }
    
    // Check total word count
    final totalWords = await wordDb.rawQuery('SELECT COUNT(*) as count FROM words');
    print('\nTotal words in database: ${totalWords.first['count']}');
    
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
