import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CORRECT APPROACH: Clean mushaf_v2_map.txt
/// 
/// The file is LINE-BY-LINE format: pageNum,tokens
/// Each line corresponds to one visual line on the Mushaf page
/// 
/// We need to:
/// 1. Match each text line with its layout type from qpc-v1-15-lines.db
/// 2. Keep ONLY lines where line_type = 'ayah'
/// 3. Skip lines where line_type = 'surah_name' or 'basmallah'

void main() {
  test('Clean mushaf_v2_map.txt - Remove headers and bismillah', () async {
    print('='*70);
    print('CLEANING MUSHAF TEXT FILE');
    print('Following: Quran_Asset_Architecture.md - Phase 1, Step 1.1');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final outputFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED.txt';
    
    // 1. Create backup
    print('\n📦 Creating backup...');
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    await File(textFilePath).copy('$textFilePath.BACKUP_$timestamp');
    print('   ✅ Backup saved\n');
    
    // 2. Open layout database
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // 3. Read current text file LINE BY LINE
    print('📖 Reading current text file...');
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    
    // Group lines by page AND line number
    final pageLineMap = <int, Map<int, String>>{};
    int lineIndex = 0;
    
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null && pageNum >= 1 && pageNum <= 604) {
          final content = parts.sublist(1).join(',').trim();
          if (content.isNotEmpty) {
            // Track which line index this is for the page
            pageLineMap.putIfAbsent(pageNum, () => {});
            final lineNumForPage = pageLineMap[pageNum]!.length + 1;
            pageLineMap[pageNum]![lineNumForPage] = content;
          }
        }
      }
    }
    
    print('   ✅ Loaded ${pageLineMap.length} pages\n');
    
    // 4. Process each page and filter by line type
    print('🔧 Processing and filtering...\n');
    final cleanedLines = <String>[];
    int totalLinesIn = 0;
    int totalLinesOut = 0;
    int skippedHeaders = 0;
    int skippedBismillah = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) print('   Processing page $pageNum...');
      
      // Get layout for this page
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) continue;
      
      final pageLinesText = pageLineMap[pageNum] ?? {};
      totalLinesIn += pageLinesText.length;
      
      // Match each layout line with its text
      for (final row in layoutResult) {
        final lineNum = row['line_number'] as int;
        final lineType = row['line_type'] as String;
        
        // Check if we have text for this line number
        if (pageLinesText.containsKey(lineNum)) {
          final lineText = pageLinesText[lineNum]!;
          
          if (lineType == 'ayah') {
            // ✅ KEEP ayah lines
            cleanedLines.add('$pageNum,$lineText');
            totalLinesOut++;
          } else if (lineType == 'surah_name') {
            // ❌ SKIP header lines (rendered by fonts)
            skippedHeaders++;
          } else if (lineType == 'basmallah') {
            // ❌ SKIP bismillah lines (rendered by Unicode \\uFDFD)
            skippedBismillah++;
          }
        }
      }
    }
    
    await layoutDb.close();
    
    // 5. Write cleaned file
    print('\n💾 Writing cleaned file...');
    await File(outputFilePath).writeAsString(cleanedLines.join('\n') + '\n');
    
    final originalSize = await File(textFilePath).length();
    final cleanedSize = await File(outputFilePath).length();
    
    print('\n' + '='*70);
    print('✅ CLEANING COMPLETE');
    print('='*70);
    print('Lines processed:');
    print('  Input:  $totalLinesIn lines');
    print('  Output: $totalLinesOut lines (ayah only)');
    print('  Skipped headers:    $skippedHeaders');
    print('  Skipped bismillah:  $skippedBismillah');
    print('\nFile sizes:');
    print('  Original: ${(originalSize / 1024).toStringAsFixed(1)} KB');
    print('  Cleaned:  ${(cleanedSize / 1024).toStringAsFixed(1)} KB');
    print('  Reduction: ${((originalSize - cleanedSize) / 1024).toStringAsFixed(1)} KB');
    print('\n📝 Expected: ~300 KB (per Architecture doc)');
    print('💾 Output: $outputFilePath');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 10)));
}
