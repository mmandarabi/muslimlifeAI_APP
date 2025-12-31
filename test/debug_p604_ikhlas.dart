import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';

void main() {
  test('Debug Al-Ikhlas Segment Map (Page 604 Lines 3-4)', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final data = await glyphDb.rawQuery('''
       SELECT sura_number, ayah_number, line_number, COUNT(*) as glyph_count
       FROM glyphs
       WHERE page_number = 604 AND line_number IN (3, 4)
       GROUP BY sura_number, ayah_number, line_number
       ORDER BY sura_number ASC, ayah_number ASC, line_number ASC
    ''');
    
    print('\n[DATABASE DEFINITION] Al-Ikhlas Structure:');
    for (final row in data) {
       print('Line ${row['line_number']} contains Surah ${row['sura_number']} Ayah ${row['ayah_number']} -> ${row['glyph_count']} glyphs');
    }
    
    await glyphDb.close();
  });
}
