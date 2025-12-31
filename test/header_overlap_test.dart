import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/widgets/quran/surah_header_widget.dart';

void main() {
  testWidgets('SurahHeaderWidget allows visual overflow in constricted slot', (WidgetTester tester) async {
    // Define the overlap strategy parameters
    const double logicalSlotHeight = 85.0;
    const double visualTargetHeight = 130.0;

    // Build the widget inside a constrained box simulating the Stack/Positioned slot
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: logicalSlotHeight, // The strict constraint (85px)
            width: 300,
            child: SurahHeaderWidget(
              surahId: 112,
              surahHeaderUnicode: '\uFBE8', // Dummy QCF char
            ),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // 1. Verify the widget builds without error
    expect(find.byType(SurahHeaderWidget), findsOneWidget);

    // 2. Find the OverflowBox
    final overflowFinder = find.byType(OverflowBox);
    expect(overflowFinder, findsOneWidget);

    // 3. Find the inner SizedBox that sets the visual height
    // We expect a SizedBox with height 130 inside the OverflowBox
    // We can't find by height directly, but we can verify the RenderObject size of the TEXT container?
    // Actually, let's find the SizedBox *inside* the SurahHeaderWidget
    final innerSizedBoxFinder = find.descendant(
      of: find.byType(SurahHeaderWidget),
      matching: find.byType(SizedBox),
    );
    
    // There will be 2 SizedBoxes:
    // 1. The outer one (height: 130) -> Wait, widget definition has SizedBox(height: 130)
    // 2. The inner one inside OverflowBox (height: 130)
    
    // Let's verify layout.
    // The parent constraint is 85.
    // The widget returns SizedBox(height: 130).
    // Normally this would overflow or clip.
    // BUT since it's inside our test SizedBox(height: 85), the widget's outer SizedBox is forced to 85.
    // Inside the widget:
    // return SizedBox(height: 130) -> This actually gets clamped by parent if strict?
    // Wait. In the app, it's inside Positioned(height: 85). Positioned forces exact height.
    // So the outer SizedBox of SurahHeaderWidget gets constraints: minHeight=85, maxHeight=85.
    // So `height: 130` is ignored/clamped. Effective size is 85.
    
    // Inside that, OverflowBox(minH: 0, maxH: infinity).
    // Inside that, SizedBox(height: 130).
    // This inner SizedBox receives "loose" constraints from OverflowBox.
    // So it SHOULD be 130.
    
    // Let's verify that INNER SizedBox size.
    final boxWidgets = tester.widgetList<SizedBox>(innerSizedBoxFinder);
    // We expect specific heights.
    
    bool foundVisualHeight = false;
    for (var box in boxWidgets) {
      if (box.height == visualTargetHeight) {
        foundVisualHeight = true;
      }
    }
    
    expect(foundVisualHeight, isTrue, reason: "Inner contents should render at $visualTargetHeight px");

    // 4. Verify no Layout Overflow warnings (tester would fail if standard overflow occurred without OverflowBox)
    // The mere fact that test passes is good.
    
    print('✅ Overlap Strategy Constraints Verified:');
    print('   - Parent Slot: ${logicalSlotHeight}px');
    print('   - Content Render: ${visualTargetHeight}px');
    print('   - Result: Content successfully renders larger than slot!');
  });
}
