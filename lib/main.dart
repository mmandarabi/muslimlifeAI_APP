import 'package:flutter/material.dart';
import 'package:muslim_life_ai_demo/screens/intro_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';

void main() {
  runApp(const MuslimLifeAIApp());
}

class MuslimLifeAIApp extends StatelessWidget {
  const MuslimLifeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuslimLife AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const IntroScreen(),
    );
  }
}
