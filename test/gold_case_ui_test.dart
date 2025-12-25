
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/screens/quran_read_mode.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    // Ensure fonts don't crash tests
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Gold Case UI Acceptance - Automated Checks', () {
    
    testWidgets('Verify Premium Dark Palette enforcement', (WidgetTester tester) async {
      // 1. Pump the app with the Dark Theme (The "Gold" Standard)
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Center(child: Text("Sanctuary"))),
        ),
      );

      // 2. Verify Background Color (Scaffold builds a Material widget with the background color)
      final material = tester.widget<Material>(find.descendant(of: find.byType(Scaffold), matching: find.byType(Material)).first);
      expect(material.color, const Color(0xFF202124), reason: "Background must be Raisin Black #202124");
      
      // 3. Verify Text Color defaults
      final text = tester.widget<Text>(find.text("Sanctuary"));
      expect(AppTheme.darkTheme.primaryColor, const Color(0xFF10B981), reason: "Primary must be Sanctuary Emerald");
    });

    testWidgets('Verify GlassCard properties (Blur & Transparency)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: GlassCard(child: const Text("Glass Content")),
          ),
        ),
      );

      // Check for BackdropFilter
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('Verify Light Mode Implementation', (WidgetTester tester) async {
       // 1. Pump the app with Light Theme
       await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: Center(child: Text("Sanctuary Light"))),
        ),
      );

      // 2. Verify Background Color (Card Light / Background Light)
      final material = tester.widget<Material>(find.descendant(of: find.byType(Scaffold), matching: find.byType(Material)).first);
      // AppColors.backgroundLight is 0xFFF1F3F4
      expect(material.color, const Color(0xFFF1F3F4), reason: "Background must be Anti-Flash White #F1F3F4 in Light Mode");
      
      // 3. Verify Text Contrast
      // We can check if the theme's text color is correct
       expect(AppTheme.lightTheme.textTheme.bodyLarge?.color, const Color(0xFF202124), reason: "Text must be Raisin Black in Light Mode");
    });
  });
}
