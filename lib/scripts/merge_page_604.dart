import 'dart:io';

void main() async {
  // Current 15 lines of Page 604
  final rawLines = [
    'ﱁ ﱂ ﱃ ﱄ ﱅ',           // 0: 5 glyphs
    'ﱆ ﱇ ﱈ',                 // 1: 3 glyphs
    'ﱉ ﱊ ﱋ ﱌ ﱍ',           // 2: 5 glyphs
    'ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ',       // 3: 6 glyphs
    'ﱔ ﱕ ﱖ ﱗ ﱘ',           // 4: 5 glyphs
    'ﱙ ﱚ ﱛ ﱜ ﱝ',           // 5: 5 glyphs
    'ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ',       // 6: 6 glyphs
    'ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ',       // 7: 6 glyphs
    'ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ',       // 8: 6 glyphs
    'ﱰ ﱱ ﱲ ﱳ ﱴ',           // 9: 5 glyphs
    'ﱵ ﱶ ﱷ',                 // 10: 3 glyphs
    'ﱸ ﱹ ﱺ',                 // 11: 3 glyphs
    'ﱻ ﱼ ﱽ ﱾ ﱿ',           // 12: 5 glyphs
    'ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ',       // 13: 6 glyphs
    'ﲆ ﲇ ﲈ ﲉ',               // 14: 4 glyphs
  ];
  
  // Target glyph counts from database
  final targetCounts = [10, 9, 11, 9, 8, 9, 8, 5, 4];
  
  // Merge lines to match target counts
  final mergedLines = <String>[];
  int cursor = 0;
  
  print('Starting merge process...\n');
  
  for (int lineIndex = 0; lineIndex < targetCounts.length; lineIndex++) {
    final targetCount = targetCounts[lineIndex];
    final glyphs = <String>[];
    
    while (glyphs.length < targetCount && cursor < rawLines.length) {
      final lineGlyphs = rawLines[cursor].split(' ').where((s) => s.isNotEmpty).toList();
      
      // Check if adding this entire line would exceed the target
      if (glyphs.length + lineGlyphs.length <= targetCount) {
        // Add all glyphs from this line
        glyphs.addAll(lineGlyphs);
        cursor++;
        print('  Consumed line $cursor (${lineGlyphs.length} glyphs) → total: ${glyphs.length}');
      } else {
        // We need to split this line - take only what we need
        final needed = targetCount - glyphs.length;
        glyphs.addAll(lineGlyphs.take(needed));
        print('  Partially consumed line ${cursor + 1} (took $needed of ${lineGlyphs.length} glyphs) → total: ${glyphs.length}');
        
        // Update the current line to remove consumed glyphs
        rawLines[cursor] = lineGlyphs.skip(needed).join(' ');
        break;
      }
    }
    
    if (glyphs.length != targetCount) {
      print('\n❌ ERROR: Line ${lineIndex + 1}: Expected $targetCount glyphs, got ${glyphs.length}');
      return;
    }
    
    mergedLines.add(glyphs.join(' '));
    print('✅ Line ${lineIndex + 1}: ${glyphs.length} glyphs\n');
  }
  
  print('\n' + '='*60);
  print('MERGED LINES FOR PAGE 604:');
  print('='*60);
  
  for (int i = 0; i < mergedLines.length; i++) {
    final preview = mergedLines[i].length > 40 ? mergedLines[i].substring(0, 40) + '...' : mergedLines[i];
    print('604,$preview');
  }
  
  print('\n' + '='*60);
  print('SUCCESS: Created ${mergedLines.length} merged lines');
  print('='*60);
  
  // Write to output file
  final output = mergedLines.map((line) => '604,$line').join('\n');
  await File('D:\\solutions\\MuslimLifeAI_demo\\page_604_repaired.txt').writeAsString(output);
  print('\nRepaired lines written to: page_604_repaired.txt');
}
