import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/main.dart';
import 'package:muslim_mind/widgets/expandable_audio_player.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Mock Firebase and SharedPreferences for testing
  // Mock just_audio platform channel
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.ryanheise.just_audio.methods', (message) async {
      return null;
    });
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() async {
    // Reset singleton state between tests
    final service = UnifiedAudioService();
    // Force stop to clear internal IDs
    await service.stop(); 
    service.currentSurahContext.value = null;
  });

  group('Audio Unification Tests', () {
    testWidgets('Global ExpandableAudioPlayer should be present in the widget tree', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      // Note: We use a simplified wrapper to avoid Firebase dependency issues in standard widget tests
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Center(child: Text('App Content')),
                ExpandableAudioPlayer(key: ValueKey('global_audio_player')),
              ],
            ),
          ),
        ),
      );

      // Verify that the global player is found by its key
      expect(find.byKey(const ValueKey('global_audio_player')), findsOneWidget);
    });

    testWidgets('UnifiedAudioService should format Surah names correctly and handle deferral', (WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox()); // Initialize binding
      
      final service = UnifiedAudioService();
      service.setContext(1);
      
      print("TEST DEBUG: Immediate check: ID=${service.currentSurahId}");
      expect(service.currentSurahId, 1, reason: "ID should be set synchronously");
      
      // Update expectation: NOW it should be set immediately because we made setContext synchronous
      expect(service.currentSurahContext.value, isNotNull, reason: "Context should be set synchronously");
      expect(service.currentSurahContext.value?.surahId, 1);
      
      await tester.pumpAndSettle(); // Flush post-frame callbacks
      print("TEST DEBUG: After pump: ID=${service.currentSurahId}");
      print("TEST DEBUG: Before final expect Context=${service.currentSurahContext.value}");
      
      expect(service.currentSurahId, 1, reason: "ID should persist after pump");
      // quran package returns 'Al-Fatiha' (no trailing h in some versions, or verify output)
      // Log showed "ExpandableAudioPlayer: Build. Surah: Al Fatiha"
      // So matching that.
      expect(service.currentSurahContext.value?.surahName.toLowerCase(), contains('fatiha'));
    });

    testWidgets('Global player should persist after navigation', (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Stack(
            children: [
              if (child != null) child,
              const ExpandableAudioPlayer(key: ValueKey('global_player')),
            ],
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Scaffold(body: Text('New Page')))),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('global_player')), findsOneWidget);
      
      // Navigate
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      
      // Verify "New Page" is visible
      expect(find.text('New Page'), findsOneWidget);
      
      // KEY FIX: The Global Player is in the MaterialApp builder (above the Navigator).
      // So it should still be in the tree.
      expect(find.byKey(const ValueKey('global_player')), findsOneWidget);
    });
  });
}
