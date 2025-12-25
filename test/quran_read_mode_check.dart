import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/screens/quran_read_mode.dart';
import 'package:muslim_mind/services/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Fake JSON Data for Surah Fatiha
  final mockQuranJson = jsonEncode([
    {
      "id": 1,
      "name": "الفاتحة",
      "transliteration": "Al-Fātiḥah",
      "translation": "The Opener",
      "type": "meccan",
      "total_verses": 7,
      "verses": [
        {"id": 1, "text": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "translation": "In the name of Allah..."},
        {"id": 2, "text": "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ", "translation": "All praise is due to Allah..."}
      ]
    }
  ]);

  testWidgets('QuranReadMode Inspire UI Check', (WidgetTester tester) async {
    // 1. Mock Asset Loading
    tester.binding.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (ByteData? message) async {
      // This is a simplified handler. In real implementations, decode the message to check keys.
      // But for this test, we assume any asset load is the Quran JSON.
      // Or we can just return standard empty for others.
      // The key is usually encoded in the message.
      
      // Since deciphering the key needs Buffer reading, we can use `AssetBundle`.
      // But `QuranLocalService` calls `rootBundle.loadString` directly.
      
      // Let's assume request for 'assets/quran/quran_uthmani.json'
      // We'll just return the mock JSON utf8 bytes.
      return ByteData.view(Uint8List.fromList(utf8.encode(mockQuranJson)).buffer);
    });

    // 2. Pump Widget
    await tester.pumpWidget(MaterialApp(
      home: QuranReadMode(surahId: 1, surahName: 'Al-Fātiḥah', initialPage: 1),
    ));

    // Wait for FutureBuilder
    // pumpAndSettle times out due to background tasks or infinite animations (loading spinner).
    // We pump manually for a few seconds which is enough for the local asset load.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // Flush layout

    // Debug: Check for Error Widget
    final errorFinder = find.textContaining("Error:");
    if (errorFinder.evaluate().isNotEmpty) {
       final errorText = (errorFinder.evaluate().first.widget as Text).data;
       debugPrint("❌ UI showing Error: $errorText");
    }

    // 3. Assert Cinematic Header (Gold Title)
    final goldTitleFinder = find.byWidgetPredicate((widget) {
      if (widget is Text && widget.data != null && widget.data!.contains('سُورَةُ')) {
         debugPrint("Found Surah Title: ${widget.data}, Color: ${widget.style?.color}");
         return widget.style?.color == const Color(0xFFD4AF37);
      }
      return false;
    });
    expect(goldTitleFinder, findsOneWidget, reason: "Gold Arabic Title should be visible");

    // 4. Assert Metadata Line ("X Ayahs")
    final metadataFinder = find.textContaining("Ayahs");
    expect(metadataFinder, findsOneWidget, reason: "Metadata line should be visible");

    // 5. Assert Sanctuary Surface (#35363A)
    final surfaceFinder = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final box = widget.decoration as BoxDecoration;
        return box.color == const Color(0xFF35363A) && box.borderRadius == BorderRadius.circular(40);
      }
      return false;
    });
    expect(surfaceFinder, findsAtLeastNWidgets(1), reason: "Sanctuary Surface (#35363A) should be wrapping text");

    // 6. Assert Navigation Pill
    final pillFinder = find.byWidgetPredicate((widget) {
       if (widget is Container && widget.decoration is BoxDecoration) {
         final box = widget.decoration as BoxDecoration;
         // Pill is black with opacity and rounded 100
         return box.borderRadius == BorderRadius.circular(100) && (box.color as Color).opacity < 1.0;
       }
       return false;
    });
    expect(pillFinder, findsOneWidget, reason: "Navigation Pill should be present");

    debugPrint("✅ All Inspire UI elements verified successfully.");
  });
}
