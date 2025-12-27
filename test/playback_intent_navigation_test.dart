import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    
    // Minimalistic mocks to satisfy service initialization
    const channels = [
      'com.ryanheise.just_audio.methods',
      'dexterous.com/flutter/local_notifications',
      'be.tramckas.android_alarm_manager_plus/alarm',
      'plugins.flutter.io/path_provider',
      'flutter_timezone',
    ];

    for (var channelName in channels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(channelName), (message) async {
        if (channelName == 'plugins.flutter.io/path_provider') return '.';
        if (channelName == 'flutter_timezone') return 'UTC';
        return {};
      });
    }

    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() {
    debugDefaultTargetPlatformOverride = null;
  });

  setUp(() async {
    final service = UnifiedAudioService();
    // Use reset/stop to clear state
    service.currentSurahContext.value = null;
  });

  testWidgets('Playback Intent & Navigation Integration Test (Context Persistence)', (WidgetTester tester) async {
    final service = UnifiedAudioService();
    
    // === SETUP ===
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        builder: (context, child) {
          return Column(
            children: [
              if (child != null) Expanded(child: child),
              const TestPlayerWidget(key: ValueKey('global_player')),
            ],
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const TestLibraryScreen(),
          '/other': (context) => const TestOtherScreen(),
        },
      ),
    );

    // === STEP 1: Set Context (Simulate Intent) ===
    debugPrint("STEP 1: Set Surah 1 Context");
    service.setContext(1);
    await tester.pumpAndSettle();
    
    expect(service.currentSurahId, 1);
    expect(find.byKey(const Key('player_id')), findsOneWidget);
    expect(find.textContaining('ID: 1'), findsOneWidget);
    
    // === STEP 2: Navigate away and verify persistence ===
    debugPrint("STEP 2: Navigate to Other Screen");
    await tester.tap(find.byKey(const Key('nav_other')));
    await tester.pumpAndSettle();
    
    expect(find.text('Other Screen Content'), findsOneWidget);
    expect(service.currentSurahId, 1, reason: "Context MUST persist after navigation");
    expect(find.byKey(const Key('global_player')), findsOneWidget);
    expect(find.textContaining('ID: 1'), findsOneWidget);

    // === STEP 3: Override Context ===
    debugPrint("STEP 3: Set Surah 2 Context");
    service.setContext(2);
    await tester.pumpAndSettle();
    expect(service.currentSurahId, 2);
    expect(find.textContaining('ID: 2'), findsOneWidget);

    debugPrint("TEST PASSED: Navigation Persistence Verified");
  });
}

// === Test Helpers ===

class TestPlayerWidget extends StatelessWidget {
  const TestPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SurahContext?>(
      valueListenable: UnifiedAudioService().currentSurahContext,
      builder: (context, surah, _) {
        if (surah == null) return const SizedBox.shrink();
        return Material(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text("ID: ${surah.surahId}", key: const Key('player_id'), style: const TextStyle(color: Colors.white, fontSize: 10)),
                const Spacer(),
                Text("NAME: ${surah.surahName}", key: const Key('player_surah_name'), style: const TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TestLibraryScreen extends StatelessWidget {
  const TestLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LIBRARY")),
      body: Column(
        children: [
          ElevatedButton(
            key: const Key('nav_other'),
            onPressed: () => Navigator.pushNamed(context, '/other'),
            child: const Text("Go to Other"),
          ),
        ],
      ),
    );
  }
}

class TestOtherScreen extends StatelessWidget {
  const TestOtherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Other Screen")),
      body: const Center(child: Text("Other Screen Content")),
    );
  }
}
