import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Analyze CLEANED file for critical pages', () async {
    print('='*70);
    print('ANALYZING mushaf_v2_map_CLEANED.txt');
    print('Critical Pages: 1, 2, 187, 604');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final cleanedFile = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED.txt';
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    
    // Read cleaned file
    final rawText = await File(cleanedFile).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    
    // Group by page
    final pageLines = <int, List<String>>{};
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null) {
          pageLines.putIfAbsent(pageNum, () => []).add(trimmed);
        }
      }
    }
    
    // Open layout database
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Analyze critical pages
    for (final pageNum in [1, 2, 187, 604]) {
      print('\n' + '='*70);
      print('PAGE $pageNum');
      print('='*70);
      
      // Get layout from database
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      print('\n📐 LAYOUT DATABASE (Expected):');
      print('   Total lines: ${layoutResult.length}');
      
      final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
      final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
      final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
      
      print('   - Ayah lines: $ayahCount');
      print('   - Header lines: $headerCount');
      print('   - Bismillah lines: $bismillahCount');
      
      // Show layout structure
      print('\n   Layout structure:');
      for (var row in layoutResult) {
        final lineNum = row['line_number'];
        final lineType = row['line_type'];
        final surahNum = row['surah_number'];
        print('   Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');
      }
      
      // Get actual lines from cleaned file
      final actualLines = pageLines[pageNum] ?? [];
      print('\n📄 CLEANED FILE (Actual):');
      print('   Total lines: ${actualLines.length}');
      
      if (actualLines.isEmpty) {
        print('   ⚠️  NO LINES IN CLEANED FILE!');
      } else {
        print('\n   Content:');
        for (int i = 0; i < actualLines.length; i++) {
          final line = actualLines[i];
          final content = line.split(',').sublist(1).join(',').trim();
          final tokenCount = content.split(' ').where((t) => t.isNotEmpty).length;
          final preview = content.length > 60 ? content.substring(0, 60) + '...' : content;
          print('   Line ${i+1}: $tokenCount tokens - $preview');
        }
      }
      
      // Comparison
      print('\n✅ COMPARISON:');
      print('   Expected ayah lines: $ayahCount');
      print('   Actual lines in file: ${actualLines.length}');
      
      if (actualLines.length == ayahCount) {
        print('   ✅ PERFECT MATCH - Headers/Bismillah properly removed');
      } else if (actualLines.length == layoutResult.length) {
        print('   ⚠️  File contains ALL lines (headers NOT removed)');
      } else {
        print('   ❌ MISMATCH - Expected $ayahCount ayah lines, got ${actualLines.length}');
      }
      
      // Special page notes
      if (pageNum == 1) {
        print('\n📝 SPECIAL: Page 1 (Al-Fatiha)');
        print('   Should have: 7 ayah lines (one per verse)');
        print('   Al-Fatiha has 7 verses, each on its own line');
      } else if (pageNum == 2) {
        print('\n📝 SPECIAL: Page 2 (Start of Al-Baqarah)');
        print('   Ornamental page with decorative frame');
      } else if (pageNum == 187) {
        print('\n📝 SPECIAL: Page 187 (Surah At-Tawbah)');
        print('   Should have NO bismillah (Surah 9 exception)');
        print('   Expected bismillah count: $bismillahCount');
      } else if (pageNum == 604) {
        print('\n📝 SPECIAL: Page 604 (Last page)');
        print('   Contains: Al-Ikhlas, Al-Falaq, An-Nas');
        print('   Multiple short surahs with headers/bismillah');
      }
    }
    
    // Summary statistics
    print('\n' + '='*70);
    print('SUMMARY STATISTICS');
    print('='*70);
    
    print('\nAll pages in cleaned file:');
    final sortedPages = pageLines.keys.toList()..sort();
    print('   First page: ${sortedPages.first}');
    print('   Last page: ${sortedPages.last}');
    print('   Total pages: ${sortedPages.length}');
    
    // Check for missing pages
    final missingPages = <int>[];
    for (int i = 1; i <= 604; i++) {
      if (!pageLines.containsKey(i)) {
        missingPages.add(i);
      }
    }
    
    if (missingPages.isEmpty) {
      print('   ✅ All 604 pages present');
    } else {
      print('   ❌ Missing pages (${missingPages.length}): ${missingPages.take(10).join(", ")}...');
    }
    
    // Sample random pages
    print('\nSample random pages (lines per page):');
    for (final pageNum in [10, 50, 100, 200, 300, 400, 500, 600]) {
      if (pageLines.containsKey(pageNum)) {
        print('   Page $pageNum: ${pageLines[pageNum]!.length} lines');
      }
    }
    
    await layoutDb.close();
    
    print('\n' + '='*70);
    print('ANALYSIS COMPLETE');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 5)));
}
