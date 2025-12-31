import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Create Manual Page 604 Fix', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final hfsDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\Hfsdb\\qpc-hafs-word-by-word.db';
    final hfsDb = await databaseFactory.openDatabase(hfsDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get all words for Surah 112 (Al-Ikhlas)
    final ikhlas = await hfsDb.rawQuery('SELECT * FROM words WHERE surah=112 ORDER BY ayah, word');
    
    print('Surah 112 (Al-Ikhlas) Word Breakdown:');
    
    // Group by Ayah
    final ayah1 = ikhlas.where((w) => w['ayah'] == 1).toList();
    final ayah2 = ikhlas.where((w) => w['ayah'] == 2).toList();
    final ayah3 = ikhlas.where((w) => w['ayah'] == 3).toList();
    final ayah4 = ikhlas.where((w) => w['ayah'] == 4).toList();
    
    print('\\nAyah 1: ${ayah1.length} words');
    for (final w in ayah1) print('  ${w['text']}');
    
    print('\\nAyah 2: ${ayah2.length} words');
    for (final w in ayah2) print('  ${w['text']}');
    
    print('\\nAyah 3: ${ayah3.length} words');
    for (final w in ayah3) print('  ${w['text']}');
    
    print('\\nAyah 4: ${ayah4.length} words');
    for (final w in ayah4) print('  ${w['text']}');
    
    print('\\n---');
    print('Line 3 should contain: Ayahs 1+2+3 = ${ayah1.length + ayah2.length + ayah3.length} words total');
    print('Line 4 should contain: Ayah 4 = ${ayah4.length} words total');
    
    await hfsDb.close();
  });
}
