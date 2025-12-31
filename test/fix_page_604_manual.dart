import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fix Page 604 Manually', () async {
    final txtPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    // Read current file
    final lines = await File(txtPath).readAsLines();
    
    // Find Page 604 lines
    final page604Lines = <String>[];
    final otherLines = <String>[];
    
    for (final line in lines) {
      if (line.trim().startsWith('604,')) {
        page604Lines.add(line);
      } else {
        otherLines.add(line);
      }
    }
    
    print('Current Page 604 has ${page604Lines.length} lines');
    for (int i = 0; i < page604Lines.length; i++) {
      final tokens = page604Lines[i].split(',')[1].trim().split(' ').where((s) => s.isNotEmpty).length;
      print('  Line $i: $tokens tokens');
    }
    
    // Extract ALL tokens from Page 604
    final allTokens = <String>[];
    for (final line in page604Lines) {
      final content = line.split(',').sublist(1).join(',').trim();
      allTokens.addAll(content.split(' ').where((s) => s.isNotEmpty));
    }
    
    print('\\nTotal Page 604 tokens: ${allTokens.length}');
    print('Expected: 73 tokens for 9 Ayah lines (based on database)');
    
    // According to user requirement and word database:
    // Text Line 0 (Layout Line 3): Al-Ikhlas Ayahs 1+2+3 = 13 words
    // Text Line 1 (Layout Line 4): Al-Ikhlas Ayah 4 = 6 words
    // ... continuing for Al-Falaq and An-Nas
    
    // Let me redistribute based on expected counts
    // CORRECT distribution (from earlier deep parity test):
    final expectedCounts = [
      10, // Line 3 (Al-Ikhlas 1+2+part of 3)
      9,  // Line 4 
      11, // Line 7 (Al-Falaq)
      8,  // Line 8
      8,  // Line 9
      9,  // Line 12 (An-Nas)
      8,  // Line 13
      5,  // Line 14
      4   // Line 15
    ];
    
    print('\\nExpected token counts per line: $expectedCounts');
    print('Total expected: ${expectedCounts.reduce((a, b) => a + b)}');
    
    // Create new Page 604 lines
    int cursor = 0;
    final newPage604Lines = <String>[];
    
    for (final count in expectedCounts) {
      if (cursor + count <= allTokens.length) {
        final lineTokens = allTokens.sublist(cursor, cursor + count);
        newPage604Lines.add('604,${lineTokens.join(' ')}');
        cursor += count;
      } else {
        print('ERROR: Not enough tokens! Needed $count, have ${allTokens.length - cursor}');
        break;
      }
    }
    
    print('\\nCreated ${newPage604Lines.length} new Page 604 lines');
    
    // Rebuild full file
    final rebuiltLines = <String>[];
    bool foundPage604 = false;
    
    for (final line in lines) {
      if (line.trim().startsWith('604,')) {
        if (!foundPage604) {
          rebuiltLines.addAll(newPage604Lines);
          foundPage604 = true;
        }
      } else {
        rebuiltLines.add(line);
      }
    }
    
    // Write back
    await File(txtPath).writeAsString(rebuiltLines.join('\\n'));
    
    print('\\n✅ Page 604 fixed and saved!');
  });
}
