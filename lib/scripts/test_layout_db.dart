import 'package:flutter/widgets.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('--- Verifying Page 604 Layout Data ---');
  
  try {
    // Initialize DB
    await MushafLayoutService.initialize();
    
    // Query Page 604
    final headers = await MushafLayoutService.getPageHeaders(604);
    
    if (headers.isEmpty) {
      print('❌ ERROR: No headers found for Page 604!');
    } else {
      print('✅ Found ${headers.length} header lines:');
      for (final entry in headers.entries) {
        final lineNum = entry.key;
        final lines = entry.value;
        for (final line in lines) {
           print('  Line $lineNum: ${line.lineType} (Surah: ${line.surahNumber})');
        }
      }
    }
    
    // Also check standard lines to verify line types
    print('\n--- All Lines Sample ---');
    final allLines = await MushafLayoutService.getPageLayout(604);
    for (final line in allLines) {
      print('Line ${line.lineNumber}: ${line.lineType}');
    }

  } catch (e) {
    print('❌ EXCEPTION: $e');
  }
}
