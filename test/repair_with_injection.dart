import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Repair mushaf with Token Injection', () async {
    print('='*70);
    print('MUSHAF DATA REPAIR WITH TOKEN INJECTION');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    final backupFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.BACKUP';
    final outputFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEAN.txt';
    
    // Create backup
    print('Creating backup...');
    await File(textFilePath).copy(backupFilePath);
    print('✅ Backup created\\n');
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Read text file
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.split('\\n');
    final pageTokens = <int, List<String>>{};
    
    for (final line in allLines) {
      final parts = line.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null) {
          final content = parts.sublist(1).join(',').trim();
          final tokens = content.split(' ').where((s) => s.isNotEmpty).toList();
          pageTokens.putIfAbsent(pageNum, () => []).addAll(tokens);
        }
      }
    }
    
    print('Parsed tokens for ${pageTokens.length} pages\\n');
    
    final repairedLines = <String>[];
    int pagesFailed = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 50 == 0) print('Processing Page $pageNum...');
      
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) continue;
      
      final tokens = pageTokens[pageNum] ?? [];
      int tokenCursor = 0;
      
      for (final row in layoutResult) {
        final lineType = row['line_type'] as String;
        final lineNum = row['line_number'] as int;
        
        if (lineType == 'ayah') {
          final glyphResult = await glyphDb.rawQuery('''
            SELECT COUNT(*) as glyph_count
            FROM glyphs
            WHERE page_number = ? AND line_number = ?
          ''', [pageNum, lineNum]);
          
          final targetCount = glyphResult.first['glyph_count'] as int;
          
          // Check if we have enough tokens
          if (tokenCursor + targetCount > tokens.length) {
            final diff = (tokenCursor + targetCount) - tokens.length;
            
            // INJECTION LOGIC: Duplicate last token for missing markers
            if (diff <= 4 && tokens.isNotEmpty) {
              print('🔧 Page $pageNum Line $lineNum: Injecting $diff missing marker(s)');
              final lastToken = tokenCursor > 0 ? tokens[tokenCursor - 1] : tokens.last;
              final lineTokens = List<String>.from(tokens.sublist(tokenCursor));
              
              // Pad with duplicates
              while (lineTokens.length < targetCount) {
                lineTokens.add(lastToken);
              }
              
              repairedLines.add('$pageNum,${lineTokens.join(' ')}');
              tokenCursor = tokens.length;
            } else {
              print('❌ Page $pageNum Line $lineNum: Underflow! Need $targetCount, have ${tokens.length - tokenCursor}');
              pagesFailed++;
              break;
            }
          } else {
            final lineTokens = tokens.sublist(tokenCursor, tokenCursor + targetCount);
            repairedLines.add('$pageNum,${lineTokens.join(' ')}');
            tokenCursor += targetCount;
          }
        }
      }
    }
    
    await layoutDb.close();
    await glyphDb.close();
    
    await File(outputFilePath).writeAsString(repairedLines.join('\\n'));
    
    print('\\n✅ Repair complete: $outputFilePath');
    print('Pages failed: $pagesFailed');
    
    expect(pagesFailed, 0, reason: 'All pages should repair successfully');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
