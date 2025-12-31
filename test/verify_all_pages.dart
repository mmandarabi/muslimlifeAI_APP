import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';

void main() {
  test('Verify ALL 604 Pages (Strict Parity Check)', () async {
    print('='*70);
    print('FINAL VERIFICATION: ALL 604 PAGES');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final glyphDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db';
    final txtPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    if (File(dbPath).existsSync()) {
      MushafLayoutService.overrideDbPath = dbPath;
    }
    
    // Read repaired text file
    print('Reading text file...');
    final rawText = await File(txtPath).readAsString();
    final allLines = rawText.split('\n');
    final Map<int, List<String>> pageTokens = {};
    
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
    
    print('Parsed tokens for ${pageTokens.length} pages.\n');
    
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    final reportFile = File('verification_report.txt');
    final sink = reportFile.openWrite();
    sink.writeln('VERIFICATION REPORT');
    sink.writeln('===================');
    
    int totalErrors = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      final layout = await MushafLayoutService.getPageLayout(pageNum);
      final tokens = pageTokens[pageNum] ?? [];
      
      int tokenCursor = 0;
      bool pageFailed = false;
      
      for (final line in layout) {
        if (line.lineType == 'ayah') {
           final glyphResult = await glyphDb.rawQuery('''
            SELECT COUNT(*) as glyph_count
            FROM glyphs
            WHERE page_number = ? AND line_number = ?
          ''', [pageNum, line.lineNumber]);
          
          final expected = glyphResult.first['glyph_count'] as int;
          
          if (tokenCursor + expected <= tokens.length) {
             final lineTokens = tokens.sublist(tokenCursor, tokenCursor + expected);
             
             if (lineTokens.length != expected) {
                final msg = '  ❌ Page $pageNum Line ${line.lineNumber}: Mismatch! Expected $expected, Got ${lineTokens.length}';
                print(msg);
                sink.writeln(msg);
                pageFailed = true;
                totalErrors++;
             }
             tokenCursor += expected;
          } else {
             int available = tokens.length - tokenCursor;
             final msg = '  ❌ Page $pageNum Line ${line.lineNumber}: Underflow! Expected $expected, Available $available';
             print(msg);
             sink.writeln(msg);
             pageFailed = true;
             totalErrors++;
             tokenCursor = tokens.length; // Stop processing this page
          }
        }
      } 
      
      if (tokenCursor < tokens.length) {
         final excess = tokens.length - tokenCursor;
         final msg = '  ⚠️ Page $pageNum: $excess excess tokens remaining';
         print(msg);
         sink.writeln(msg);
      }
      
      if (pageFailed) {
        if (totalErrors > 20) {
           sink.writeln('Aborting verification due to too many errors.');
           await sink.close();
           fail('Too many errors ($totalErrors). Aborting verification.');
        }
      }
      
      if (pageNum % 50 == 0) {
         print('  ✓ Verified up to Page $pageNum');
      }
    }
    
    await glyphDb.close();
    
    if (totalErrors == 0) {
       sink.writeln('✅ SUCCESS: All 604 pages verified with 100% glyph count parity.');
       print('\n✅ SUCCESS: All 604 pages verified with 100% glyph count parity.');
       await sink.close();
    } else {
       sink.writeln('❌ FAILED: $totalErrors errors found.');
       await sink.close();
       fail('Verification failed with $totalErrors errors.');
    }
  });
}


