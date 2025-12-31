import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('d:/solutions/MuslimLifeAI_demo/assets/quran/mushaf_v2_map.txt');
  final lines = await file.readAsLines();
  
  print("🔎 Inspecting Page 2 Tokens:");
  
  for (var line in lines) {
    if (line.startsWith('2,')) {
      final content = line.substring(2); // Remove "2,"
      final tokens = content.split(' ');
      
      for (var i = 0; i < tokens.length; i++) {
        final token = tokens[i];
        if (token.trim().isEmpty) continue;
        
        final codepoints = token.runes.map((r) => 'U+${r.toRadixString(16).toUpperCase()}').join(' ');
        print('Token "$token": $codepoints');
        
        // Stop after first 15 tokens to keep it readable
        // We want to see: AlifLamMim, Marker, Dhalika, AlKitab...
      }
    }
  }
}
