import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Check qpc-v2.db schema and Page 2 word data', () async {
    print('='*70);
    print('QPC V2 DATABASE SCHEMA CHECK');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get schema
    print('\n📊 Checking qpc-v2.db schema:');
    final tables = await wordDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('   Tables: ${tables.map((t) => t['name']).join(', ')}');
    
    // Get words table schema
    final schema = await wordDb.rawQuery("PRAGMA table_info(words)");
    print('\n   "words" table columns:');
    for (var col in schema) {
      print('      - ${col['name']} (${col['type']})');
    }
    
    // Get first few rows to understand structure
    print('\n📝 Sample data from words table:');
    final sample = await wordDb.rawQuery('SELECT * FROM words LIMIT 10');
    for (var row in sample) {
      print('   $row');
    }
    
    // Now try to get words for Page 2 ayah lines (word IDs 37-77)
    print('\n📖 Extracting Page 2 ayah words (IDs 37-77):');
    
    // Try different column names
    try {
      final words = await wordDb.rawQuery('''
        SELECT * FROM words WHERE id >= 37 AND id <= 77 ORDER BY id
      ''');
      
      if (words.isNotEmpty) {
        print('   Found ${words.length} words using "id" column');
        print('\n   Line 3 (IDs 37-44):');
        final line3 = words.where((w) => (w['id'] as int) >= 37 && (w['id'] as int) <= 44).toList();
        final line3Text = line3.map((w) => w['text']).join(' ');
        print('   $line3Text');
      }
    } catch (e) {
      print('   ❌ "id" column failed: $e');
    }
    
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
