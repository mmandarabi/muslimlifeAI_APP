
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:muslim_mind/services/mushaf_layout_engine.dart';
import 'dart:io';

// Mock class to hold DB data
class LayoutLine {
  final int lineNumber;
  final String lineType;
  final int? surahNumber;
  LayoutLine(this.lineNumber, this.lineType, this.surahNumber);
}

void main() {
  test('Generate Technical Report Data', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final layoutDbPath = 'assets/quran/databases/qpc-v1-15-lines.db';
    final glyphDbPath = 'assets/quran/databases/ayahinfo.db';

    if (!File(layoutDbPath).existsSync()) {
      print('ERROR: Layout DB not found at $layoutDbPath');
      return;
    }
    if (!File(glyphDbPath).existsSync()) {
      print('ERROR: Glyph DB not found at $glyphDbPath');
      return;
    }

    final layoutDb = await databaseFactory.openDatabase(layoutDbPath);
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath);

    print('\n=== PAGE 604 POSITIONING REPORT ===');
    
    // 1. Layout Data
    final layoutResults = await layoutDb.query('pages', where: 'page_number = 604', orderBy: 'line_number ASC');
    final layoutLines = layoutResults.map((row) => LayoutLine(
      row['line_number'] as int,
      row['line_type'] as String,
      row['surah_number'] as int?,
    )).toList();

    for (var line in layoutLines.take(6)) {
       print('Layout DB: Line ${line.lineNumber} = ${line.lineType}, surah=${line.surahNumber}');
    }

    // 2. Ayah Data (Simulating Coordinates)
    // Canonical Width = 1024
    // Screen Width = 430
    // Scale = 430 / 1024 = 0.4199...
    final double scale = 430.0 / 1024.0;
    
    final glyphResults = await glyphDb.query('glyphs', where: 'page_number = 604');
    
    Map<int, double> ayahTops = {}; // For Engine
    Map<int, double> ayahBottoms = {};

    for (var row in glyphResults) {
      int line = row['line_number'] as int;
      double minY = (row['min_y'] as num).toDouble();
      double maxY = (row['max_y'] as num).toDouble();
      
      double top = minY * scale;
      double bottom = maxY * scale;
      
      if (!ayahTops.containsKey(line) || top < ayahTops[line]!) {
        ayahTops[line] = top;
      }
      if (!ayahBottoms.containsKey(line) || bottom > ayahBottoms[line]!) {
        ayahBottoms[line] = bottom;
      }
    }

    print('\nAyahinfo lineBounds (Ayah Lines only):');
    final sortedLines = ayahTops.keys.toList()..sort();
    for (var line in sortedLines) {
       print('  Line $line: top=${ayahTops[line]!.toStringAsFixed(1)}, bottom=${ayahBottoms[line]!.toStringAsFixed(1)}');
    }

    // 3. Engine Calculations
    final pageHeight = 1050.0;
    final standardLineHeight = pageHeight / 15.0; // 70.0
    print('\nGrid lineHeight: $standardLineHeight');
    
    // Calculate Headers using Engine Logic
    // Using the same logic as MushafLayoutEngine.computeDynamicMetrics
    
    for (var line in layoutLines) {
      if (line.lineType == 'surah_name' || line.lineType == 'basmallah') {
         final metrics = MushafLayoutEngine.computeDynamicMetrics(
            lineNum: line.lineNumber, 
            standardLineHeight: standardLineHeight, 
            ayahTops: ayahTops
         );
         
         double bottom = metrics.top + metrics.height;
         print('Engine: Line ${line.lineNumber} (${line.lineType}) -> Top=${metrics.top.toStringAsFixed(1)}, Bottom=${bottom.toStringAsFixed(1)}, Height=${metrics.height.toStringAsFixed(1)}');
      }
    }

    // 4. Overlap Analysis (Pixels)
    print('\n=== OVERLAP ANALYSIS ===');
    // Line 1 End
    // Line 2 Start/End
    // Line 3 Start
    
    // We need to re-calc specific lines to show flow
    var l1 = MushafLayoutEngine.computeDynamicMetrics(lineNum: 1, standardLineHeight: standardLineHeight, ayahTops: ayahTops);
    var l2 = MushafLayoutEngine.computeDynamicMetrics(lineNum: 2, standardLineHeight: standardLineHeight, ayahTops: ayahTops);
    var l3Top = ayahTops[3] ?? 0.0;

    print('Line 1 (Header 112) Bottom: ${(l1.top + l1.height).toStringAsFixed(2)}');
    print('Line 2 (Bismillah)  Top:    ${l2.top.toStringAsFixed(2)}');
    print('Line 2 (Bismillah)  Bottom: ${(l2.top + l2.height).toStringAsFixed(2)}');
    print('Line 3 (Ayah Text)  Top:    ${l3Top.toStringAsFixed(2)}');
    
    await layoutDb.close();
    await glyphDb.close();
  });
}
