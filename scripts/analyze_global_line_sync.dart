import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  print("\n🔍 GLOBAL LINE DISTRIBUTION ANALYSIS (604 Pages)");
  print("=" * 80);

  // Load original text file
  const mapPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
  final originalText = File(mapPath).readAsStringSync();
  final allLines = originalText.split('\n');

  // Setup database
  const dbPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
  final dbDir = await getDatabasesPath();
  final targetDbPath = p.join(dbDir, "ayahinfo.db");
  await Directory(dbDir).create(recursive: true);
  await File(dbPath).copy(targetDbPath);

  final db = await openDatabase(targetDbPath);

  int pagesWithMismatch = 0;
  int totalTextLines = 0;
  int totalDbLines = 0;

  print("\nAnalyzing all 604 pages...\n");

  for (int page = 1; page <= 604; page++) {
    // Parse text lines for this page
    final pagePrefix = "# Page $page";
    int startIdx = allLines.indexWhere((l) => l.trim() == pagePrefix);
    if (startIdx == -1) continue;

    List<String> textLines = [];
    for (int i = startIdx + 1; i < allLines.length; i++) {
      if (allLines[i].trim().startsWith('# Page')) break;
      if (allLines[i].trim().isNotEmpty) {
        textLines.add(allLines[i].trim());
      }
    }

    // Get DB line distribution
    final dbGlyphs = await db.query(
      'glyphs',
      where: 'page_number = ?',
      whereArgs: [page],
      orderBy: 'line_number ASC, position ASC',
    );

    Set<int> dbLinesWithGlyphs = {};
    for (var glyph in dbGlyphs) {
      int line = glyph['line_number'] as int? ?? 0;
      if (line > 0) dbLinesWithGlyphs.add(line);
    }

    int textLineCount = textLines.length;
    int dbLineCount = dbLinesWithGlyphs.length;

    totalTextLines += textLineCount;
    totalDbLines += dbLineCount;

    if (textLineCount != dbLineCount) {
      pagesWithMismatch++;
      if (pagesWithMismatch <= 10) {
        print("P$page: Text=$textLineCount lines | DB=$dbLineCount lines | ❌ MISMATCH");
      }
    }

    if (page % 100 == 0) {
      print("Processed $page pages...");
    }
  }

  await db.close();

  print("\n" + "=" * 80);
  print("📊 GLOBAL ANALYSIS RESULTS:");
  print("=" * 80);
  print("Pages with line count mismatch: $pagesWithMismatch / 604");
  print("Pages with perfect alignment: ${604 - pagesWithMismatch} / 604");
  print("");
  print("Average text lines per page: ${(totalTextLines / 604).toStringAsFixed(1)}");
  print("Average DB lines per page: ${(totalDbLines / 604).toStringAsFixed(1)}");
  
  if (pagesWithMismatch > 0) {
    print("\n⚠️  RECOMMENDATION:");
    print("Restructure mushaf_v2_map.txt to match DB line distribution.");
    print("This will ensure line-aware mapping works correctly across all pages.");
  } else {
    print("\n✅ All pages have matching line counts!");
  }
  
  print("=" * 80);
}
