import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Check Database for Surah Names and Bismillah Text', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final db = await openDatabase(
      'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db',
      readOnly: true,
    );
    
    // Check schema
    print('\n=== DATABASE SCHEMA ===');
    final columns = await db.rawQuery("PRAGMA table_info(pages)");
    for (final col in columns) {
      print('  ${col['name']}: ${col['type']}');
    }
    
    // Check Page 604 data
    print('\n=== PAGE 604 DATA ===');
    final page604 = await db.rawQuery('''
      SELECT *
      FROM pages
      WHERE page_number = 604
      ORDER BY line_number
    ''');
    
    for (final row in page604) {
      print('\nLine ${row['line_number']}: ${row['line_type']}');
      row.forEach((key, value) {
        if (value != null && key != 'page_number' && key != 'line_number' && key != 'line_type') {
          if (value is String && value.isNotEmpty) {
            final preview = value.length > 50 ? value.substring(0, 50) + '...' : value;
            print('  $key: $preview');
          } else if (value is! String) {
            print('  $key: $value');
          }
        }
      });
    }
    
    // Check if there's a separate table for Surah names or Bismillah
    print('\n=== ALL TABLES ===');
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (final table in tables) {
      print('  ${table['name']}');
    }
    
    await db.close();
  });
}
