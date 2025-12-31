import 'package:flutter/material.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("\n🔍 PAGE 604 RAW TEXT LINES");
  print("=" * 70);

  final textService = MushafTextService();
  final lines = await textService.getPageLines(604);

  print("Total lines: ${lines.length}");
  print("");

  for (int i = 0; i < lines.length && i < 15; i++) {
    final lineNum = i + 1;
    final text = lines[i];
    print("Line $lineNum: $text");
  }

  print("=" * 70);
}
