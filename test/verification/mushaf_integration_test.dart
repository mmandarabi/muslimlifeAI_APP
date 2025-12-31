
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:muslim_mind/services/mushaf_coordinate_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Mushaf 2.0 Data Integrity Check', () async {
    // 1. Verify DB File Exists
    final dbPath = join(Directory.current.path, 'assets', 'quran', 'databases', 'ayahinfo.db');
    final file = File(dbPath);
    expect(file.existsSync(), isTrue, reason: "ayahinfo.db must exist in assets");
    print("✅ DB Found at: $dbPath (${file.lengthSync()} bytes)");

    // 2. Verify DB Readability & Schema
    final db = await openDatabase(dbPath, readOnly: true);
    final tables = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    print("✅ Tables found: ${tables.map((t) => t['name']).toList()}");
    
    // Inspect Schema of ALL tables to find text/line_map
    for (var t in tables) {
      final tableName = t['name'] as String;
      final columns = await db.rawQuery('PRAGMA table_info($tableName);');
      print("\nTable: $tableName");
      for (var c in columns) {
         print(" - ${c['name']} (${c['type']})");
      }
    }
    
    // Check for 'glyphs' table
    final hasGlyphs = tables.any((t) => t['name'] == 'glyphs');
    expect(hasGlyphs, isTrue, reason: "DB must contain 'glyphs' table");

    // 3. Query Page 3 Data
    final rows = await db.query('glyphs', where: 'page_number = ?', whereArgs: [3], limit: 5);
    expect(rows.isNotEmpty, isTrue, reason: "Page 3 should have glyph data");
    print("✅ Page 3 Sample Data: ${rows.first}");
    
    // Verify Column Names
    final firstRow = rows.first;
    expect(firstRow.containsKey('min_x'), isTrue);
    expect(firstRow.containsKey('max_y'), isTrue);
    expect(firstRow.containsKey('sura_number'), isTrue);
    expect(firstRow.containsKey('ayah_number'), isTrue);

    await db.close();
  });

  // Note: Testing MushafCoordinateService requires mocking the DB connection or 
  // dependency injection which serves the FFI db. 
  // Since MushafDataService uses `getDatabasesPath` which is platform specific, 
  // strictly simpler to just verify the DB content here.
  // The service logic is just a wrapper around this data.
}
