import 'dart:io';
import 'package:flutter/services.dart';
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
    final dbDir = await getDatabasesPath();
    final targetDbPath = p.join(dbDir, "ayahinfo.db");
    await Directory(dbDir).create(recursive: true);
    await File(assetDbPath).copy(targetDbPath);
    print("✅ Database prepared for Page 604 verification.\n");
  });

  test('Page 604 Synchronicity Verification', () async {
    final textService = MushafTextService();
    
    final mapPath = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    final mapContent = File(mapPath).readAsStringSync();
    
    ServicesBinding.instance.defaultBinaryMessenger.setMockDecodedMessageHandler<String?>(
      const BasicMessageChannel('flutter/assets', StringCodec()),
      (message) async {
        if (message == 'assets/quran/mushaf_v2_map.txt') {
          return mapContent;
        }
        return null;
      },
    );

    await textService.initialize();
    final dataService = MushafDataService();

    print("🔍 VERIFYING PAGE 604 SYNCHRONICITY\n");
    print("=" * 60);

    final sanitizedLines = await textService.getPageLines(604);
    
    // Tokenize
    List<String> tokens = [];
    for (var l in sanitizedLines) {
      tokens.addAll(l.split(' ').where((t) => t.trim().isNotEmpty));
    }

    // Fetch Glyph Info
    final List<Map<String, dynamic>> glyphs = await dataService.getPageGlyphs(604);

    print("📊 TOKEN COUNT: ${tokens.length}");
    print("📊 GLYPH COUNT: ${glyphs.length}");
    print("=" * 60);

    if (tokens.length == glyphs.length) {
      print("✅ PASS: Page 604 is perfectly synchronized!");
      print("   Text tokens = DB glyphs = ${tokens.length}");
    } else {
      print("❌ FAIL: Page 604 has drift!");
      print("   Difference: ${glyphs.length - tokens.length}");
      
      // Show last 10 tokens/glyphs
      print("\nLast 10 items:");
      for (int i = tokens.length - 10; i < tokens.length || i < glyphs.length; i++) {
        String t = (i < tokens.length) ? tokens[i] : "---";
        String db = "---";
        if (i < glyphs.length) {
          final g = glyphs[i];
          int line = g['line_number'] as int;
          int pos = g['position'] as int;
          db = "L$line:$pos";
        }
        print("  [$i] Token: $t | DB: $db");
      }
    }
    print("=" * 60);

    expect(tokens.length, equals(glyphs.length), 
      reason: "Page 604 token count must match database glyph count exactly");
  });
}
