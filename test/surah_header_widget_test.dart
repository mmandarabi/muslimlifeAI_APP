import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/widgets/quran/surah_header_widget.dart';
import 'package:muslim_mind/models/qcf_surah_header_unicode.dart';

void main() {
  testWidgets('SurahHeaderWidget renders at correct size with QCF font', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SurahHeaderWidget(
            surahId: 112,
            surahHeaderUnicode: kQCFSurahHeaderUnicode[112]!,
          ),
        ),
      ),
    );

    // Find the SizedBox that should be 90px high
    final sizedBoxFinder = find.byType(SizedBox);
    expect(sizedBoxFinder, findsWidgets);

    // Get the SizedBox widget
    final sizedBox = tester.widget<SizedBox>(sizedBoxFinder.first);
    
    // Verify height is 90
    expect(sizedBox.height, 90.0, reason: 'SurahHeaderWidget must have 90px height');
    expect(sizedBox.width, double.infinity, reason: 'SurahHeaderWidget must have infinite width');

    // Find the OverflowBox
    final overflowBoxFinder = find.byType(OverflowBox);
    expect(overflowBoxFinder, findsOneWidget, reason: 'Must have OverflowBox for width expansion');

    // Get the OverflowBox widget
    final overflowBox = tester.widget<OverflowBox>(overflowBoxFinder);
    expect(overflowBox.maxWidth, double.infinity, reason: 'OverflowBox must allow infinite width');

    // Find the FittedBox
    final fittedBoxFinder = find.byType(FittedBox);
    expect(fittedBoxFinder, findsOneWidget, reason: 'Must have FittedBox for scaling');

    // Get the FittedBox widget
    final fittedBox = tester.widget<FittedBox>(fittedBoxFinder);
    expect(fittedBox.fit, BoxFit.fitHeight, reason: 'FittedBox must use fitHeight');

    // Find the Text widget
    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget, reason: 'Must have Text widget');

    // Get the Text widget
    final text = tester.widget<Text>(textFinder);
    expect(text.data, kQCFSurahHeaderUnicode[112], reason: 'Text must be the QCF Unicode character');
    expect(text.style?.fontFamily, 'QCF_SurahHeader', reason: 'Must use QCF_SurahHeader font');
    expect(text.style?.fontSize, 300.0, reason: 'Base fontSize must be 300');
    expect(text.style?.height, 1.0, reason: 'Line height must be 1.0');
    expect(text.style?.color, Colors.white, reason: 'Color must be white');

    print('\n✅ SurahHeaderWidget Test Results:');
    print('  • SizedBox height: ${sizedBox.height}px ✓');
    print('  • OverflowBox maxWidth: ${overflowBox.maxWidth} ✓');
    print('  • FittedBox fit: ${fittedBox.fit} ✓');
    print('  • Font family: ${text.style?.fontFamily} ✓');
    print('  • Font size: ${text.style?.fontSize}px ✓');
    print('  • Line height: ${text.style?.height} ✓');
    print('  • Unicode: ${text.data} ✓');
    print('  • Color: ${text.style?.color} ✓');
  });

  testWidgets('CRITICAL: SurahHeaderWidget maintains 90px height when in Stack (real app scenario)', (WidgetTester tester) async {
    const screenHeight = 800.0;
    const standardLineHeight = screenHeight / 15.0; // ~53px per line
    const headerHeight = 90.0;
    
    // Calculate cumulative Y positions like the real app
    final List<double> lineStartPositions = [];
    double currentY = 0.0;
    
    for (int i = 0; i < 15; i++) {
      lineStartPositions.add(currentY);
      // First line is a header
      if (i == 0) {
        currentY += headerHeight;
      } else {
        currentY += standardLineHeight;
      }
    }
    
    // Simulate the real app layout: Stack with Positioned children
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: screenHeight,
            child: Stack(
              children: List.generate(15, (index) {
                if (index == 0) {
                  // This is a header line
                  return Positioned(
                    top: lineStartPositions[index],
                    left: 0,
                    right: 0,
                    height: headerHeight,
                    child: SurahHeaderWidget(
                      surahId: 112,
                      surahHeaderUnicode: kQCFSurahHeaderUnicode[112]!,
                    ),
                  );
                } else {
                  // Other lines
                  return Positioned(
                    top: lineStartPositions[index],
                    left: 0,
                    right: 0,
                    height: standardLineHeight,
                    child: Container(color: Colors.grey),
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );

    // Get the actual rendered size of the SurahHeaderWidget
    final headerFinder = find.byType(SurahHeaderWidget);
    expect(headerFinder, findsOneWidget);
    
    final RenderBox headerBox = tester.renderObject(headerFinder);
    final actualHeight = headerBox.size.height;
    
    print('\n🔍 Real App Scenario Test (Stack Layout):');
    print('  • Screen height: $screenHeight');
    print('  • Standard line height: $standardLineHeight');
    print('  • Header height: $headerHeight');
    print('  • Header actual rendered height: $actualHeight');
    print('  • Expected height: 90px');
    
    // THIS IS THE CRITICAL TEST - it should be 90px
    expect(actualHeight, greaterThanOrEqualTo(85.0), 
      reason: 'Header must render at least 85px tall (close to 90px), but got $actualHeight. '
             'Stack layout should allow headers to use their full 90px height!');
    
    if (actualHeight < 85.0) {
      print('\n❌ FAILURE: Header is only ${actualHeight}px instead of 90px!');
      print('   Stack layout is not working correctly.');
    } else {
      print('\n✅ SUCCESS: Header is ${actualHeight}px (≥85px)');
      print('   Stack layout allows headers to use full 90px height!');
    }
  });

  testWidgets('SurahHeaderWidget renders all three Page 604 headers correctly', (WidgetTester tester) async {
    final testCases = [
      {'id': 112, 'name': 'Al-Ikhlas', 'unicode': kQCFSurahHeaderUnicode[112]!},
      {'id': 113, 'name': 'Al-Falaq', 'unicode': kQCFSurahHeaderUnicode[113]!},
      {'id': 114, 'name': 'An-Nas', 'unicode': kQCFSurahHeaderUnicode[114]!},
    ];

    for (final testCase in testCases) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SurahHeaderWidget(
              surahId: testCase['id'] as int,
              surahHeaderUnicode: testCase['unicode'] as String,
            ),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final text = tester.widget<Text>(textFinder);
      
      expect(text.data, testCase['unicode'], 
        reason: '${testCase['name']} must use correct Unicode character');
      
      print('✅ ${testCase['name']} (${testCase['id']}): ${testCase['unicode']}');
    }
  });
}
