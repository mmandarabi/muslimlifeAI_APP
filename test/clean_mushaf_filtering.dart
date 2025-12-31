import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Clean mushaf text file by filtering source file using layout database
/// 
/// This approach:
/// 1. Reads original mushaf_v2_map.txt line by line  
/// 2. Uses layout DB to identify line types for each page
/// 3. Keeps only ayah lines, skips headers and bismillah
void main() {
  test('Clean mushaf using source file + layout DB filtering', () async {
    print('='*80);
    print('MUSHAF TEXT CLEANING - SOURCE FILE FILTERING');
    print('='*80);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final sourceFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final outputPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED_FINAL.txt';
    
    print('\nInput:');
    print('  Source: mushaf_v2_map.txt');
    print('  Layout DB: qpc-v2-15-lines.db');
    print('\nOutput: mushaf_v2_map_CLEANED_FINAL.txt\n');
    
    // Open layout DB
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Read source file
    final sourceContent = await File(sourceFilePath).readAsString();
    final sourceLines = sourceContent.replaceAll('\r\n', '\n').split('\n');
    
    // Group source lines by page
    final sourceByPage = <int, List<String>>{};
    for (final line in sourceLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null) {
          sourceByPage.putIfAbsent(pageNum, () => []).add(trimmed);
        }
      }
    }
    
    print('Source file parsed: ${sourceByPage.length} pages\n');
    
    // Prepare output
    final outputFile = File(outputPath);
    if (await outputFile.exists()) await outputFile.delete();
    final sink = outputFile.openWrite();
    
    int totalPages = 0, ayahLinesKept = 0, headersRemoved = 0, bismillahRemoved = 0;
    int matchedPages = 0, mismatchedPages = 0;
    
    // Process each page
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) print('  Processing page $pageNum...');
      
      // Get layout for this page
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type
        FROM pages WHERE page_number = ? ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) continue;
      totalPages++;
      
      // Get source lines for this page
      final pageSourceLines = sourceByPage[pageNum] ?? [];
      
      // Get expected ayah count
      final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
      
      // If source matches ayah count exactly, we can use direct mapping
      if (pageSourceLines.length == ayahCount) {
        // Perfect match - source already has headers/bismillah removed
        for (final line in pageSourceLines) {
          sink.writeln(line);
          ayahLinesKept++;
        }
        matchedPages++;
      } else if (pageSourceLines.length == layoutResult.length) {
        // Source has ALL lines - filter by layout DB
        int sourceIndex = 0;
        for (var layoutRow in layoutResult) {
          final lineType = layoutRow['line_type'] as String;
          
          if (sourceIndex >= pageSourceLines.length) break;
          
          if (lineType == 'surah_name') {
            headersRemoved++;
            sourceIndex++;
          } else if (lineType == 'basmallah') {
            bismillahRemoved++;
            sourceIndex++;
          } else if (lineType == 'ayah') {
            sink.writeln(pageSourceLines[sourceIndex]);
            ayahLinesKept++;
            sourceIndex++;
          }
        }
        matchedPages++;
      } else {
        // Mismatch - log warning and skip
        mismatchedPages++;
        print('  ⚠️  Page $pageNum: source has ${pageSourceLines.length} lines, expected $ayahCount ayah or ${layoutResult.length} total');
      }
    }
    
    await sink.close();
    await layoutDb.close();
    
    final fileSize = (await outputFile.length() / 1024).toStringAsFixed(2);
    
    print('\n' + '='*80);
    print('COMPLETE');
    print('='*80);
    print('Pages: $totalPages / 604');
    print('Matched pages: $matchedPages');
    print('Mismatched pages: $mismatchedPages');
    print('Headers removed: $headersRemoved');
    print('Bismillah removed: $bismillahRemoved');
    print('Ayah lines kept: $ayahLinesKept');
    print('Output size: $fileSize KB');
    print('='*80);
    
  }, timeout: const Timeout(Duration(minutes: 10)));
}
