
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';

void main() {
  test('Console Layout Verification', () async {
      // Setup FFI for script execution
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Point to local asset file (relative to project root)
      MushafLayoutService.overrideDbPath = 'assets/quran/databases/qpc-v1-15-lines.db';

      await _runLayoutVerification();
  });
}

void _runLayoutVerification() async {
  print('════════════════════════════════════════');
  print('LAYOUT DATABASE VERIFICATION');
  print('════════════════════════════════════════');
  
  final service = MushafLayoutService();
  
  // Test Page 604
  print('\n📖 Page 604 (Multi-Surah):');
  final layout604 = await service.getPageLayout(604);
  for (var line in layout604) {
    print('  Line ${line.lineNumber}: ${line.lineType.padRight(12)} surah=${line.surahNumber ?? "-"}');
  }
  
  // Test Page 1
  print('\n📖 Page 1 (Al-Fatiha):');
  final layout1 = await service.getPageLayout(1);
  for (var line in layout1.where((l) => l.lineType != 'ayah')) {
    print('  Line ${line.lineNumber}: ${line.lineType} surah=${line.surahNumber}');
  }
  
  // Test Page 187
  print('\n📖 Page 187 (At-Tawbah):');
  final layout187 = await service.getPageLayout(187);
  for (var line in layout187.where((l) => l.lineType != 'ayah')) {
    print('  Line ${line.lineNumber}: ${line.lineType} surah=${line.surahNumber}');
  }
  
  print('\n════════════════════════════════════════');
  print('VERIFICATION COMPLETE');
  print('════════════════════════════════════════');
}
