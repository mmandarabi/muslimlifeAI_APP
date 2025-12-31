import 'dart:io';
import '../lib/services/mushaf_text_service.dart';
import '../lib/services/mushaf_coordinate_service.dart';

void main() async {
  print('🔍 Diagnosing Mushaf Rendering Issue - Page 604\n');
  
  final textService = MushafTextService();
  final coordService = MushafCoordinateService();
  
  await textService.initialize();
  await coordService.initialize();
  
  int pageNum = 604;
  
  // Get text lines
  final lines = await textService.getPageLines(pageNum);
  print('📄 Text Lines for P$pageNum: ${lines.length} lines');
  for (int i = 0; i < lines.length; i++) {
    final tokens = lines[i].split(' ').where((t) => t.trim().isNotEmpty).toList();
    print('   Line ${i+1}: ${tokens.length} tokens - "${lines[i].substring(0, lines[i].length > 50 ? 50 : lines[i].length)}..."');
  }
  
  // Get coordinates
  final coords = await coordService.getPageGlyphs(pageNum);
  print('\n📐 Coordinate Glyphs: ${coords.length} glyphs');
  
  // Group by line number
  Map<int, int> glyphsByLine = {};
  for (var glyph in coords) {
    glyphsByLine[glyph.lineNumber] = (glyphsByLine[glyph.lineNumber] ?? 0) + 1;
  }
  
  print('\n📊 Glyphs Distribution by Line Number:');
  for (int lineNum in glyphsByLine.keys.toList()..sort()) {
    print('   DB Line $lineNum: ${glyphsByLine[lineNum]} glyphs');
  }
  
  // Simulate painter tokenization
  print('\n🎨 Simulating Painter Tokenization:');
  List<String> allTokens = [];
  Map<int, int> tokenToLine = {};
  
  int currentLineNumber = 1;
  for (String line in lines) {
    List<String> lineTokens = line.split(' ').where((t) => t.trim().isNotEmpty).toList();
    for (var token in lineTokens) {
      tokenToLine[allTokens.length] = currentLineNumber;
      allTokens.add(token);
    }
    currentLineNumber++;
  }
  
  print('   Total tokens: ${allTokens.length}');
  print('   Token line map size: ${tokenToLine.length}');
  
  // Group tokens by line
  Map<int, List<int>> tokensByLine = {};
  for (int i = 0; i < allTokens.length; i++) {
    int line = tokenToLine[i] ?? 0;
    if (line > 0) {
      tokensByLine.putIfAbsent(line, () => []).add(i);
    }
  }
  
  print('\n📊 Tokens Distribution by Line Number:');
  for (int lineNum in tokensByLine.keys.toList()..sort()) {
    print('   Text Line $lineNum: ${tokensByLine[lineNum]!.length} tokens');
  }
  
  // Check matching
  print('\n🔄 Line Matching Analysis:');
  for (int dbLine in glyphsByLine.keys.toList()..sort()) {
    final glyphCount = glyphsByLine[dbLine]!;
    final tokenCount = tokensByLine[dbLine]?.length ?? 0;
    final status = tokenCount > 0 ? '✅' : '❌';
    print('   $status DB Line $dbLine: $glyphCount glyphs ↔ $tokenCount tokens');
  }
  
  print('\n🎯 Lines that will be rendered (have both glyphs AND tokens):');
  int renderedLines = 0;
  for (int dbLine in glyphsByLine.keys) {
    if (tokensByLine.containsKey(dbLine) && tokensByLine[dbLine]!.isNotEmpty) {
      renderedLines++;
      print('   ✅ Line $dbLine');
    }
  }
  
  print('\n⚠️ DIAGNOSIS: Only $renderedLines lines will be rendered!');
  if (renderedLines < 10) {
    print('   This explains why the screen shows sparse text.');
    print('   Root cause: Mismatch between text line numbers and DB line numbers.');
  }
}
