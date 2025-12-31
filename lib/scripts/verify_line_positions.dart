import 'package:flutter/material.dart';
import '../services/mushaf_coordinate_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const pageNum = 604;
  final coordService = MushafCoordinateService();
  final pageData = await coordService.getPageData(pageNum, Size(430, 1050));
  
  print('=== Page $pageNum Line Bounds Verification ===');
  print('Reference (from service): ${MushafCoordinateService.kCanonicalWidth} x ${MushafCoordinateService.kCanonicalHeight}');
  print('Canvas Size: 430 x 1050');
  print('Scale X: ${430 / MushafCoordinateService.kCanonicalWidth}');
  print('Scale Y: ${1050 / MushafCoordinateService.kCanonicalHeight}');
  print('');
  
  final sortedLines = pageData.lineBounds.keys.toList()..sort();
  
  for (int lineNum in sortedLines) {
    final bound = pageData.lineBounds[lineNum]!;
    final scaleY = 1050 / MushafCoordinateService.kCanonicalHeight;
    
    print('Line $lineNum:');
    print('  DB bounds: top=${bound.top.toStringAsFixed(2)}, bottom=${bound.bottom.toStringAsFixed(2)}');
    print('  Scaled: top=${(bound.top).toStringAsFixed(2)}, bottom=${(bound.bottom).toStringAsFixed(2)}');
    print('  Expected grid line (70px each): ${((lineNum - 1) * 70).toStringAsFixed(2)}');
    print('');
  }
  
  print('Total lines found: ${sortedLines.length}');
}
