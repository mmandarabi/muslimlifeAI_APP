
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

Future<void> main() async {
  // Initialize FFI
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  var path = join(Directory.current.path, "assets", "quran", "databases", "ayahinfo.db");
  print("Opening DB at: $path");

  var db = await databaseFactory.openDatabase(path);

  // Get Tables
  var tables = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
  print("Tables:");
  for (var t in tables) {
    print("- ${t['name']}");
  }

  // Inspect 'glyphs' table if it exists
  try {
    var result = await db.rawQuery('PRAGMA table_info(glyphs);');
    print("\nSchema (glyphs):");
    for (var r in result) {
      print("${r['cid']} ${r['name']} ${r['type']}");
    }

    print("\nSample Data (Page 1):");
    var rows = await db.query('glyphs', where: 'page_number = ?', whereArgs: [1], limit: 5);
    for (var r in rows) {
      print(r);
    }
  } catch (e) {
    print("Error querying glyphs: $e");
  }

  await db.close();
}
