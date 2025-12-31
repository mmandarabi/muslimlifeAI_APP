import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() async {
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  final dbPath = join(Directory.current.path, "assets", "quran", "mushaf_v2.db");
  
  if (!File(dbPath).existsSync()) {
     print("❌ DB not found at $dbPath");
     return;
  }

  final db = await databaseFactory.openDatabase(dbPath);
  
  // List all tables
  print("=== DATABASE TABLES ===");
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
  );
  
  for (var table in tables) {
    print("Table: ${table['name']}");
  }
  
  // Check for layout/metadata table
  print("\n=== CHECKING FOR LAYOUT METADATA ===");
  try {
    final layoutCheck = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%layout%' OR name LIKE '%meta%'"
    );
    
    if (layoutCheck.isEmpty) {
      print("❌ No layout/metadata table found");
      print("Will need to infer line types from Surah structure");
    } else {
      for (var table in layoutCheck) {
        print("✅ Found: ${table['name']}");
        
        // Get schema
        final schema = await db.rawQuery("PRAGMA table_info(${table['name']})");
        print("Columns:");
        for (var col in schema) {
          print("  - ${col['name']} (${col['type']})");
        }
      }
    }
  } catch (e) {
    print("Error: $e");
  }
  
  // Check glyphs table structure
  print("\n=== GLYPHS TABLE SCHEMA ===");
  final glyphsSchema = await db.rawQuery("PRAGMA table_info(glyphs)");
  for (var col in glyphsSchema) {
    print("  ${col['name']}: ${col['type']}");
  }
  
  await db.close();
}
