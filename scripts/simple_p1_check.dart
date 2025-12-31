// Simplified Page 1 Text Analysis
// Analyzes what text lines are loaded for Page 1
// Run: dart run scripts/simple_p1_check.dart

import 'dart:io';

void main() async {
  print("\n🔍 PAGE 1 TEXT MAP ANALYSIS\n${'='* 70}");
  
  final file = File('assets/quran/mushaf_v2_map.txt');
  final lines = await file.readAsLines();
  
  List<String> pageLines = [];
  
  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2) {
      final page = int.tryParse(parts[0]);
      if (page == 1) {
        final text = parts.sublist(1).join(',').trim();
        if (text.isNotEmpty) {
          pageLines.add(text);
        }
      }
    }
  }
  
  print("Total lines loaded for Page 1: ${pageLines.length}");
  print("\nLine-by-line breakdown:");
  for (int i = 0; i < pageLines.length; i++) {
    final tokens = pageLines[i].split(' ').where((t) => t.trim().isNotEmpty).toList();
    print("\nText Line ${i+1}:");
    print("  Token count: ${tokens.length}");
    print("  First 3 tokens: ${tokens.take(3).join(' ')}");
    print("  Raw: ${pageLines[i].substring(0, pageLines[i].length > 60 ? 60 : pageLines[i].length)}...");
  }
  
  // Simulate painter mapping
  print("\n\n📍 PAINTER SIMULATION");
  print("${'=' * 70}");
  
  List<String> allTokens = [];
  Map<int, int> tokenToLine = {};
  int currentLine = 1;
  
  for (String line in pageLines) {
    List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    for (var token in lineTokens) {
      tokenToLine[allTokens.length] = currentLine;
      allTokens.add(token);
    }
    currentLine++;
  }
  
  print("Total tokens: ${allTokens.length}");
  
  Map<int, List<int>> tokensByLine = {};
  for (int i = 0; i < allTokens.length; i++) {
    int line = tokenToLine[i] ?? 0;
    if (line > 0) {
      tokensByLine.putIfAbsent(line, () => []).add(i);
    }
  }
  
  print("\nTokens grouped by line:");
  for (var line in tokensByLine.keys.toList()..sort()) {
    print("  Line $line: ${tokensByLine[line]!.length} tokens");
  }
  
  print("\n💡 KEY QUESTION:");
  print("Does the text map have 7 lines (one per ayah)?");
  print("Answer: ${pageLines.length == 7 ? 'YES ✅' : 'NO ❌ (has ${pageLines.length} lines)'}");
  
  print("\n${'=' * 70}");
}
