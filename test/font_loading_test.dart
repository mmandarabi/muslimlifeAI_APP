import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/models/qcf_surah_header_unicode.dart';

void main() {
  testWidgets('CRITICAL: QCF Font Actually Loads and Renders', (WidgetTester tester) async {
    print('\n' + '='*60);
    print('CRITICAL FONT LOADING TEST');
    print('='*60 + '\n');
    
    // Render text with QCF font at fontSize 100
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            kQCFSurahHeaderUnicode[113]!,  // Al-Falaq
            style: const TextStyle(
              fontFamily: 'QCF_SurahHeader',
              fontSize: 100,
              height: 1.0,
            ),
          ),
        ),
      ),
    ));
    
    await tester.pumpAndSettle();
    
    final RenderParagraph paragraph = tester.renderObject(find.byType(Text)) as RenderParagraph;
    
    final glyphWidth = paragraph.size.width;
    final glyphHeight = paragraph.size.height;
    final glyphAspectRatio = glyphWidth / glyphHeight;
    
    print('🔍 QCF Font Rendering Test:');
    print('  • fontSize: 100');
    print('  • Glyph width: ${glyphWidth.toStringAsFixed(1)}px');
    print('  • Glyph height: ${glyphHeight.toStringAsFixed(1)}px');
    print('  • Aspect ratio: ${glyphAspectRatio.toStringAsFixed(2)}:1');
    
    final heightRatio = glyphHeight / 100.0;
    print('  • Height/FontSize ratio: ${heightRatio.toStringAsFixed(2)}');
    
    // If font loads correctly, height should be 50-120% of fontSize
    if (heightRatio < 0.5) {
      print('\n❌ CRITICAL FAILURE: Font is NOT loading!');
      print('   Glyph height is only ${glyphHeight.toStringAsFixed(1)}px for fontSize 100');
      print('   This means Flutter is using a FALLBACK FONT');
      print('');
      print('   DIAGNOSIS:');
      print('   1. Check pubspec.yaml has: family: QCF_SurahHeader');
      print('   2. Check font file exists at: assets/fonts/Surahheaderfont/QCF_SurahHeader_COLOR-Regular.ttf');
      print('   3. Run: flutter clean && flutter pub get');
      print('   4. Rebuild the app completely');
    } else {
      print('\n✅ SUCCESS: Font is loading correctly!');
      print('   Glyph renders at proper height');
    }
    
    expect(heightRatio, greaterThan(0.5),
      reason: '❌ CRITICAL: Font NOT loading! Height is ${glyphHeight.toStringAsFixed(1)}px for fontSize 100. '
              'Flutter is using fallback font.');
    
    expect(glyphAspectRatio, lessThan(15.0),
      reason: '❌ VISUAL FAILURE: Aspect ratio ${glyphAspectRatio.toStringAsFixed(1)}:1 indicates thin line.');
  });
}
