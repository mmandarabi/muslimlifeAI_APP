import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../services/mushaf_layout_service.dart';

/// Script to inspect the QUL layout database
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('=== QUL Layout Database Inspection ===\n');
  
  try {
    await MushafLayoutService.initialize();
    print('✅ Database initialized\n');
    
    // Page 1
    print('--- PAGE 1 ---');
    final page1 = await MushafLayoutService.getPageLayout(1);
    for (final line in page1) print(line);
    
    // Page 604  
    print('\n--- PAGE 604 ---');
    final page604 = await MushafLayoutService.getPageLayout(604);
    for (final line in page604) print(line);
    
  } catch (e, stack) {
    print('❌ Error: $e');
    print(stack);
  }
}
