import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  test('Verify Pages 1, 2, and 604 structure from database', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db';
    MushafLayoutService.overrideDbPath = layoutDbPath;
    await MushafLayoutService.initialize();
    
    // Check Page 1
    final page1 = await MushafLayoutService.getPageLayout(1);
    print('PAGE 1 (Al-Fatiha):');
    print('  Total lines: ${page1.length}');
    for (var line in page1) {
      print('  Line ${line.lineNumber}: ${line.lineType} ${line.surahNumber != null ? "(Surah ${line.surahNumber})" : ""}');
    }
    
    final p1Headers = page1.where((l) => l.lineType == 'surah_name').length;
    final p1Bismillah = page1.where((l) => l.lineType == 'basmallah').length;
    final p1Ayah = page1.where((l) => l.lineType == 'ayah').length;
    print('  Summary: $p1Headers headers, $p1Bismillah bismillah, $p1Ayah ayahs\n');
    
    // Check Page 2
    final page2 = await MushafLayoutService.getPageLayout(2);
    print('PAGE 2 (Al-Baqara):');
    print('  Total lines: ${page2.length}');
    for (var line in page2) {
      print('  Line ${line.lineNumber}: ${line.lineType} ${line.surahNumber != null ? "(Surah ${line.surahNumber})" : ""}');
    }
    
    final p2Headers = page2.where((l) => l.lineType == 'surah_name').length;
    final p2Bismillah = page2.where((l) => l.lineType == 'basmallah').length;
    final p2Ayah = page2.where((l) => l.lineType == 'ayah').length;
    print('  Summary: $p2Headers headers, $p2Bismillah bismillah, $p2Ayah ayahs\n');
    
    // Check Page 604
    final page604 = await MushafLayoutService.getPageLayout(604);
    print('PAGE 604:');
    print('  Total lines: ${page604.length}');
    final p604Headers = page604.where((l) => l.lineType == 'surah_name').length;
    final p604Bismillah = page604.where((l) => l.lineType == 'basmallah').length;
    final p604Ayah = page604.where((l) => l.lineType == 'ayah').length;
    print('  Summary: $p604Headers headers, $p604Bismillah bismillah, $p604Ayah ayahs\n');
  });
}
