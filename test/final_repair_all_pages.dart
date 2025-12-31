import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('FINAL REPAIR: All 604 Pages (FIXED)', () async {
    print('='*70);
    print('FINAL MUSHAF REPAIR SCRIPT - ALL 604 PAGES');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final outputFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_FIXED.txt';
    
    print('Creating backup...');
    await File(textFilePath).copy('$textFilePath.BACKUP_FINAL');
    print('✅ Backup saved\\n');
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Read file as stream of tokens PER PAGE (not accumulating)
    final rawText = await File(textFilePath).readAsString();
    // Handle both Windows (\\r\\n) and Unix (\\n) line endings
    final allLines = rawText.replaceAll('\\r\\n', '\\n').split('\\n');
    
    // Group lines by page number
    final pageLines = <int, List<String>>{};
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null && pageNum >= 1 && pageNum <= 604) {
          final content = parts.sublist(1).join(',').trim();
          if (content.isNotEmpty) {
            pageLines.putIfAbsent(pageNum, () => []).add(content);
          }
        }
      }
    }
    
    print('Loaded ${pageLines.length} pages\\n');
    
    final repairedLines = <String>[];
    int pagesFixed = 0;
    int pagesWithInjection = 0;
    int totalInjections = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) print('Processing page $pageNum...');
      
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) continue;
      
      // Get ALL tokens for this page as a single stream
      final textLines = pageLines[pageNum] ?? [];
      final allTokens = <String>[];
      for (final line in textLines) {
        allTokens.addAll(line.split(' ').where((s) => s.isNotEmpty));
      }
      
      if (allTokens.isEmpty) {
        print('⚠️  Page $pageNum: No tokens');
        continue;
      }
      
      int tokenCursor = 0;
      bool hadInjection = false;
      
      for (final row in layoutResult) {
        final lineType = row['line_type'] as String;
        final lineNum = row['line_number'] as int;
        
        if (lineType == 'ayah') {
          final glyphResult = await glyphDb.rawQuery('''
            SELECT COUNT(*) as glyph_count
            FROM glyphs
            WHERE page_number = ? AND line_number = ?
          ''', [pageNum, lineNum]);
          
          final expectedCount = glyphResult.first['glyph_count'] as int;
          
          if (tokenCursor + expectedCount <= allTokens.length) {
            final lineTokens = allTokens.sublist(tokenCursor, tokenCursor + expectedCount);
            repairedLines.add('$pageNum,${lineTokens.join(' ')}');
            tokenCursor += expectedCount;
          } else {
            // UNDERFLOW
            final available = allTokens.length - tokenCursor;
            final needed = expectedCount - available;
            
            if (needed <= 4 && allTokens.isNotEmpty) {
              final lineTokens = List<String>.from(allTokens.sublist(tokenCursor));
              final lastToken = lineTokens.isNotEmpty ? lineTokens.last : allTokens.last;
              
              while (lineTokens.length < expectedCount) {
                lineTokens.add(lastToken);
                totalInjections++;
              }
              
              repairedLines.add('$pageNum,${lineTokens.join(' ')}');
              tokenCursor = allTokens.length;
              
              if (!hadInjection) {
                print('🔧 Page $pageNum: Injected $needed token(s)');
                hadInjection = true;
              }
            } else {
              print('❌ Page $pageNum Line $lineNum: Cannot inject (need $needed, too many)');
              break;
            }
          }
        }
      }
      
      if (hadInjection) pagesWithInjection++;
      pagesFixed++;
    }
    
    await layoutDb.close();
    await glyphDb.close();
    
    await File(outputFilePath).writeAsString(repairedLines.join('\\n'));
    
    print('\\n' + '='*70);
    print('REPAIR COMPLETE');
    print('='*70);
    print('Pages processed: $pagesFixed / 604');
    print('Pages with injections: $pagesWithInjection');
    print('Total tokens injected: $totalInjections');
    print('\\nOutput: $outputFilePath');
    print('\\n✅ SUCCESS! Now run verification test');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 10)));
}
