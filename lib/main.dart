import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:muslim_life_ai_demo/screens/dashboard_screen.dart';
import 'package:muslim_life_ai_demo/screens/intro_screen.dart';
import 'package:muslim_life_ai_demo/screens/landing_page.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/services/theme_service.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().init();
  await UnifiedAudioService().init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Use Emulators in Debug Mode
  if (kDebugMode) {
    try {
      // FIX: Use 'localhost' for Web, and '10.0.2.2' for Android
      String emulatorHost = kIsWeb ? '127.0.0.1' : '10.0.2.2';
      // For Web/iOS, usually localhost, but user specifically asked for Android fix.
      // We can make it conditional if needed, but for now specific Android request logic.
      // Actually, standard practice:
      // String host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
      
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
      // FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080); // Uncomment if Firestore is used
      debugPrint('Using Firebase Emulator at $emulatorHost:9099');
    } catch (e) {
      debugPrint('Error interacting with emulator: $e');
    }
  }

  // Enable persistent login on Web
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(const MuslimLifeAIApp());
}

class MuslimLifeAIApp extends StatelessWidget {
  const MuslimLifeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        return MaterialApp(
          title: 'MuslimLife AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService().themeMode,
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
