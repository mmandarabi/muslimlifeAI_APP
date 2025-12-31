import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Inspect Layout DB (qpc-v1-15-lines.db)', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    
    final db = await databaseFactory.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // 1. Tables
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tables:');
    for (final t in tables) print('  - ${t['name']}');
    
    // 2. Query Page 604
    // Assumed table name 'quran_layout' or similar. Check tables first.
    if (tables.isNotEmpty) {
       final tableName = tables.first['name'] as String;
       print('\nSample from $tableName (Page 604):');
       final rows = await db.rawQuery('SELECT * FROM $tableName WHERE page_number = 604 ORDER BY line_number');
       
       for (final row in rows) {
          print(row);
       }
    }
    
    await db.close();
  });
}
