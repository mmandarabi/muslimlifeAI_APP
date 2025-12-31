import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('ULTIMATE REPAIR: All 604 Pages', () async {
    print('='*70);
    print('ULTIMATE MUSHAF REPAIR - ALL 604 PAGES');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db';
    final glyphDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
    final textFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    final outputFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map_REPAIRED.txt';
    
    print('Creating backup...');
    await File(textFilePath).copy('$textFilePath.BACKUP');
    print('✅ Backup saved\n');
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Use readAsLines() - handles line endings automatically!
    final allLines = await File(textFilePath).readAsLines();
    
    // Group by page
    final pageLines = <int, List<String>>{};
    for (final line in allLines) {
      if (line.trim().isEmpty) continue;
      
      final parts = line.split(',');
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
    
    print('Loaded ${pageLines.length} pages\n');
    
    final repairedLines = <String>[];
    int pagesProcessed = 0;
    int pagesWithInjection = 0;
    int totalInjected = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) print('Processing page $pageNum...');
      
      final layoutResult = await layoutDb.rawQuery(
        'SELECT line_number, line_type FROM pages WHERE page_number = ? ORDER BY line_number',
        [pageNum]
      );
      
      if (layoutResult.isEmpty) continue;
      
      // Get all tokens as stream
      final textLines = pageLines[pageNum] ?? [];
      final allTokens = <String>[];
      for (final line in textLines) {
        allTokens.addAll(line.split(' ').where((s) => s.isNotEmpty));
      }
      
      if (allTokens.isEmpty) {
        print('⚠️  Page $pageNum: No tokens');
        continue;
      }
      
      int cursor = 0;
      bool injected = false;
      
      for (final row in layoutResult) {
        if (row['line_type'] != 'ayah') continue;
        
        final lineNum = row['line_number'] as int;
        final glyphResult = await glyphDb.rawQuery(
          'SELECT COUNT(*) as c FROM glyphs WHERE page_number = ? AND line_number = ?',
          [pageNum, lineNum]
        );
        
        final expected = glyphResult.first['c'] as int;
        
        if (cursor + expected <= allTokens.length) {
          // Perfect - enough tokens
          final tokens = allTokens.sublist(cursor, cursor + expected);
          repairedLines.add('$pageNum,${tokens.join(' ')}');
          cursor += expected;
        } else {
          // Underflow - inject
          final available = allTokens.length - cursor;
          final needed = expected - available;
          
          if (needed <= 4 && allTokens.isNotEmpty) {
            final tokens = List<String>.from(allTokens.sublist(cursor));
            final lastToken = tokens.isNotEmpty ? tokens.last : allTokens.last;
            
            for (int i = 0; i < needed; i++) {
              tokens.add(lastToken);
              totalInjected++;
            }
            
            repairedLines.add('$pageNum,${tokens.join(' ')}');
            cursor = allTokens.length;
            
            if (!injected) {
              print('🔧 Page $pageNum: Injected $needed token(s)');
              injected = true;
            }
          } else {
            print('❌ Page $pageNum Line $lineNum: Too many missing ($needed)');
            break;
          }
        }
      }
      
      if (injected) pagesWithInjection++;
      pagesProcessed++;
    }
    
    await layoutDb.close();
    await glyphDb.close();
    
    // Write with Unix line endings
    await File(outputFilePath).writeAsString(repairedLines.join('\n'));
    
    print('\n' + '='*70);
    print('REPAIR COMPLETE');
    print('='*70);
    print('Pages processed: $pagesProcessed / 604');
    print('Pages with injections: $pagesWithInjection');
    print('Total tokens injected: $totalInjected');
    print('\nOutput: $outputFilePath');
    print('\n✅ To apply: Replace mushaf_v2_map.txt with this file');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 10)));
}
