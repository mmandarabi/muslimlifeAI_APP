import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Explore Hizb metadata database', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final hizbDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\fonts\\Hizb\\quran-metadata-hizb.sqlite';
    final hizbDb = await databaseFactory.openDatabase(hizbDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*70);
    print('HIZB METADATA DATABASE EXPLORATION');
    print('='*70);
    
    // Get all tables
    final tables = await hizbDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('\nTables:');
    for (var table in tables) {
      print('  - ${table['name']}');
    }
    
    // Check each table
    for (var table in tables) {
      final tableName = table['name'] as String;
      print('\n${'='*70}');
      print('TABLE: $tableName');
      print('='*70);
      
      // Get schema
      final schema = await hizbDb.rawQuery("PRAGMA table_info($tableName)");
      print('Columns:');
      for (var col in schema) {
        print('  - ${col['name']} (${col['type']})');
      }
      
      // Get sample data
      final sample = await hizbDb.rawQuery('SELECT * FROM $tableName LIMIT 5');
      print('\nSample data:');
      for (var row in sample) {
        print('  $row');
      }
    }
    
    // Check for text content
    print('\n${'='*70}');
    print('SEARCHING FOR TEXT WITH SPECIAL MARKERS');
    print('='*70);
    
    for (var table in tables) {
      final tableName = table['name'] as String;
      
      // Try to find columns with text
      final schema = await hizbDb.rawQuery("PRAGMA table_info($tableName)");
      for (var col in schema) {
        final colName = col['name'] as String;
        
        // Check if this column might contain Quranic text
        if (colName.toLowerCase().contains('text') || 
            colName.toLowerCase().contains('ayah') ||
            colName.toLowerCase().contains('verse')) {
          
          // Check for sajdah markers
          final sajdahCheck = await hizbDb.rawQuery('''
            SELECT COUNT(*) as count FROM $tableName WHERE $colName LIKE '%۩%'
          ''');
          
          if ((sajdahCheck.first['count'] as int) > 0) {
            print('\n✅ FOUND Sajdah markers in $tableName.$colName!');
            print('   Count: ${sajdahCheck.first['count']}');
          }
        }
      }
    }
    
    await hizbDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
