
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() async {
  // 1. Check Text Map
  final mapFile = File('assets/quran/mushaf_v2_map.txt');
  if (!mapFile.existsSync()) {
    print("❌ mushaf_v2_map.txt not found");
    return;
  }
  
  final lines = await mapFile.readAsLines();
  // Format: page_num|line_num|text
  // We want Page 602.
  // We can just grep for "602|" efficiently
  
  print("--- Page 602 Text ---");
  List<String> page604Lines = [];
  for (var line in lines) {
    if (line.startsWith("602|")) {
       page604Lines.add(line);
    }
  }
  
  for (var l in page604Lines) {
     print(l);
  }

  // 2. Check DB
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  final dbPath = join(Directory.current.path, "assets", "quran", "mushaf_v2.db");
  
  if (!File(dbPath).existsSync()) {
     print("❌ DB not found at $dbPath");
     return;
  }

  final db = await databaseFactory.openDatabase(dbPath);
  
  print("\n--- Page 604 Highlights ---");
  final results = await db.query(
    'glyphs', 
    columns: ['line_number', 'sura', 'ayah'],
    where: 'page_number = ?',
    whereArgs: [604],
    orderBy: 'line_number'
  );

  Map<int, int> lineCounts = {};
  for (var row in results) {
     int ln = row['line_number'] as int;
     lineCounts[ln] = (lineCounts[ln] ?? 0) + 1;
  }
  
  lineCounts.forEach((ln, count) {
     print("Line $ln: $count glyphs");
  });
  
  await db.close();
}
