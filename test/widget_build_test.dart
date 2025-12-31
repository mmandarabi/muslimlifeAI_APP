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
    if (!File(dbPath).existsSync()) throw Exception('Layout DB not found');
    MushafLayoutService.overrideDbPath = dbPath;
  });

  test('Simulate widget build for all 15 lines', () async {
    final layout = await MushafLayoutService.getPageLayout(604);
    
    // Simulate text lines (9 ayah lines based on layout)
    final ayahCount = layout.where((l) => l.lineType == 'ayah').length;
    final textLines = List.generate(ayahCount, (i) => 'TextLine $i');
    
    print('\n=== WIDGET BUILD SIMULATION (Page 604) ===');
    print('');
    
    int ayahCursor = 0;
    final List<String> builtWidgets = [];
    
    for (int gridLine = 1; gridLine <= 15; gridLine++) {
      final lineData = layout.firstWhere(
        (l) => l.lineNumber == gridLine,
        orElse: () => LayoutLine(pageNumber: 604, lineNumber: gridLine, lineType: 'unknown', isCentered: false),
      );
      
      String widgetType;
      String details;
      
      switch (lineData.lineType) {
        case 'surah_name':
          widgetType = 'SurahHeaderWidget';
          details = 'surahId=${lineData.surahNumber}';
          break;
        case 'basmallah':
          widgetType = 'Text("﷽")';
          details = 'Bismillah ligature';
          break;
        case 'ayah':
          widgetType = 'Text(ayah)';
          details = 'textLines[$ayahCursor]';
          ayahCursor++;
          break;
        default:
          widgetType = 'UNKNOWN';
          details = 'lineType=${lineData.lineType}';
      }
      
      builtWidgets.add(widgetType);
      print('Line $gridLine: $widgetType → $details');
    }
    
    print('');
    print('=== BUILD VERIFICATION ===');
    
    // Verify Line 1 builds a header
    expect(builtWidgets[0], 'SurahHeaderWidget', 
      reason: 'Line 1 must build SurahHeaderWidget');
    
    // Verify Line 2 builds bismillah
    expect(builtWidgets[1], 'Text("﷽")', 
      reason: 'Line 2 must build Bismillah');
    
    // Verify cursor consumed all text lines
    expect(ayahCursor, textLines.length, 
      reason: 'All text lines must be consumed');
    
    print('✅ Widget build simulation passed\n');
  });
}
