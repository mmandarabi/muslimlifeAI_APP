import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Debug File Parsing', () async {
    final textFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    final rawText = await File(textFilePath).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    
    print('Total lines in file: ${allLines.length}');
    print('First 10 lines:');
    for (int i = 0; i < 10 && i < allLines.length; i++) {
      final line = allLines[i];
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        final parts = trimmed.split(',');
        print('Line $i: Page=${parts.length >= 1 ? parts[0] : "?"}, HasContent=${parts.length >= 2}');
      }
    }
    
    // Count unique page numbers
    final pages = <int>{};
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      final parts = trimmed.split(',');
      if (parts.length >= 2) {
        final pageNum = int.tryParse(parts[0]);
        if (pageNum != null) {
          pages.add(pageNum);
        }
      }
    }
    
    print('\\nUnique pages found: ${pages.length}');
    print('Page range: ${pages.isEmpty ? "none" : "${pages.reduce((a, b) => a < b ? a : b)} to ${pages.reduce((a, b) => a > b ? a : b)}"}');
  });
}
