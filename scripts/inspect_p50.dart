import 'dart:io';

void main() async {
  // 1. Inspect Tokens
  final mapFile = File('d:/solutions/MuslimLifeAI_demo/assets/quran/mushaf_v2_map.txt');
  final lines = await mapFile.readAsLines();
  
  print("🔎 Inspecting Page 50 Tokens:");
  int lineCount = 0;
  
  for (var line in lines) {
    if (line.startsWith('50,')) {
      final content = line.substring(3); // Remove "50,"
      final tokens = content.split(' ');
      lineCount++;
      
      print('Map Line $lineCount: ${tokens.where((t)=>t.isNotEmpty).length} tokens');
      
      // Print tokens for line 4
      if (lineCount == 4) {
        print('  Line $lineCount Content:');
        int tIndex = 0;
        tokens.where((t)=>t.isNotEmpty).forEach((t) {
            final codepoints = t.runes.map((r) => r.toRadixString(16)).join(' ');
            print('    [$tIndex] "$t" (U+$codepoints)');
            tIndex++;
        });
      }
    }
  }
}
