import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

/// Comprehensive database schema inspector
/// Examines ALL databases in assets/quran to understand their structure and purpose
void main() {
  test('Inspect all Quran databases', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final databases = {
      'Layout DB': r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db',
      'Glyph DB': r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db',
      'Word-by-Word DB (root)': r'D:\solutions\MuslimLifeAI_demo\assets\quran\qpc-v1-glyph-codes-wbw.db',
      'Word-by-Word DB (Hfsdb)': r'D:\solutions\MuslimLifeAI_demo\assets\quran\Hfsdb\qpc-hafs-word-by-word.db',
    };
    
    for (final entry in databases.entries) {
      final name = entry.key;
      final path = entry.value;
      
      if (!File(path).existsSync()) {
        print('\n❌ $name NOT FOUND at $path');
        continue;
      }
      
      print('\n' + '='*70);
      print('DATABASE: $name');
      print('='*70);
      
      final db = await openDatabase(path, readOnly: true);
      
      // Get all tables
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'"
      );
      
      print('\nTables (${tables.length}):');
      for (final table in tables) {
        final tableName = table['name'] as String;
        print('  - $tableName');
      }
      
      // For each table, show schema
      for (final table in tables) {
        final tableName = table['name'] as String;
        print('\n📋 Table: $tableName');
        
        final schema = await db.rawQuery('PRAGMA table_info($tableName)');
        print('  Columns:');
        for (final col in schema) {
          print('    ${col['name']} (${col['type']})');
        }
        
        // Get row count
        final count = await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
        final rowCount = count.first['count'];
        print('  Rows: $rowCount');
        
        // Show sample data (first 3 rows)
        final sample = await db.rawQuery('SELECT * FROM $tableName LIMIT 3');
        if (sample.isNotEmpty) {
          print('  Sample data:');
          for (final row in sample) {
            print('    $row');
          }
        }
      }
      
      await db.close();
    }
    
    print('\n' + '='*70);
    print('Database inspection complete');
    print('='*70);
  });
}
