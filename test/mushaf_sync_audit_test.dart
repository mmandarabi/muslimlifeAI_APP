
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  const String assetDbPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';

  setUpAll(() async {
    try {
      final dbDir = await getDatabasesPath();
      print("📂 Databases Path: $dbDir");
      final targetDbPath = p.join(dbDir, "ayahinfo.db");
      
      final dbFolder = Directory(dbDir);
      if (!await dbFolder.exists()) {
        await dbFolder.create(recursive: true);
      }
      
      final sourceFile = File(assetDbPath);
      if (!await sourceFile.exists()) {
        throw Exception("❌ SOURCE DB NOT FOUND: $assetDbPath");
      }
      
      await sourceFile.copy(targetDbPath);
      print("✅ Database prepared: $targetDbPath");
    } catch (e, stack) {
      print("❌ Error in setUpAll: $e");
      print(stack);
      rethrow;
    }
  });

  test('Headless Mushaf Sync Audit (1-604)', () async {
    try {
      final textService = MushafTextService();
      
      final mapPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
      if (!File(mapPath).existsSync()) {
        throw Exception("❌ MAP FILE NOT FOUND: $mapPath");
      }
      
      final mapContent = File(mapPath).readAsStringSync();
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockDecodedMessageHandler<String?>(
        const BasicMessageChannel('flutter/assets', StringCodec.instance),
        (message) async {
          if (message == 'assets/quran/mushaf_v2_map.txt') {
            return mapContent;
          }
          return null;
        },
      );

      print("⏳ Initializing MushafTextService...");
      await textService.initialize();
      final dataService = MushafDataService();

      print("\n🚀 STARTING HEADLESS MUSHAF SYNC AUDIT (1-604) 🚀");
      print("PAGE | TOKENS | DB_GLYPHS | SYNC | FIRST_VERSE_LINE | NOTES");
      print("-----|--------|-----------|------|------------------|------");

      int totalPassed = 0;
      List<int> failedPages = [];

      for (int page = 1; page <= 604; page++) {
        final sanitizedLines = await textService.getPageLines(page);

        // 1. Tokenize (Using production logic)
        List<String> tokens = [];
        for (var l in sanitizedLines) {
          tokens.addAll(l.split(' ').where((t) => t.trim().isNotEmpty));
        }

      // 2. Fetch Glyph Info
      final List<Map<String, dynamic>> glyphs = await dataService.getPageGlyphs(page);

      // 3. Sync Check
      bool countPass = tokens.length == glyphs.length;

      // 4. Structural Offset Check (First Verse Line)
      String structStatus = "N/A";
      if (glyphs.isNotEmpty) {
        // Find first glyph where ayah > 0
        final firstVerseGlyph = glyphs.firstWhere(
          (g) => (g['ayah_number'] as int) > 0, 
          orElse: () => <String, dynamic>{}
        );
        
        if (firstVerseGlyph.isNotEmpty) {
          int dbFirstLine = firstVerseGlyph['line_number'] as int;
          
          // Find index of first line in sanitizedLines that contains text
          int textFirstLineIdx = sanitizedLines.indexWhere((l) => l.trim().isNotEmpty);
          int textFirstLine = textFirstLineIdx + 1; // 1-indexed
          
          if (textFirstLine == dbFirstLine) {
             structStatus = "PASS (L$dbFirstLine)";
          } else {
             structStatus = "FAIL (L$textFirstLine vs DB L$dbFirstLine)";
             countPass = false; 
          }
        }
      }

      String notes = "";
      if (page == 374) {
         // P374 "Ghost Footer" Verification (Logging before truncation for audit)
         // Since we already applied truncation, we need to bypass it to log the 'ghost'
         // But the audit should show it matches the DB *after* truncation.
         if (!countPass) notes = "P374 Drift detected.";
      }

      if (countPass) {
        totalPassed++;
      } else {
        failedPages.add(page);
        print("❌ Page $page: Tokens=${tokens.length} DB=${glyphs.length} Struct=$structStatus");
      }

      if (page % 50 == 0) {
         // Periodic progress
         // print("... Audited $page pages.");
      }
    }

    print("-------------------------------------------------------");
    print("FINAL REPORT:");
    print("✅ PASSED: $totalPassed / 604");
    print("❌ FAILED: ${failedPages.length}");
    
    expect(failedPages, isEmpty, reason: "Mushaf Integrity Check Failed. Pages ${failedPages} have sync/structure mismatches.");
  });
}
