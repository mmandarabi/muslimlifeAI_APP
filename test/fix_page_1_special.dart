import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Fix Page 1 Special (One Ayah Per Line)', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final hfsDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\Hfsdb\qpc-hafs-word-by-word.db';
    final textFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    
    final hfsDb = await databaseFactory.openDatabase(hfsDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    print('Building Page 1 (Al-Fatiha) - One Ayah Per Line...\n');
    
    // Get all 7 ayahs of Al-Fatiha
    final page1Lines = <String>[];
    for (int ayah = 1; ayah <= 7; ayah++) {
      final wordsResult = await hfsDb.rawQuery('''
        SELECT text FROM words
        WHERE surah = 1 AND ayah = ?
        ORDER BY word
      ''', [ayah]);
      
      final words = wordsResult.map((r) => r['text'] as String).toList();
      page1Lines.add('1,${words.join(' ')}');
      print('Ayah $ayah: ${words.length} words');
    }
    
    await hfsDb.close();
    
    // Read current file and replace Page 1
    final allLines = await File(textFilePath).readAsLines();
    final newLines = <String>[];
    bool skipPage1 = false;
    
    for (final line in allLines) {
      if (line.trim().startsWith('1,')) {
        if (!skipPage1) {
          // Add our fixed Page 1
          newLines.addAll(page1Lines);
          skipPage1 = true;
        }
        // Skip all original Page 1 lines
      } else {
        if (skipPage1 && !line.trim().startsWith('1,')) {
          skipPage1 = false;
        }
        if (!skipPage1) {
          newLines.add(line);
        }
      }
    }
    
    await File(textFilePath).writeAsString(newLines.join('\n'));
    
    print('\n✅ Page 1 fixed with 7 lines (one ayah per line)');
  });
}
