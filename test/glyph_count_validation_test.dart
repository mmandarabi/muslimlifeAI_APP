import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // Set database path for testing
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db';
    if (File(dbPath).existsSync()) {
      MushafLayoutService.overrideDbPath = dbPath;
    }
  });

  test('GLYPH COUNT VALIDATION: Raw Text vs Database for Page 604', () async {
    print('\n' + '='*70);
    print('GLYPH COUNT VALIDATION TEST - Page 604');
    print('This test reads RAW text (NO MERGING) and validates glyph counts');
    print('='*70 + '\n');
    
    // Step 1: Get layout from database
    final layout = await MushafLayoutService.getPageLayout(604);
    
    print('STEP 1: Database Layout Structure');
    print('-' * 50);
    for (var line in layout) {
      print('  Line ${line.lineNumber}: ${line.lineType.padRight(12)} surah=${line.surahNumber ?? "-"}');
    }
    
    final ayahLines = layout.where((l) => l.lineType == 'ayah').toList();
    print('\n  Total ayah lines in DB: ${ayahLines.length}');
    
    // Step 2: Read RAW text file (bypassing MushafTextService merge logic)
    print('\nSTEP 2: Reading RAW Text File (mushaf_v2_map.txt)');
    print('-' * 50);
    
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    if (!File(textFilePath).existsSync()) {
      fail('Text file not found at: $textFilePath');
    }
    
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.split('\n');
    
    // Find Page 604 lines (format: "604,glyph glyph glyph...")
    final rawPageLines = <String>[];
    
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('604,')) {
        // Extract glyphs after the page number
        final glyphs = trimmed.substring(4).trim(); // Remove "604,"
        if (glyphs.isNotEmpty) {
          rawPageLines.add(glyphs);
        }
      }
    }
    
    if (rawPageLines.isEmpty) {
      fail('Could not find page 604 in mushaf_v2_map.txt');
    }
    
    print('  Raw text lines found: ${rawPageLines.length}');
    for (int i = 0; i < rawPageLines.length; i++) {
      final preview = rawPageLines[i].length > 30 ? rawPageLines[i].substring(0, 30) : rawPageLines[i];
      final glyphCount = rawPageLines[i].split(' ').where((s) => s.isNotEmpty).length;
      print('  [$i]: $preview... (${glyphCount} glyphs)');
    }
    
    // Step 3: CRITICAL - Validate glyph counts against database
    print('\nSTEP 3: Glyph Count Validation');
    print('-' * 50);
    
    // Get glyph counts from ayahinfo.db
    final db = await openDatabase(
      'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db',
      readOnly: true,
    );
    
    final glyphCounts = <int, int>{};
    for (var ayahLine in ayahLines) {
      final result = await db.rawQuery('''
        SELECT COUNT(*) as glyph_count
        FROM glyphs
        WHERE page_number = 604 AND line_number = ?
      ''', [ayahLine.lineNumber]);
      
      glyphCounts[ayahLine.lineNumber] = result.first['glyph_count'] as int;
    }
    
    await db.close();
    
    print('\nDatabase Glyph Counts per Ayah Line:');
    for (var entry in glyphCounts.entries) {
      print('  Line ${entry.key}: ${entry.value} glyphs');
    }
    
    // Step 4: Map raw text lines to database lines and validate
    print('\nSTEP 4: Line-by-Line Validation');
    print('-' * 50);
    
    int textCursor = 0;
    bool hasError = false;
    final errors = <String>[];
    
    for (int gridIndex = 0; gridIndex < 15; gridIndex++) {
      final lineNum = gridIndex + 1;
      final lineData = layout.firstWhere((l) => l.lineNumber == lineNum);
      
      if (lineData.lineType == 'ayah') {
        if (textCursor >= rawPageLines.length) {
          final error = '❌ Line $lineNum: DB expects ayah but NO TEXT AVAILABLE (cursor=$textCursor)';
          print(error);
          errors.add(error);
          hasError = true;
          continue;
        }
        
        final textLine = rawPageLines[textCursor];
        final textGlyphCount = textLine.split(' ').where((s) => s.isNotEmpty).length;
        final dbGlyphCount = glyphCounts[lineNum]!;
        
        final preview = textLine.length > 30 ? textLine.substring(0, 30) : textLine;
        
        if (textGlyphCount == dbGlyphCount) {
          print('  ✅ Line $lineNum: $textGlyphCount glyphs match DB ($preview...)');
        } else {
          final error = '❌ Line $lineNum: TEXT has $textGlyphCount glyphs but DB expects $dbGlyphCount';
          print(error);
          print('     Text: $preview...');
          errors.add(error);
          hasError = true;
        }
        
        textCursor++;
      } else {
        print('  ⏭️  Line $lineNum: ${lineData.lineType.toUpperCase()} (surah=${lineData.surahNumber ?? "-"})');
      }
    }
    
    // Step 5: Check for overflow (text remaining after all ayah lines consumed)
    print('\nSTEP 5: Overflow Detection');
    print('-' * 50);
    
    if (textCursor < rawPageLines.length) {
      final remaining = rawPageLines.length - textCursor;
      final error = '❌ OVERFLOW: $remaining text lines remain unconsumed after processing all DB ayah lines';
      print(error);
      print('  Remaining lines:');
      for (int i = textCursor; i < rawPageLines.length; i++) {
        final preview = rawPageLines[i].length > 30 ? rawPageLines[i].substring(0, 30) : rawPageLines[i];
        print('    [$i]: $preview...');
      }
      errors.add(error);
      hasError = true;
    } else {
      print('  ✅ All text lines consumed correctly');
    }
    
    // Final Report
    print('\n' + '='*70);
    if (hasError) {
      print('❌ TEST FAILED - DATA LEAKS DETECTED');
      print('='*70);
      print('\nERROR SUMMARY:');
      for (var error in errors) {
        print('  • $error');
      }
      print('\nRECOMMENDATION:');
      print('  The mushaf_v2_map.txt file has incorrect line breaks for Page 604.');
      print('  Lines need to be merged to match the database glyph counts.');
      print('\n');
      fail('Glyph count validation failed - see errors above');
    } else {
      print('✅ ALL VALIDATIONS PASSED');
      print('='*70);
      print('\nSUMMARY:');
      print('  • Raw text lines: ${rawPageLines.length}');
      print('  • Database ayah lines: ${ayahLines.length}');
      print('  • All glyph counts match');
      print('  • No overflow detected');
      print('\n');
    }
  });
}
