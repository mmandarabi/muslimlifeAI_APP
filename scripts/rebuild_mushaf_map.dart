import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  print("\n🔧 MUSHAF MAP RESTRUCTURING TOOL");
  print("=" * 80);
  print("Goal: Align text line distribution with database glyph distribution");
  print("=" * 80);

  // Paths
  const originalMapPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
  const newMapPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map_NEW.txt';
  const dbPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';

  // Load original text file
  print("\n📖 Loading original mushaf_v2_map.txt...");
  final originalText = File(originalMapPath).readAsStringSync();
  final allLines = originalText.split('\n');
  
  // Open database
  print("📊 Opening ayahinfo.db...");
  final db = await openDatabase(dbPath, readOnly: true);

  // Output buffer
  StringBuffer newContent = StringBuffer();
  
  int processedPages = 0;
  int restructuredPages = 0;

  print("\n🔄 Processing all 604 pages...\n");

  for (int page = 1; page <= 604; page++) {
    // ========================================
    // STEP 1: Extract original tokens for this page
    // ========================================
    final pagePrefix = "# Page $page";
    int startIdx = allLines.indexWhere((l) => l.trim() == pagePrefix);
    
    if (startIdx == -1) {
      print("⚠️  Page $page not found in original file!");
      continue;
    }

    // Collect all tokens from original page (flattened)
    List<String> allTokens = [];
    for (int i = startIdx + 1; i < allLines.length; i++) {
      String line = allLines[i].trim();
      if (line.startsWith('# Page')) break; // Next page
      if (line.isEmpty) continue;
      
      // Tokenize and add to flat list
      List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
      allTokens.addAll(lineTokens);
    }

    // ========================================
    // STEP 2: Get DB line profile for this page
    // ========================================
    final dbGlyphs = await db.query(
      'glyphs',
      where: 'page_number = ?',
      whereArgs: [page],
      orderBy: 'line_number ASC, position ASC',
    );

    // Group glyphs by line number
    Map<int, int> lineGlyphCounts = {};
    for (var glyph in dbGlyphs) {
      int line = glyph['line_number'] as int? ?? 0;
      if (line > 0) {
        lineGlyphCounts[line] = (lineGlyphCounts[line] ?? 0) + 1;
      }
    }

    // Get sorted list of DB lines
    List<int> dbLines = lineGlyphCounts.keys.toList()..sort();

    // ========================================
    // STEP 3: Redistribute tokens to match DB lines
    // ========================================
    Map<int, List<String>> newLineDistribution = {};
    int tokenIndex = 0;

    for (int dbLine in dbLines) {
      int glyphCount = lineGlyphCounts[dbLine]!;
      List<String> tokensForLine = [];
      
      // Assign next N tokens to this line
      for (int i = 0; i < glyphCount && tokenIndex < allTokens.length; i++) {
        tokensForLine.add(allTokens[tokenIndex]);
        tokenIndex++;
      }
      
      newLineDistribution[dbLine] = tokensForLine;
    }

    // Track if restructuring occurred
    bool wasRestructured = allTokens.length != tokenIndex;
    if (wasRestructured) restructuredPages++;

    // ========================================
    // STEP 4: Write to new file with ALL 15 lines
    // ========================================
    newContent.writeln("# Page $page");
    
    for (int line = 1; line <= 15; line++) {
      if (newLineDistribution.containsKey(line)) {
        // Line has content
        String lineContent = newLineDistribution[line]!.join(' ');
        newContent.writeln(lineContent);
      } else {
        // Empty line (DB has no glyphs for this line)
        newContent.writeln('');
      }
    }

    processedPages++;
    
    if (page % 100 == 0) {
      print("✅ Processed $page pages...");
    }
  }

  await db.close();

  // ========================================
  // STEP 5: Write new file
  // ========================================
  print("\n💾 Writing new mushaf_v2_map_NEW.txt...");
  File(newMapPath).writeAsStringSync(newContent.toString());

  print("\n" + "=" * 80);
  print("📊 RESTRUCTURING COMPLETE:");
  print("=" * 80);
  print("Total pages processed: $processedPages / 604");
  print("Pages restructured: $restructuredPages");
  print("Output file: $newMapPath");
  print("");
  print("✅ Next steps:");
  print("1. Review the new file");
  print("2. Backup original: mushaf_v2_map.txt → mushaf_v2_map_BACKUP.txt");
  print("3. Replace: mushaf_v2_map_NEW.txt → mushaf_v2_map.txt");
  print("4. Run verification audit");
  print("=" * 80);

  exit(0);
}
