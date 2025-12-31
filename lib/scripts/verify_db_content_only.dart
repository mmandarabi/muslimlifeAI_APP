
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

// Duplicate class to avoid importing flutter files
class LayoutLine {
  final int pageNumber;
  final int lineNumber;
  final String lineType; 
  final int? surahNumber;

  LayoutLine({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    this.surahNumber,
  });

  factory LayoutLine.fromMap(Map<String, dynamic> map) {
    return LayoutLine(
      pageNumber: map['page_number'] as int,
      lineNumber: map['line_number'] as int,
      lineType: map['line_type'] as String,
      surahNumber: map['surah_number'] as int?,
    );
  }
}

Future<void> main() async {
  // Setup FFI
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  
  print('════════════════════════════════════════');
  print('LAYOUT DATABASE VERIFICATION (Script Mode)');
  print('════════════════════════════════════════');

  final dbPath = 'assets/quran/databases/qpc-v1-15-lines.db';
  if (!File(dbPath).existsSync()) {
    print('Error: DB not found at $dbPath');
    return;
  }

  final db = await databaseFactory.openDatabase(dbPath);

  Future<void> verifyPage(int page) async {
    print('\n📖 Page $page:');
    final results = await db.query(
      'pages',
      where: 'page_number = ?',
      whereArgs: [page],
      orderBy: 'line_number ASC',
    );
    
    final lines = results.map((row) => LayoutLine.fromMap(row)).toList();
    
    // Filter out simple ayah lines to match user request (mostly headers)
    // Actually user request showed all lines for 604
    
    for (var line in lines) {
      bool printIt = true;
      if (page != 604 && line.lineType == 'ayah') printIt = false; // Only headers for others
      if (printIt) {
        final start = 'Line ${line.lineNumber}: ${line.lineType}';
        final pad = start.padRight(25);
        print('  $start surah=${line.surahNumber ?? "-"}');
      }
    }
  }

  await verifyPage(604);
  await verifyPage(1);
  await verifyPage(187);

  await db.close();
  
  print('\n════════════════════════════════════════');
  print('VERIFICATION COMPLETE');
  print('════════════════════════════════════════');
}
