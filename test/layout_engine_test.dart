import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_engine.dart';

void main() {
  group('MushafLayoutEngine', () {
    
    // Test 1: Basic Logic (From Initial Verification)
    test('Standard Layout - No Compression', () {
      final metrics = MushafLayoutEngine.computeDynamicMetrics(
        lineNum: 1, 
        standardLineHeight: 50.0, 
        ayahTops: {3: 100.0}
      );
      expect(metrics.fontSizeScale, 1.0);
    });

    test('Page 604 Compression Logic', () {
      const double h70 = 70.0;
      final actualL3 = 97.4;
      final expectedL3 = 140.0;
      
      final metrics = MushafLayoutEngine.computeDynamicMetrics(
        lineNum: 1, 
        standardLineHeight: h70, 
        ayahTops: {3: actualL3}
      );
      
      // Scale = 97.4 / 140 = 0.695
      final expectedScale = actualL3 / expectedL3;
      expect(metrics.fontSizeScale, closeTo(expectedScale, 0.01));
    });
    
    // Test 2: Layout Engine Math (User Requested)
    test('Line positions do not overlap (Math Proof)', () async {
      final engine = MushafLayoutEngine();
      final pageHeight = 1050.0;
      // Use Page 604 simulation
      final positions = await engine.calculateLinePositions(604, pageHeight);
      
      for (int i = 0; i < positions.length - 1; i++) {
        final current = positions[i];
        final next = positions[i + 1];
        
        // Each line should start AFTER previous line ends
        // Allow tiny floating point tolerance
        expect(next.top, greaterThanOrEqualTo(current.bottom - 0.01),
          reason: 'Line ${i+2} overlaps with Line ${i+1}');
      }
    });

    test('All 15 lines fit within page height', () async {
      final engine = MushafLayoutEngine();
      final pageHeight = 1050.0;
      final positions = await engine.calculateLinePositions(604, pageHeight);
      
      expect(positions.last.bottom, lessThanOrEqualTo(pageHeight));
    });

    test('Header height matches grid slot (roughly)', () async {
      final engine = MushafLayoutEngine();
      final pageHeight = 1050.0;
      final lineHeight = pageHeight / 15.0; // 70px
      
      final positions = await engine.calculateLinePositions(604, pageHeight);
      final headerPosition = positions[0]; // Line 1 is header
      
      // On Page 604, Header 1 is compressed.
      // Expected Scale ~0.7. So Height ~49px.
      // User expected "closeTo(lineHeight, 5.0)" is for STANDARD page.
      // For 604, it should be LESS.
      // But let's check Page 2 (Standard)
      final positionsStd = await engine.calculateLinePositions(2, pageHeight);
      final headerStd = positionsStd[0];
      
      expect(headerStd.height, closeTo(lineHeight, 5.0));
    });
  });
}
