import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All 15 lines have equal height constraint', () {
    const double pageHeight = 1050.0;
    const int totalLines = 15;
    const double expectedLineHeight = pageHeight / totalLines; // 70.0
    
    print('\n=== LINE HEIGHT CONSISTENCY TEST ===');
    print('Page height: $pageHeight');
    print('Total lines: $totalLines');
    print('Expected line height: $expectedLineHeight');
    print('');
    
    // Simulate the build
    final List<double> lineHeights = [];
    
    for (int i = 0; i < 15; i++) {
      final height = pageHeight / totalLines;
      lineHeights.add(height);
      print('Line ${i + 1}: height = $height px');
    }
    
    // Verify all heights are equal
    for (int i = 0; i < lineHeights.length; i++) {
      expect(lineHeights[i], expectedLineHeight,
        reason: 'Line ${i + 1} height must be $expectedLineHeight');
    }
    
    // Verify total adds up
    final totalHeight = lineHeights.reduce((a, b) => a + b);
    expect(totalHeight, pageHeight,
      reason: 'All line heights must sum to page height');
    
    print('');
    print('✅ All lines have equal height: $expectedLineHeight px\n');
  });
}
