import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/services/mushaf_layout_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Page 603 - Check if it has headers', () async {
    MushafLayoutService.overrideDbPath = 'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db';
    await MushafLayoutService.initialize();
    
    final layout = await MushafLayoutService.getPageLayout(603);
    final headers = await MushafLayoutService.getSurahHeaders(603);
    
    print('\n=== PAGE 603 STRUCTURE ===');
    print('Total lines: ${layout.length}');
    print('Headers: ${headers.length}');
    print('');
    
    for (var line in layout) {
      print('Line ${line.lineNumber}: ${line.lineType}${line.surahNumber != null ? " (Surah ${line.surahNumber})" : ""}');
    }
    
    print('\nHeader lines specifically:');
    for (var header in headers) {
      print('  Line ${header.lineNumber}: Surah ${header.surahNumber}');
    }
    
    print('=========================\n');
  });

  test('Page 604 - Check structure', () async {
    MushafLayoutService.overrideDbPath = 'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db';
    await MushafLayoutService.initialize();
    
    final layout = await MushafLayoutService.getPageLayout(604);
    final headers = await MushafLayoutService.getSurahHeaders(604);
    
    print('\n=== PAGE 604 STRUCTURE ===');
    print('Total lines: ${layout.length}');
    print('Headers: ${headers.length}');
    print('');
    
    for (var line in layout) {
      print('Line ${line.lineNumber}: ${line.lineType}${line.surahNumber != null ? " (Surah ${line.surahNumber})" : ""}');
    }
    
    print('=========================\n');
  });
}
