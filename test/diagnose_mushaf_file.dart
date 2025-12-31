import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Diagnose mushaf_v2_map.txt file structure', () async {
    print('='*70);
    print('DIAGNOSING MUSHAF TEXT FILE');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    
    // 1. Basic file analysis
    print('\n📊 BASIC FILE ANALYSIS');
    print('-'*70);
    final fileSize = await File(textFilePath).length();
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    final nonEmptyLines = allLines.where((l) => l.trim().isNotEmpty).toList();
    
    print('File size: ${(fileSize / 1024).toStringAsFixed(1)} KB');
    print('Total lines: ${nonEmptyLines.length}');
    print('Avg line size: ${(fileSize / nonEmptyLines.length).toStringAsFixed(1)} bytes');
    
    // 2. Group by page
    final pageLines = <int, List<String>>{};
    final pageLinesContent = <int, List<String>>{};
    
    for (final line in nonEmptyLines) {
      final parts = line.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null && pageNum >= 1 && pageNum <= 604) {
          pageLines.putIfAbsent(pageNum, () => []).add(line);
          final content = parts.sublist(1).join(',').trim();
          pageLinesContent.putIfAbsent(pageNum, () => []).add(content);
        }
      }
    }
    
    print('\nPages found: ${pageLines.length}');
    print('Lines per page (avg): ${(nonEmptyLines.length / pageLines.length).toStringAsFixed(1)}');
    
    // 3. Sample data from different pages
    print('\n📝 SAMPLE DATA');
    print('-'*70);
    
    for (final pageNum in [1, 2, 604]) {
      print('\nPage $pageNum (${pageLines[pageNum]?.length ?? 0} lines):');
      final lines = pageLines[pageNum] ?? [];
      for (int i = 0; i < (lines.length > 5 ? 5 : lines.length); i++) {
        final line = lines[i];
        final tokenCount = line.split(',').sublist(1).join(',').split(' ').where((t) => t.isNotEmpty).length;
        print('  Line ${i+1}: $tokenCount tokens - ${line.length} chars');
      }
    }
    
    // 4. Compare with layout database
    print('\n🔍 LAYOUT DATABASE COMPARISON');
    print('-'*70);
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Check Page 604 specifically
    final page604Layout = await layoutDb.rawQuery('''
      SELECT line_number, line_type
      FROM pages
      WHERE page_number = 604
      ORDER BY line_number
    ''');
    
    print('\nPage 604 Layout (from database):');
    print('  Total lines in layout DB: ${page604Layout.length}');
    for (var row in page604Layout) {
      print('  Line ${row['line_number']}: ${row['line_type']}');
    }
    
    print('\nPage 604 Text (from file):');
    print('  Total lines in text file: ${pageLines[604]?.length ?? 0}');
    
    // 5. Check for duplicates
    print('\n🔎 CHECKING FOR DUPLICATES');
    print('-'*70);
    
    final allLinesSet = <String>{};
    int duplicateCount = 0;
    
    for (final line in nonEmptyLines) {
      if (allLinesSet.contains(line)) {
        duplicateCount++;
      } else {
        allLinesSet.add(line);
      }
    }
    
    print('Unique lines: ${allLinesSet.length}');
    print('Duplicate lines: $duplicateCount');
    
    // 6. Token analysis
    print('\n🔢 TOKEN ANALYSIS');
    print('-'*70);
    
    int totalTokens = 0;
    int minTokensPerLine = 999999;
    int maxTokensPerLine = 0;
    
    for (final lines in pageLinesContent.values) {
      for (final line in lines) {
        final tokens = line.split(' ').where((t) => t.isNotEmpty).toList();
        totalTokens += tokens.length;
        if (tokens.length < minTokensPerLine) minTokensPerLine = tokens.length;
        if (tokens.length > maxTokensPerLine) maxTokensPerLine = tokens.length;
      }
    }
    
    print('Total tokens: $totalTokens');
    print('Avg tokens per line: ${(totalTokens / nonEmptyLines.length).toStringAsFixed(1)}');
    print('Min tokens per line: $minTokensPerLine');
    print('Max tokens per line: $maxTokensPerLine');
    
    // 7. Glyph database comparison
    print('\n📐 GLYPH DATABASE COMPARISON');
    print('-'*70);
    
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final totalGlyphsResult = await glyphDb.rawQuery('SELECT COUNT(*) as total FROM glyphs');
    final totalGlyphs = totalGlyphsResult.first['total'] as int;
    
    print('Total glyphs in ayahinfo.db: $totalGlyphs');
    print('Total tokens in text file: $totalTokens');
    print('Difference: ${totalTokens - totalGlyphs}');
    
    if (totalTokens > totalGlyphs) {
      print('⚠️  Text file has MORE tokens than expected!');
      print('   Likely contains: ayah numbers, extra markers, or duplicates');
    }
    
    // 8. Check specific page
    final page604Glyphs = await glyphDb.rawQuery('''
      SELECT COUNT(*) as total
      FROM glyphs
      WHERE page_number = 604
    ''');
    
    final expectedGlyphs604 = page604Glyphs.first['total'] as int;
    final actualTokens604 = pageLinesContent[604]!.map((line) => 
      line.split(' ').where((t) => t.isNotEmpty).length
    ).reduce((a, b) => a + b);
    
    print('\nPage 604 specifically:');
    print('  Expected glyphs (from ayahinfo.db): $expectedGlyphs604');
    print('  Actual tokens (from text file): $actualTokens604');
    print('  Difference: ${actualTokens604 - expectedGlyphs604}');
    
    await layoutDb.close();
    await glyphDb.close();
    
    // 9. Sample token inspection
    print('\n🔬 SAMPLE TOKEN INSPECTION (Page 604, Line 3)');
    print('-'*70);
    
    if (pageLinesContent[604]!.length >= 3) {
      final line3 = pageLinesContent[604]![2]; // 0-indexed, so line 3 is index 2
      final tokens = line3.split(' ').where((t) => t.isNotEmpty).toList();
      print('Tokens (${tokens.length} total):');
      for (int i = 0; i < tokens.length && i < 15; i++) {
        print('  $i: ${tokens[i]}');
      }
    }
    
    print('\n' + '='*70);
    print('DIAGNOSIS COMPLETE');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 5)));
}
