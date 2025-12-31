import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

/// COMPREHENSIVE Mushaf Text File Cleaner and Repairer
/// 
/// This script:
/// 1. Reads layout DB to identify ayah lines (skip header/bismillah lines)
/// 2. Reads glyph DB to get exact glyph counts for ayah lines
/// 3. Extracts ONLY ayah glyphs from the mixed text file
/// 4. Writes a clean text file with only ayah text (no headers/bismillah)
void main() {
  test('Clean and Repair mushaf_v2_map.txt for all 604 pages', () async {
    print('='*70);
    print('MUSHAF TEXT FILE CLEANER AND REPAIRER');
    print('='*70);
    print('\nThis script will:');
    print('1. Remove header and bismillah glyphs from the text file');
    print('2. Extract ONLY ayah glyphs');
    print('3. Merge text lines to match database glyph counts\n');
    
    // Initialize SQLite FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // Paths
    final layoutDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db';
    final glyphDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
    final textFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    final outputFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map_CLEAN.txt';
    
    // Verify files exist
    expect(File(layoutDbPath).existsSync(), true);
    expect(File(glyphDbPath).existsSync(), true);
    expect(File(textFilePath).existsSync(), true);
    
    print('✅ All required files found\n');
    
    // Open databases
    final layoutDb = await openDatabase(layoutDbPath, readOnly: true);
    final glyphDb = await openDatabase(glyphDbPath, readOnly: true);
    
    // Read original text file
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.split('\n');
    
    // Parse all pages into raw text
    final pageData = <int, List<String>>{};
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length != 2) continue;
      
      final pageNum = int.tryParse(parts[0]);
      if (pageNum == null || pageNum < 1 || pageNum > 604) continue;
      
      final glyphs = parts[1].trim();
      if (glyphs.isEmpty) continue;
      
      pageData.putIfAbsent(pageNum, () => []).add(glyphs);
    }
    
    print('Parsed ${pageData.length} pages from text file\n');
    
    // DRIFT MAP (from MushafTextService)
    // Positive values = Missing markers (Sajdah/Hizb) - text file has FEWER glyphs than database
    // Negative values = Extra glyphs - text file has MORE glyphs than database
    const driftMap = <int, int>{
      // Drift +1 (Missing 1 marker)
      2: 1, 5: 1, 19: 1, 21: 1, 22: 1, 23: 1, 26: 1, 28: 1, 30: 1, 35: 1,
      43: 1, 44: 1, 47: 1, 48: 1, 56: 1, 100: 1, 108: 1, 109: 1, 112: 1, 117: 1, 124: 1, 125: 1,
      133: 1, 137: 1, 148: 1, 151: 1, 154: 1, 159: 1, 167: 1, 170: 1, 171: 1, 173: 1,
      179: 1, 180: 1, 182: 1, 188: 1, 195: 1, 199: 1, 203: 1, 209: 1, 210: 1, 211: 1,
      214: 1, 215: 1, 218: 1, 240: 1, 243: 1, 252: 1, 256: 1, 258: 1, 262: 1, 265: 1,
      269: 1, 270: 1, 271: 1, 272: 1, 275: 1, 276: 1, 281: 1, 289: 1, 290: 1, 305: 1,
      346: 1, 355: 1, 360: 1, 364: 1, 367: 1, 385: 1, 389: 1, 396: 1, 400: 1, 403: 1,
      404: 1, 411: 1, 415: 1, 422: 1, 430: 1, 435: 1, 440: 1, 441: 1, 447: 1, 455: 1,
      456: 1, 459: 1, 460: 1, 462: 1, 467: 1, 468: 1, 473: 1, 475: 1, 477: 1, 479: 1, 481: 1, 483: 1,
      484: 1, 489: 1, 496: 1, 497: 1, 499: 1, 502: 1, 507: 1, 509: 1, 538: 1, 541: 1,
      544: 1, 549: 1, 550: 1, 551: 1, 559: 1, 565: 1, 575: 1, 590: 1,
      
      // Drift +2
      107: 2, 128: 2, 134: 2, 172: 2, 183: 2, 184: 2, 187: 2, 190: 2, 225: 2,
      278: 2, 312: 2, 343: 2, 350: 2, 576: 2,
      
      // Drift +3
      24: 3, 273: 3, 569: 3,
      
      // Drift +23 and +25
      150: 23, 186: 25, 457: 25,
      
      // HARD TRUNCATION (Extra glyphs)
      374: -23,
    };
    
    // Process each page
    final cleanedLines = <String>[];
    int pagesProcessed = 0;
    int pagesSkipped = 0;
    int pagesFailed = 0;
    final failedPages = <int>[];
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 50 == 0) {
        print('Processing Page $pageNum...');
      }
      
      // Get layout structure from database
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) {
        print('  ❌ Page $pageNum: No layout data in database');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Get ONLY ayah lines and their glyph counts
      final ayahLines = <Map<String, dynamic>>[];
      
      for (final row in layoutResult) {
        final lineType = row['line_type'] as String;
        
        if (lineType == 'ayah') {
          final lineNum = row['line_number'] as int;
          
          // Get glyph count for this ayah line
          final glyphResult = await glyphDb.rawQuery('''
            SELECT COUNT(*) as glyph_count
            FROM glyphs
            WHERE page_number = ? AND line_number = ?
          ''', [pageNum, lineNum]);
          
          final glyphCount = glyphResult.first['glyph_count'] as int;
          
          ayahLines.add({
            'line_number': lineNum,
            'glyph_count': glyphCount,
          });
        }
        // SKIP header and bismillah lines - they're rendered by widgets!
      }
      
      // Get raw text lines for this page
      final rawPageLines = pageData[pageNum] ?? [];
      
      if (rawPageLines.isEmpty) {
        print('  ❌ Page $pageNum: No text lines found');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Flatten all text into a single glyph pool
      final allGlyphs = <String>[];
      for (final textLine in rawPageLines) {
        final glyphs = textLine.split(' ').where((s) => s.isNotEmpty).toList();
        allGlyphs.addAll(glyphs);
      }
      
      // Calculate total expected ayah glyphs
      final totalExpectedGlyphs = ayahLines.fold<int>(
        0, 
        (sum, line) => sum + (line['glyph_count'] as int)
      );
      
      // Account for drift (missing or extra markers)
      final drift = driftMap[pageNum] ?? 0;
      final totalExpectedWithDrift = totalExpectedGlyphs - drift; // Subtract because positive drift means MISSING glyphs
      
      // CRITICAL: Check if we have excess glyphs (headers/bismillah)
      final excessGlyphs = allGlyphs.length - totalExpectedWithDrift;
      
      if (excessGlyphs < 0) {
        print('  ❌ Page $pageNum: Missing ${-excessGlyphs} glyphs (expected $totalExpectedWithDrift, got ${allGlyphs.length}, drift=$drift)');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Skip the excess glyphs at the START (they're headers/bismillah)
      final cleanGlyphs = excessGlyphs > 0 
        ? allGlyphs.sublist(excessGlyphs)
        : allGlyphs;
      
      if (cleanGlyphs.length != totalExpectedWithDrift) {
        print('  ❌ Page $pageNum: After removing $excessGlyphs excess glyphs, got ${cleanGlyphs.length} but expected $totalExpectedWithDrift');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Now merge clean glyphs into ayah lines based on glyph counts
      final mergedLines = <String>[];
      int glyphCursor = 0;
      
      for (final ayahLine in ayahLines) {
        final targetGlyphCount = ayahLine['glyph_count'] as int;
        
        if (glyphCursor + targetGlyphCount > cleanGlyphs.length) {
          print('  ❌ Page $pageNum Line ${ayahLine['line_number']}: Not enough glyphs remaining');
          pagesFailed++;
          failedPages.add(pageNum);
          break;
        }
        
        final lineGlyphs = cleanGlyphs.sublist(glyphCursor, glyphCursor + targetGlyphCount);
        mergedLines.add(lineGlyphs.join(' '));
        glyphCursor += targetGlyphCount;
      }
      
      // Verify we consumed all glyphs
      if (glyphCursor != cleanGlyphs.length) {
        print('  ❌ Page $pageNum: Consumed $glyphCursor glyphs but had ${cleanGlyphs.length}');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Add merged lines to output
      for (final line in mergedLines) {
        cleanedLines.add('$pageNum,$line');
      }
      
      if (pageNum == 1 || pageNum == 2 || pageNum == 604 || pageNum % 100 == 0) {
        print('  ✅ Page $pageNum: $excessGlyphs excess glyphs removed → ${mergedLines.length} clean ayah lines (${cleanGlyphs.length} glyphs total)');
      }
      pagesProcessed++;
    }
    
    // Close databases
    await layoutDb.close();
    await glyphDb.close();
    
    // Write cleaned file
    await File(outputFilePath).writeAsString(cleanedLines.join('\n'));
    
    // Summary
    print('\n' + '='*70);
    print('CLEANING COMPLETE');
    print('='*70);
    print('Pages processed: $pagesProcessed');
    print('Pages skipped: $pagesSkipped');
    print('Pages failed: $pagesFailed');
    
    if (failedPages.isNotEmpty) {
      print('\nFailed pages: ${failedPages.take(20).join(", ")}${failedPages.length > 20 ? "..." : ""}');
    }
    
    print('\nCleaned file written to: $outputFilePath');
    print('\nNext steps:');
    print('1. Review the cleaned file');
    print('2. Replace mushaf_v2_map.txt with mushaf_v2_map_CLEAN.txt');
    print('3. Re-run Juz 30 tests to verify');
    print('='*70);
    
    // Verify success (allow some failures for investigation)
    if (pagesFailed > 0) {
      print('\n⚠️ WARNING: ${failedPages.length} pages failed cleaning.');
      print('These pages may need manual review.');
    }
    
    print('\n✅ Cleaning script completed. Review output file.');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
