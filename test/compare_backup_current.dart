import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Compare BACKUP vs CURRENT Page 604', () async {
    final backupPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.BACKUP';
    final currentPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    // Get BACKUP version
    final backupText = await File(backupPath).readAsString();
    final backupLines = backupText.split('\n').where((l) => l.trim().startsWith('604,')).toList();
    
    // Get CURRENT version
    final currentText = await File(currentPath).readAsString();
    final currentLines = currentText.split('\n').where((l) => l.trim().startsWith('604,')).toList();
    
    print('BACKUP Page 604: ${backupLines.length} lines');
    for (int i = 0; i < backupLines.length; i++) {
       final tokens = backupLines[i].split(',').sublist(1).join(',').trim().split(' ').where((s) => s.isNotEmpty).length;
       print('  Line $i: $tokens tokens');
    }
    
    print('\nCURRENT Page 604: ${currentLines.length} lines');
    for (int i = 0; i < currentLines.length; i++) {
       final tokens = currentLines[i].split(',').sublist(1).join(',').trim().split(' ').where((s) => s.isNotEmpty).length;
       print('  Line $i: $tokens tokens');
    }
  });
}
