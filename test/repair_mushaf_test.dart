import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Automated Data Repair - Merge Text Lines Based on Database Glyph Counts', () async {
    print('\n' + '='*70);
    print('MUSHAF DATA REPAIR TEST');
    print('='*70);
    print('\nThis test will repair mushaf_v2_map.txt by merging text lines');
    print('to match the database glyph counts for all 604 pages.\n');
    
    // Initialize SQLite FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // Paths
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final outputFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_REPAIRED.txt';
    
    // Verify files exist
    expect(File(layoutDbPath).existsSync(), true, reason: 'Layout database must exist');
    expect(File(glyphDbPath).existsSync(), true, reason: 'Glyph database must exist');
    expect(File(textFilePath).existsSync(), true, reason: 'Text file must exist');
    
    print('✅ All required files found\n');
    
    // Open databases
    final layoutDb = await openDatabase(layoutDbPath, readOnly: true);
    final glyphDb = await openDatabase(glyphDbPath, readOnly: true);
    
    // Read original text file
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.split('\n');
    
    // Parse all pages
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
    
    // Process each page
    final repairedLines = <String>[];
    int pagesProcessed = 0;
    int pagesSkipped = 0;
    int pagesFailed = 0;
    final failedPages = <int>[];
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) {
        print('Processing Page $pageNum...');
      }
      
      // EXCEPTION 1: Skip Pages 1-2 (ornamental frames)
      if (pageNum == 1 || pageNum == 2) {
        // Copy original lines as-is
        final originalLines = pageData[pageNum] ?? [];
        for (final line in originalLines) {
          repairedLines.add('$pageNum,$line');
        }
        pagesSkipped++;
        continue;
      }
      
      // Get layout structure from database
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) {
        print('  ❌ Page $pageNum: No layout data found in database');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Get ayah lines and their glyph counts
      final ayahLines = <Map<String, dynamic>>[];
      bool hasBismillah = false;
      int? surahNumber;
      
      for (final row in layoutResult) {
        final lineType = row['line_type'] as String;
        
        if (lineType == 'surah_name') {
          surahNumber = row['surah_number'] as int?;
        } else if (lineType == 'basmallah') {
          hasBismillah = true;
        } else if (lineType == 'ayah') {
          final lineNum = row['line_number'] as int;
          
          // Get glyph count for this line
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
      }
      
      // EXCEPTION 2: Surah 9 (At-Tawbah) has no Bismillah
      if (pageNum == 187 && surahNumber == 9 && hasBismillah) {
        print('  ⚠️  Page $pageNum: WARNING - Database shows Bismillah for Surah 9');
      }
      
      // Get raw text lines for this page
      final rawPageLines = pageData[pageNum] ?? [];
      
      if (rawPageLines.isEmpty) {
        print('  ❌ Page $pageNum: No text lines found');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Merge text lines to match database glyph counts
      final mergedLines = <String>[];
      int textCursor = 0;
      bool hasError = false;
      
      for (final ayahLine in ayahLines) {
        final targetGlyphCount = ayahLine['glyph_count'] as int;
        
        // Accumulate glyphs until we reach the target count
        final accumulatedGlyphs = <String>[];
        int currentGlyphCount = 0;
        
        while (currentGlyphCount < targetGlyphCount && textCursor < rawPageLines.length) {
          final textLine = rawPageLines[textCursor];
          final glyphs = textLine.split(' ').where((s) => s.isNotEmpty).toList();
          
          accumulatedGlyphs.addAll(glyphs);
          currentGlyphCount += glyphs.length;
          textCursor++;
          
          // If we've reached or exceeded the target, stop
          if (currentGlyphCount >= targetGlyphCount) {
            break;
          }
        }
        
        // Verify we got the exact count
        if (currentGlyphCount != targetGlyphCount) {
          print('  ❌ Page $pageNum Line ${ayahLine['line_number']}: Expected $targetGlyphCount glyphs, got $currentGlyphCount');
          hasError = true;
          break;
        }
        
        // Join the accumulated glyphs
        mergedLines.add(accumulatedGlyphs.join(' '));
      }
      
      if (hasError) {
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Check if we consumed all text lines
      if (textCursor < rawPageLines.length) {
        final remaining = rawPageLines.length - textCursor;
        if (pageNum == 604) {
          print('  ⚠️  Page $pageNum: $remaining text lines remain unconsumed');
        }
      }
      
      // Verify we got the expected number of lines
      if (mergedLines.length != ayahLines.length) {
        print('  ❌ Page $pageNum: Expected ${ayahLines.length} merged lines, got ${mergedLines.length}');
        pagesFailed++;
        failedPages.add(pageNum);
        continue;
      }
      
      // Add merged lines to output
      for (final line in mergedLines) {
        repairedLines.add('$pageNum,$line');
      }
      
      if (pageNum == 604) {
        print('  ✅ Page 604: Merged ${rawPageLines.length} lines → ${mergedLines.length} lines');
      }
      pagesProcessed++;
    }
    
    // Close databases
    await layoutDb.close();
    await glyphDb.close();
    
    // Write repaired file
    await File(outputFilePath).writeAsString(repairedLines.join('\n'));
    
    // Summary
    print('\n' + '='*70);
    print('REPAIR COMPLETE');
    print('='*70);
    print('Pages processed: $pagesProcessed');
    print('Pages skipped: $pagesSkipped');
    print('Pages failed: $pagesFailed');
    if (failedPages.isNotEmpty) {
      print('Failed pages: ${failedPages.take(10).join(", ")}${failedPages.length > 10 ? "..." : ""}');
    }
    print('\nRepaired file written to: $outputFilePath');
    print('\nNext steps:');
    print('1. Review the repaired file');
    print('2. Run glyph_count_validation_test.dart to verify');
    print('3. Replace original file if validation passes');
    print('='*70 + '\n');
    
    // Verify the repair was successful
    expect(pagesProcessed, greaterThan(500), reason: 'Should process most pages successfully');
    expect(File(outputFilePath).existsSync(), true, reason: 'Repaired file must be created');
  });
}
