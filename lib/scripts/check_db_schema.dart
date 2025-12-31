import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  
  final db = await databaseFactoryFfi.openDatabase(
    'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db',
    options: OpenDatabaseOptions(readOnly: true),
  );
  
  // Check schema
  print('=== DATABASE SCHEMA ===');
  final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
  for (final table in tables) {
    print('\nTable: ${table['name']}');
    final columns = await db.rawQuery("PRAGMA table_info(${table['name']})");
    for (final col in columns) {
      print('  - ${col['name']}: ${col['type']}');
    }
  }
  
  // Check Page 604 data
  print('\n=== PAGE 604 DATA ===');
  final page604 = await db.rawQuery('''
    SELECT line_number, line_type, surah_number, surah_name, text
    FROM pages
    WHERE page_number = 604
    ORDER BY line_number
  ''');
  
  for (final row in page604) {
    print('\nLine ${row['line_number']}: ${row['line_type']}');
    if (row['surah_number'] != null) print('  Surah: ${row['surah_number']}');
    if (row['surah_name'] != null) print('  Name: ${row['surah_name']}');
    if (row['text'] != null) {
      final text = row['text'] as String;
      final preview = text.length > 30 ? text.substring(0, 30) + '...' : text;
      print('  Text: $preview');
    }
  }
  
  await db.close();
}
