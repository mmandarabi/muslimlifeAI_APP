import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final cwd = Directory.current.path;
    final dbPath = '$cwd/assets/quran/databases/qpc-v1-15-lines.db';
    if (!File(dbPath).existsSync()) throw Exception('Layout DB not found at $dbPath');
    MushafLayoutService.overrideDbPath = dbPath;
  });

  test('Line 1 builds as surah_name header for Page 604', () async {
    final layout = await MushafLayoutService.getPageLayout(604);
    
    print('\n=== LINE 1 HEADER TEST ===');
    
    // Find Line 1
    final line1 = layout.firstWhere(
      (l) => l.lineNumber == 1,
      orElse: () => throw Exception('Line 1 not found in layout!'),
    );
    
    print('Line 1 data:');
    print('  lineNumber: ${line1.lineNumber}');
    print('  lineType: ${line1.lineType}');
    print('  surahNumber: ${line1.surahNumber}');
    print('  isSurahName: ${line1.isSurahName}');
    print('');
    
    // ASSERTIONS
    expect(line1.lineNumber, 1, reason: 'Should be line 1');
    expect(line1.lineType, 'surah_name', reason: 'Line 1 must be surah_name');
    expect(line1.surahNumber, 112, reason: 'Line 1 must be Surah 112 (Al-Ikhlas)');
    expect(line1.isSurahName, true, reason: 'isSurahName getter must return true');
    
    print('✅ Line 1 correctly identified as Al-Ikhlas header');
  });
  
  test('All 3 headers have valid surah numbers', () async {
    final layout = await MushafLayoutService.getPageLayout(604);
    
    final headers = layout.where((l) => l.lineType == 'surah_name').toList();
    
    print('\n=== HEADER SURAH NUMBERS TEST ===');
    for (var h in headers) {
      print('Line ${h.lineNumber}: surahNumber=${h.surahNumber}');
      expect(h.surahNumber, isNotNull, reason: 'Header must have surahNumber');
      expect(h.surahNumber, greaterThan(0), reason: 'surahNumber must be positive');
    }
    
    expect(headers.length, 3, reason: 'Page 604 should have 3 headers');
    expect(headers[0].surahNumber, 112, reason: 'First header is Al-Ikhlas');
    expect(headers[1].surahNumber, 113, reason: 'Second header is Al-Falaq');
    expect(headers[2].surahNumber, 114, reason: 'Third header is An-Nas');
    
    print('✅ All headers have correct surah numbers\n');
  });
}
