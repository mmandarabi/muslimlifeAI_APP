import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Reconstructs a clean mushaf text file from QPC V2 databases
/// 
/// This script:
/// 1. Reads layout structure from qpc-v2-15-lines.db
/// 2. Extracts word text from qpc-v2.db
/// 3. Outputs ayah-only text file (headers and bismillah removed)
///
/// Output format: page_number,word1 word2 word3...
void main() async {
  print('='*80);
  print('MUSHAF TEXT RECONSTRUCTION SCRIPT');
  print('Using QPC V2 Databases');
  print('='*80);
  
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
  final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
  final outputPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED_RECONSTRUCTED.txt';
  
  print('\nInput databases:');
  print('  Layout: $layoutDbPath');
  print('  Words: $wordDbPath');
  print('\nOutput file:');
  print('  $outputPath');
  print('');
  
  // Open databases
  print('Opening databases...');
  final layoutDb = await databaseFactory.openDatabase(
    layoutDbPath, 
    options: OpenDatabaseOptions(readOnly: true)
  );
  final wordDb = await databaseFactory.openDatabase(
    wordDbPath, 
    options: OpenDatabaseOptions(readOnly: true)
  );
  
  // Prepare output file
  final outputFile = File(outputPath);
  if (await outputFile.exists()) {
    await outputFile.delete();
  }
  final sink = outputFile.openWrite();
  
  // Statistics
  int totalPages = 0;
  int totalLines = 0;
  int headersRemoved = 0;
  int bismillahRemoved = 0;
  int ayahLinesKept = 0;
  
  print('Processing 604 pages...\n');
  
  // Process each page
  for (int pageNum = 1; pageNum <= 604; pageNum++) {
    if (pageNum % 50 == 0) {
      print('  Processed $pageNum pages...');
    }
    
    // Get layout for this page
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, first_word_id, last_word_id
      FROM pages
      WHERE page_number = ?
      ORDER BY line_number
    ''', [pageNum]);
    
    if (layoutResult.isEmpty) {
      print('  ⚠️  WARNING: Page $pageNum has no layout data');
      continue;
    }
    
    totalPages++;
    
    // Process each line
    for (var row in layoutResult) {
      final lineType = row['line_type'] as String;
      final firstWordId = row['first_word_id'];
      final lastWordId = row['last_word_id'];
      
      totalLines++;
      
      if (lineType == 'surah_name') {
        headersRemoved++;
        continue; // Skip header lines
      }
      
      if (lineType == 'basmallah') {
        bismillahRemoved++;
        continue; // Skip bismillah lines
      }
      
      if (lineType == 'ayah') {
        if (firstWordId == null || lastWordId == null) {
          print('  ⚠️  WARNING: Page $pageNum has ayah line with null word IDs');
          continue;
        }
        
        // Get words for this ayah line
        final words = await wordDb.rawQuery('''
          SELECT text
          FROM words
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstWordId, lastWordId]);
        
        if (words.isEmpty) {
          print('  ⚠️  WARNING: Page $pageNum line has no words (IDs $firstWordId-$lastWordId)');
          continue;
        }
        
        // Combine words with spaces
        final lineText = words.map((w) => w['text']).join(' ');
        
        // Write to output file
        sink.writeln('$pageNum,$lineText');
        ayahLinesKept++;
      }
    }
  }
  
  // Close file
  await sink.close();
  
  // Close databases
  await layoutDb.close();
  await wordDb.close();
  
  // Get output file size
  final fileSize = await outputFile.length();
  final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);
  
  // Print summary
  print('\n' + '='*80);
  print('RECONSTRUCTION COMPLETE');
  print('='*80);
  print('\nStatistics:');
  print('  Pages processed: $totalPages / 604');
  print('  Total layout lines: $totalLines');
  print('  Headers removed: $headersRemoved');
  print('  Bismillah removed: $bismillahRemoved');
  print('  Ayah lines kept: $ayahLinesKept');
  print('');
  print('Output file:');
  print('  Path: $outputPath');
  print('  Size: $fileSizeKB KB');
  print('  Lines: $ayahLinesKept');
  print('');
  
  // Verification
  print('Verification:');
  if (totalPages == 604) {
    print('  ✅ All 604 pages processed');
  } else {
    print('  ❌ Missing pages: ${604 - totalPages}');
  }
  
  if (ayahLinesKept > 0) {
    print('  ✅ Ayah lines written: $ayahLinesKept');
  } else {
    print('  ❌ No ayah lines written!');
  }
  
  final linesRemoved = headersRemoved + bismillahRemoved;
  print('  ✅ Lines removed: $linesRemoved (headers + bismillah)');
  
  print('\n' + '='*80);
  print('DONE');
  print('='*80);
}
