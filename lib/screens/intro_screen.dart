import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/screens/dashboard_screen.dart';
import 'package:muslim_mind/screens/login_screen.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/grid_painter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _phase = 0;
  Timer? _timer;
  double _progress = 0.0;
  bool _isPaused = false;
  int _elapsedMilliseconds = 0;
  final List<int> _phaseThresholds = [4000, 9000, 15000, 22000, 29000];

  final List<Map<String, String>> _phases = [
    {
      "title": "Faith in the modern world is noisy.",
      "subtitle": "System Initialization",
    },
    {
      "title": "Securing your data on-device...",
      "subtitle": "Privacy Protocol",
    },
    {
      "title": "Connecting to verified Fiqh & Quran sources...",
      "subtitle": "Source Authentication",
    },
    {
      "title": "Calibrating to your location & habits...",
      "subtitle": "Context Engine",
    },
    {
      "title": "Your intelligent spiritual companion is ready.",
      "subtitle": "MuslimMind",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;

      _elapsedMilliseconds += 100;

      int newPhase = 0;
      for (int i = 0; i < _phaseThresholds.length; i++) {
        if (_elapsedMilliseconds >= _phaseThresholds[i]) {
          newPhase = i + 1;
        }
      }

      if (newPhase > 4) newPhase = 4;

      if (newPhase != _phase) {
        setState(() {
          _phase = newPhase;
          _progress = _phase / 4.0;
        });
      }

      if (_phase == 4) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPhaseData = _phases[_phase];
    final isReady = _phase == 4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF064E3B), // Dark Emerald
              AppColors.background,
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Grid Background
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(opacity: 0.05, spacing: 50),
                ),
              ),
              
              // Skip Button
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: _navigateToDashboard,
                  child: Text(
                    "Skip Intro",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // Central Content
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    key: ValueKey<int>(_phase),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPhaseData["title"]!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.primary,
                              shadows: [
                                const Shadow(
                                  color: AppColors.primary,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 600.ms).moveY(begin: 10, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        currentPhaseData["subtitle"]!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                    ],
                  ),
                ),
              ),

              // Bottom Progress or Action
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    if (isReady)
                      FilledButton(
                        onPressed: _navigateToDashboard,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        child: const Text("Initialize System"),
                      ).animate().fadeIn(duration: 500.ms).scale()
                    else
                      Column(
                        children: [
                          LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.white10,
                            color: AppColors.primary,
                            minHeight: 2,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "LOADING MODULES...",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.primary.withOpacity(0.7),
                                  letterSpacing: 2,
                                ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    // Pause/Resume Toggle
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPaused ? LucideIcons.play : LucideIcons.pause,
                            size: 14,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isPaused ? "RESUME SEQUENCE" : "PAUSE SEQUENCE",
                            style: const TextStyle(
                              fontFamily: 'Courier', // Monospace
                              fontSize: 12,
                              color: Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
