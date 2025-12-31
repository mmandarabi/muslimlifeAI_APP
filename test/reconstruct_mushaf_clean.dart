import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Reconstructs a clean mushaf text file from QPC V2 databases
void main() {
  test('Reconstruct clean mushaf text from QPC V2 databases', () async {
    print('='*80);
    print('MUSHAF TEXT RECONSTRUCTION');
    print('='*80);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final outputPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED_RECONSTRUCTED.txt';
    
    print('\nInput:');
    print('  Layout DB: qpc-v2-15-lines.db');
    print('  Word DB: qpc-v2.db');
    print('\nOutput: mushaf_v2_map_CLEANED_RECONSTRUCTED.txt\n');
    
    // Open databases
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Prepare output
    final outputFile = File(outputPath);
    if (await outputFile.exists()) await outputFile.delete();
    final sink = outputFile.openWrite();
    
    int totalPages = 0, ayahLinesKept = 0, headersRemoved = 0, bismillahRemoved = 0;
    
    // Process all 604 pages
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 100 == 0) print('  Processing page $pageNum...');
      
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_type, first_word_id, last_word_id
        FROM pages WHERE page_number = ? ORDER BY line_number
      ''', [pageNum]);
      
      if (layoutResult.isEmpty) continue;
      totalPages++;
      
      for (var row in layoutResult) {
        final lineType = row['line_type'] as String;
        
        if (lineType == 'surah_name') {
          headersRemoved++;
          continue;
        }
        if (lineType == 'basmallah') {
          bismillahRemoved++;
          continue;
        }
        
        if (lineType == 'ayah') {
          final firstId = row['first_word_id'];
          final lastId = row['last_word_id'];
          if (firstId == null || lastId == null) continue;
          
          final words = await wordDb.rawQuery('''
            SELECT text FROM words WHERE id >= ? AND id <= ? ORDER BY id
          ''', [firstId, lastId]);
          
          if (words.isEmpty) continue;
          
          final lineText = words.map((w) => w['text']).join(' ');
          sink.writeln('$pageNum,$lineText');
          ayahLinesKept++;
        }
      }
    }
    
    await sink.close();
    await layoutDb.close();
    await wordDb.close();
    
    final fileSize = (await outputFile.length() / 1024).toStringAsFixed(2);
    
    print('\n' + '='*80);
    print('COMPLETE');
    print('='*80);
    print('Pages: $totalPages / 604');
    print('Headers removed: $headersRemoved');
    print('Bismillah removed: $bismillahRemoved');
    print('Ayah lines kept: $ayahLinesKept');
    print('Output size: $fileSize KB');
    print('='*80);
    
  }, timeout: const Timeout(Duration(minutes: 10)));
}
