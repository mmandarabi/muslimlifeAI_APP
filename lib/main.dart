import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_service/audio_service.dart'; // 🆕 PHASE 2.5

import 'package:muslim_mind/screens/dashboard_screen.dart';
import 'package:muslim_mind/screens/intro_screen.dart';
import 'package:muslim_mind/screens/landing_page.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/services/prayer_log_service.dart';
import 'package:muslim_mind/services/theme_service.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/quran_audio_handler.dart'; // 🆕 PHASE 2.5

import 'firebase_options.dart';
import 'package:muslim_mind/widgets/expandable_audio_player.dart';
import 'package:muslim_mind/config/navigation_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Parallelize critical initializations to reduce startup time
  await Future.wait([
    ThemeService().init(),
    UnifiedAudioService().init(),
    PrayerLogService().init(),
    _initializeFirebase(),
    // _initializeAudioService(), // 🔧 HOTFIX: Disabled - was breaking audio playback
  ]);

  // Use Emulators in Debug Mode
  if (kDebugMode) {
    try {
      // FIX: Use 'localhost' for Web, and '10.0.2.2' for Android
      String emulatorHost = kIsWeb ? '127.0.0.1' : '10.0.2.2';
      // For Web/iOS, usually localhost, but user specifically asked for Android fix.
      // We can make it conditional if needed, but for now specific Android request logic.
      // Actually, standard practice:
      // String host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
      
      // await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099); // Connects to local emulator, not live Firebase
      // FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080); // Uncomment if Firestore is used
      debugPrint('Firebase Emulator connection is currently disabled. Connecting to LIVE Firebase.');
    } catch (e) {
      debugPrint('Error interacting with emulator: $e');
    }
  }

  // Enable persistent login on Web
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(const MuslimMindApp());
}

Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
    debugPrint('Firebase already initialized');
  }
}

/// 🆕 PHASE 2.5: Initialize audio_service for background playback
Future<void> _initializeAudioService() async {
  try {
    await AudioService.init(
      builder: () => QuranAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.muslimlife.muslimmind.audio',
        androidNotificationChannelName: 'Quran Recitation',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
    debugPrint('AudioService initialized successfully');
  } catch (e) {
    debugPrint('AudioService initialization error: $e');
    // Non-fatal: App can still work without background audio
  }
}

class MuslimMindApp extends StatelessWidget {
  const MuslimMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        return MaterialApp(
          title: 'MuslimMind',
          navigatorKey: rootNavigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService().themeMode,
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                // Global Immersive Player - Persistent across all routes
                const ExpandableAudioPlayer(key: ValueKey('global_audio_player')),
              ],
            );
          },
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              debugPrint("Auth State Chain: ${snapshot.connectionState} | HasData: ${snapshot.hasData} | Error: ${snapshot.error}");
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFF0B0C0E),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                 return Scaffold(
                  backgroundColor: const Color(0xFF0B0C0E),
                  body: Center(
                    child: Text(
                      "Auth Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                debugPrint("User detected: ${snapshot.data?.uid}");
                return const DashboardScreen();
              }

              debugPrint("No user detected. Showing Landing/Intro.");
              if (kIsWeb) {
                return const LandingPage();
              } else {
                return const IntroScreen();
              }
            },
          ),
        );
      },
    );
  }
}
