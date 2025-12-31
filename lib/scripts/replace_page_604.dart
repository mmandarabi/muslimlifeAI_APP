import 'dart:io';

void main() async {
  // Read the original file
  final originalFile = File('D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt');
  final lines = await originalFile.readAsLines();
  
  // Read the repaired lines
  final repairedFile = File('D:\\solutions\\MuslimLifeAI_demo\\page_604_repaired.txt');
  final repairedLines = await repairedFile.readAsLines();
  
  // Replace Page 604 lines
  final newLines = <String>[];
  bool skip604 = false;
  
  for (final line in lines) {
    if (line.startsWith('604,')) {
      if (!skip604) {
        // Add all repaired lines
        newLines.addAll(repairedLines);
        skip604 = true;
      }
      // Skip original 604 lines
    } else if (line.startsWith('605,')) {
      skip604 = false;
      newLines.add(line);
    } else {
      newLines.add(line);
    }
  }
  
  // Write back
  await originalFile.writeAsString(newLines.join('\n'));
  
  print('✅ Successfully replaced Page 604 lines in mushaf_v2_map.txt');
  print('   Replaced 15 lines with ${repairedLines.length} repaired lines');
}
