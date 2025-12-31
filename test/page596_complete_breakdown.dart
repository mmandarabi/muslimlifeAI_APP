import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Complete Page 596 breakdown - line by line, verse by verse, word by word', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('='*80);
    print('PAGE 596 - COMPLETE BREAKDOWN');
    print('='*80);
    
    // Surah names
    final surahNames = {
      92: 'Al-Layl (The Night)',
      93: 'Ad-Duha (The Morning Hours)',
      94: 'Ash-Sharh (The Relief)',
    };
    
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, surah_number, first_word_id, last_word_id
      FROM pages 
      WHERE page_number = 596
      ORDER BY line_number
    ''');
    
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final surahNum = row['surah_number'];
      final firstId = row['first_word_id'];
      final lastId = row['last_word_id'];
      
      print('\n${'='*80}');
      print('LINE $lineNum: $lineType ${surahNum != null ? "- ${surahNames[surahNum]}" : ""}');
      print('='*80);
      
      if (lineType == 'surah_name') {
        print('📖 Surah Header: ${surahNames[surahNum]}');
        print('   (This line is REMOVED in cleaned output - rendered via font separately)');
        
      } else if (lineType == 'basmallah') {
        print('📿 Bismillah: ﷽');
        print('   (This line is REMOVED in cleaned output - rendered as Unicode separately)');
        
      } else if (lineType == 'ayah' && firstId != null && lastId != null) {
        // Get all words for this line
        final words = await wordDb.rawQuery('''
          SELECT id, location, surah, ayah, word, text
          FROM words 
          WHERE id >= ? AND id <= ?
          ORDER BY id
        ''', [firstId, lastId]);
        
        if (words.isEmpty) continue;
        
        print('📝 Ayah Line (Word IDs $firstId-$lastId)');
        print('   Total words on this line: ${words.length}');
        
        // Group by verse
        final verseGroups = <String, List<Map<String, dynamic>>>{};
        for (var w in words) {
          final key = '${w['surah']}:${w['ayah']}';
          verseGroups.putIfAbsent(key, () => []).add(w);
        }
        
        print('   Contains ${verseGroups.length} verse(s):');
        print('');
        
        for (var verseKey in verseGroups.keys) {
          final versWords = verseGroups[verseKey]!;
          final surah = versWords.first['surah'];
          final ayah = versWords.first['ayah'];
          final wordRange = '${versWords.first['word']}-${versWords.last['word']}';
          final totalWordsInVerse = versWords.length;
          
          print('   ┌─ Verse $verseKey');
          print('   │  Words $wordRange on this line ($totalWordsInVerse words)');
          print('   │');
          
          // Get total words in this verse to see if it's complete or partial
          final fullVerse = await wordDb.rawQuery('''
            SELECT COUNT(*) as count FROM words 
            WHERE surah = ? AND ayah = ?
          ''', [surah, ayah]);
          
          final totalInVerse = fullVerse.first['count'] as int;
          final isComplete = totalWordsInVerse == totalInVerse;
          final isStart = versWords.first['word'] == 1;
          final isEnd = versWords.last['word'] == totalInVerse;
          
          String status = '';
          if (isComplete) status = '(COMPLETE VERSE)';
          else if (isStart && !isEnd) status = '(STARTS HERE, continues on next line)';
          else if (!isStart && isEnd) status = '(continued from previous line, ENDS HERE)';
          else status = '(MIDDLE PORTION - continues)';
          
          print('   │  $status');
          print('   │');
          print('   │  Text:');
          
          final text = versWords.map((w) => w['text']).join(' ');
          print('   │  $text');
          print('   └─');
          print('');
        }
        
        // Show the combined line output
        final fullLineText = words.map((w) => w['text']).join(' ');
        print('   📤 CLEANED OUTPUT for this line:');
        print('   596,$fullLineText');
      }
    }
    
    // Summary
    print('\n${'='*80}');
    print('PAGE 596 SUMMARY');
    print('='*80);
    
    final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
    final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
    final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
    
    print('Total lines: ${layoutResult.length}');
    print('  - Headers (surah_name): $headerCount');
    print('  - Bismillah: $bismillahCount');
    print('  - Ayah lines: $ayahCount');
    print('');
    print('Surahs on this page: ${surahNames.keys.join(", ")}');
    for (var entry in surahNames.entries) {
      print('  Surah ${entry.key}: ${entry.value}');
    }
    print('');
    print('After cleaning:');
    print('  Lines to remove: ${headerCount + bismillahCount} (headers + bismillah)');
    print('  Lines to keep: $ayahCount (ayah lines only)');
    
    await layoutDb.close();
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
