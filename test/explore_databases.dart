import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Explore Database Schemas', () async {
    print('='*70);
    print('DATABASE SCHEMA EXPLORATION');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\Hfsdb\\qpc-hafs-word-by-word.db';
    
    // 1. Explore Layout Database
    print('\n1. LAYOUT DATABASE (qpc-v1-15-lines.db)');
    print('-'*70);
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final layoutTables = await layoutDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tables: ${layoutTables.map((t) => t['name']).join(', ')}');
    
    final layoutSchema = await layoutDb.rawQuery("PRAGMA table_info(pages)");
    print('\nSchema for "pages" table:');
    for (var col in layoutSchema) {
      print('  ${col['name']} (${col['type']})');
    }
    
    final layoutSample = await layoutDb.rawQuery('SELECT * FROM pages WHERE page_number = 604 ORDER BY line_number LIMIT 5');
    print('\nSample data (Page 604, first 5 lines):');
    for (var row in layoutSample) {
      print('  Page ${row['page_number']}, Line ${row['line_number']}, Type: ${row['line_type']}');
    }
    
    await layoutDb.close();
    
    // 2. Explore Glyph Database
    print('\n2. GLYPH DATABASE (ayahinfo.db)');
    print('-'*70);
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final glyphTables = await glyphDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tables: ${glyphTables.map((t) => t['name']).join(', ')}');
    
    final glyphSchema = await glyphDb.rawQuery("PRAGMA table_info(glyphs)");
    print('\nSchema for "glyphs" table:');
    for (var col in glyphSchema) {
      print('  ${col['name']} (${col['type']})');
    }
    
    final glyphSample = await glyphDb.rawQuery('SELECT * FROM glyphs WHERE page_number = 604 LIMIT 5');
    print('\nSample data (Page 604, first 5 glyphs):');
    for (var row in glyphSample) {
      print('  Page ${row['page_number']}, Line ${row['line_number']}, Surah ${row['sura_number']}, Ayah ${row['ayah_number']}, Position ${row['position']}');
    }
    
    // Count glyphs per line for Page 604
    final glyphCounts = await glyphDb.rawQuery('''
      SELECT line_number, COUNT(*) as glyph_count
      FROM glyphs
      WHERE page_number = 604
      GROUP BY line_number
      ORDER BY line_number
    ''');
    print('\nGlyph counts per line (Page 604):');
    for (var row in glyphCounts) {
      print('  Line ${row['line_number']}: ${row['glyph_count']} glyphs');
    }
    
    await glyphDb.close();
    
    // 3. Explore Word-by-Word Database
    print('\n3. WORD-BY-WORD DATABASE (qpc-hafs-word-by-word.db)');
    print('-'*70);
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final wordTables = await wordDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tables: ${wordTables.map((t) => t['name']).join(', ')}');
    
    final wordSchema = await wordDb.rawQuery("PRAGMA table_info(words)");
    print('\nSchema for "words" table:');
    for (var col in wordSchema) {
      print('  ${col['name']} (${col['type']})');
    }
    
    final wordSample = await wordDb.rawQuery('SELECT * FROM words WHERE surah = 112 ORDER BY ayah, word LIMIT 10');
    print('\nSample data (Surah 112 - Al-Ikhlas, first 10 words):');
    for (var row in wordSample) {
      print('  ${row['location']}: ${row['text']}');
    }
    
    // Get complete ayah text
    final ayah3Words = await wordDb.rawQuery('SELECT * FROM words WHERE surah = 112 AND ayah = 3 ORDER BY word');
    print('\nComplete Ayah 112:3:');
    final words = ayah3Words.map((r) => r['text']).join(' ');
    print('  $words');
    
    await wordDb.close();
    
    print('\n' + '='*70);
    print('EXPLORATION COMPLETE');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 5)));
}
