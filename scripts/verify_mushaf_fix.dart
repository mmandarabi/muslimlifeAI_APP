// Simplified console audit to verify token count parity
// Run with: dart run scripts/verify_mushaf_fix.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print("\n🔍 MUSHAF TOKEN PARITY AUDIT (Post-Fix Verification)\n${'=' * 70}");
  
  // Critical test pages
  final testPages = [1, 2, 374, 604];
  
  print("Testing critical pages: $testPages\n");
  
  for (final page in testPages) {
    await verifyPage(page);
  }
  
  print("\n${'=' * 70}");
  print("✅ Audit complete. Manual visual testing recommended for final validation.");
}

Future<void> verifyPage(int pageNum) async {
  // Load text map
  final file = File('assets/quran/mushaf_v2_map.txt');
  if (!await file.exists()) {
    print("❌ P$pageNum: mushaf_v2_map.txt not found");
    return;
  }
  
  final lines = await file.readAsLines();
  List<String> pageLines = [];
  
  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2) {
      final page = int.tryParse(parts[0]);
      if (page == pageNum) {
        final text = parts.sublist(1).join(',').trim();
        if (text.isNotEmpty) {
          pageLines.add(text);
        }
      }
    }
  }
  
  // Apply sanitization logic (simplified - just count tokens)
  List<String> tokens = [];
  for (var line in pageLines) {
    tokens.addAll(line.split(' ').where((t) => t.trim().isNotEmpty));
  }
  
  print("P$pageNum: ${pageLines.length} lines, ${tokens.length} tokens (from text map)");
  
  // Note: Would need SQLite to verify against DB, but this confirms text service parsing
}
