import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'dart:io';

void main() {
  test('Debug Layout P604', () async {
    // Setup FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Point to the actual asset file on disk
    final cwd = Directory.current.path;
    final dbPath = '$cwd/assets/quran/databases/qpc-v1-15-lines.db';
    
    // Check exist
    if (!File(dbPath).existsSync()) {
      print('CRITICAL: DB file not found at $dbPath');
      return;
    }

    // Set override
    MushafLayoutService.overrideDbPath = dbPath;

    print('--------------- LAYOUT DATA 604 ---------------');
    final layout = await MushafLayoutService.getPageLayout(604);
    for (var line in layout) {
      print('Line ${line.lineNumber}: ${line.lineType}, surah=${line.surahNumber}, centered=${line.isCentered}');
    }
    print('-----------------------------------------------');
  });
}
