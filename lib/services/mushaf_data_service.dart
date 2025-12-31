
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MushafDataService {
  static final MushafDataService _instance = MushafDataService._internal();
  factory MushafDataService() => _instance;
  MushafDataService._internal();

  Database? _database;

  Future<void> init() async {
    if (_database != null) return;

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "ayahinfo.db");

    // Always copy from assets on first run or if missing
    // In production, might want version check
    bool exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy of ayahinfo.db from assets");
      try {
        await Directory(dirname(path)).create(recursive: true);
        
        // Copy using byte stream
        ByteData data = await rootBundle.load(join("assets", "quran", "databases", "ayahinfo.db"));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        print("db copied successfully");
      } catch (e) {
        print("Error copying db: $e");
        // Fallback or rethrow
      }
    } else {
      print("Opening existing ayahinfo.db");
    }

    _database = await openDatabase(path, readOnly: true);
  }
  
  Future<List<Map<String, dynamic>>> getPageGlyphs(int pageNumber) async {
    if (_database == null) await init();
    
    // Schema: glyphs (page_number, line_number, sura_number, ayah_number, position, min_x, min_y, max_x, max_y)
    // 🔧 FIXED: Sort by min_x DESC for true right-to-left Arabic reading order
    // Debug showed rect coords 141→251 (left-to-right) with position DESC
    // Need highest X coordinate (rightmost glyph) first for Arabic RTL
    return await _database!.query(
      'glyphs',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC, min_x DESC', // RTL: rightmost glyph first
    );
  }

  Future<void> close() async {
    await _database?.close();
  }
}
