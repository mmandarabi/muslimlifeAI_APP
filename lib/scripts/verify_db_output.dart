
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:path/path.dart';
import 'dart:io';

Future<void> main() async {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  print('=== Page 604 Layout from DB ===');
  
  // We need to valid path since we are in script mode
  // Using direct relative path to asset for test
  final dbPath = 'assets/quran/databases/qpc-v1-15-lines.db';
  if (!File(dbPath).existsSync()) {
    print('Error: Database not found at $dbPath');
    return;
  }
  
  // Open DB directly
  final db = await databaseFactory.openDatabase(dbPath);
  
  final results = await db.query(
      'pages',
      where: 'page_number = ?',
      whereArgs: [604],
      orderBy: 'line_number ASC',
    );

  final layout = results.map((row) => LayoutLine.fromMap(row)).toList();
  
  for (var line in layout) {
    print('Line ${line.lineNumber}: ${line.lineType}, surah=${line.surahNumber}');
  }
  
  await db.close();
}
