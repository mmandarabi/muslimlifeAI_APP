import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db';
  MushafLayoutService.overrideDbPath = dbPath;
  
  await MushafLayoutService.initialize();
  final textService = MushafTextService();
  
  print('Juz 30 Cursor Sync Diagnostic Report');
  print('=' * 60);
  
  final failures = <int>[];
  
  for (int pageNum = 582; pageNum <= 604; pageNum++) {
    final layout = await MushafLayoutService.getPageLayout(pageNum);
    final textLines = await textService.getPageLines(pageNum);
    final ayahCount = layout.where((l) => l.lineType == 'ayah').length;
    
    if (textLines.length != ayahCount) {
      print('❌ Page $pageNum: Text=${textLines.length} vs Ayah=$ayahCount MISMATCH');
      failures.add(pageNum);
    } else {
      print('✅ Page $pageNum: Text=${textLines.length} ayahs MATCH');
    }
  }
  
  if (failures.isEmpty) {
    print('\n✅ All Juz 30 pages pass cursor sync!');
  } else {
    print('\n❌ ${failures.length} pages FAILED:');
    print(failures.join(', '));
  }
}
