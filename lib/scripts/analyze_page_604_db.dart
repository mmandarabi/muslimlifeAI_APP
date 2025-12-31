import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🔍 PAGE 604 DATABASE STRUCTURE ANALYSIS");
  print("=" * 70);

  final dataService = MushafDataService();
  
  // Get ALL glyphs for Page 604
  final glyphs = await dataService.getPageGlyphs(604);

  print("Total glyphs: ${glyphs.length}\n");

  // Analyze structure
  Map<String, dynamic> firstGlyph = glyphs.isNotEmpty ? glyphs.first : {};
  print("Database columns:");
  firstGlyph.keys.forEach((key) {
    print("  - $key: ${firstGlyph[key].runtimeType}");
  });

  print("\n" + "=" * 70);
  print("FIRST 20 GLYPHS (to identify headers vs verses):");
  print("=" * 70);
  print("IDX | SURA | AYAH | LINE | POS | WIDTH  | TYPE");
  print("-" * 70);

  for (int i = 0; i < 20 && i < glyphs.length; i++) {
    final g = glyphs[i];
    int sura = g['sura_id'] as int? ?? -1;
    int ayah = g['ayah_id'] as int? ?? -1;
    int line = g['line_number'] as int? ?? -1;
    int pos = g['position'] as int? ?? -1;
    double width = (g['width_glyph'] as num?)?.toDouble() ?? 0.0;
    
    String type = ayah == 0 ? "HEADER" : "VERSE";
    
    print("${i.toString().padLeft(3)} | ${sura.toString().padLeft(4)} | ${ayah.toString().padLeft(4)} | ${line.toString().padLeft(4)} | ${pos.toString().padLeft(3)} | ${width.toStringAsFixed(1).padLeft(6)} | $type");
  }

  print("\n" + "=" * 70);
  print("AYAH DISTRIBUTION:");
  print("=" * 70);
  
  Map<int, int> ayahCounts = {};
  for (var g in glyphs) {
    int ayah = g['ayah_id'] as int? ?? -1;
    ayahCounts[ayah] = (ayahCounts[ayah] ?? 0) + 1;
  }

  ayahCounts.forEach((ayah, count) {
    print("Ayah $ayah: $count glyphs");
  });

  print("\n" + "=" * 70);
}
