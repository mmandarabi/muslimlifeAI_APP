import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Deep Inspect Layout DB Schema', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final db = await databaseFactory.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // List tables
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tables in qpc-v1-15-lines.db:');
    for (final t in tables) print('  - ${t['name']}');
    
    // If there is a 'words' table, dump identifiers for the IDs we verify
    // IDs: 83617 to 83631 (from Page 604 checks)
    
    bool hasWords = tables.any((t) => t['name'] == 'words');
    if (hasWords) {
       print('\nChecking Words 83617 to 83631 table mapping:');
       final words = await db.rawQuery('SELECT * FROM words WHERE id BETWEEN 83617 AND 83631');
       for (final w in words) {
          print(w);
       }
    } else {
       // Check if there is another table that might hold this?
       // glyphs?
       bool hasGlyphs = tables.any((t) => t['name'] == 'glyphs');
       if (hasGlyphs) {
          print('\nChecking Glpyhs table?');
       }
    }
    
    await db.close();
  });
}
