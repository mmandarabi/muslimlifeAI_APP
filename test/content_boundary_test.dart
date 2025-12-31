import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Test 6: Content Boundary Verification - No Cross-Surah Contamination', () async {
    final textLines = await MushafTextService().getPageLines(604);
    
    print('\n=== CONTENT BOUNDARY VERIFICATION ===');
    print('Verifying each text line contains ONLY its own Surah content:\n');
    
    // Based on mushaf_v2_map.txt analysis:
    // Original 15 lines (before merge):
    // Lines 0-2: Al-Ikhlas (starts with ﱁ)
    // Lines 3-7: Al-Falaq (starts with ﱎ)
    // Lines 8-14: An-Nas (starts with ﱪ)
    
    // After merge (9 lines):
    // Line 0: Al-Ikhlas Ayah 1-2 (merged from original 0+1)
    // Line 1: Al-Ikhlas Ayah 3-4 (original 2)
    // Line 2: Al-Falaq Ayah 1-2 (merged from original 3+4)
    // Line 3: Al-Falaq Ayah 3 (original 5)
    // Line 4: Al-Falaq Ayah 4-5 (merged from original 6+7)
    // Line 5: An-Nas Ayah 1-2 (merged from original 8+9)
    // Line 6: An-Nas Ayah 3 (original 10)
    // Line 7: An-Nas Ayah 4 (merged from original 11+12)
    // Line 8: An-Nas Ayah 5-6 (merged from original 13+14)
    
    // Character ranges (first character of each Surah in the file):
    // Al-Ikhlas: starts with ﱁ (U+FC41)
    // Al-Falaq: starts with ﱎ (U+FC4E) 
    // An-Nas: starts with ﱪ (U+FCAA)
    
    final ikhlas1 = textLines[0];
    final ikhlas2 = textLines[1];
    final falaq1 = textLines[2];
    final falaq2 = textLines[3];
    final falaq3 = textLines[4];
    final nas1 = textLines[5];
    final nas2 = textLines[6];
    final nas3 = textLines[7];
    final nas4 = textLines[8];
    
    print('Line 0 (Ikhlas 1-2): ${ikhlas1.substring(0, ikhlas1.length > 20 ? 20 : ikhlas1.length)}...');
    print('Line 1 (Ikhlas 3-4): ${ikhlas2.substring(0, ikhlas2.length > 20 ? 20 : ikhlas2.length)}...');
    print('Line 2 (Falaq 1-2):  ${falaq1.substring(0, falaq1.length > 20 ? 20 : falaq1.length)}...');
    print('Line 3 (Falaq 3):    ${falaq2.substring(0, falaq2.length > 20 ? 20 : falaq2.length)}...');
    print('Line 4 (Falaq 4-5):  ${falaq3.substring(0, falaq3.length > 20 ? 20 : falaq3.length)}...');
    print('Line 5 (Nas 1-2):    ${nas1.substring(0, nas1.length > 20 ? 20 : nas1.length)}...');
    print('Line 6 (Nas 3):      ${nas2.substring(0, nas2.length > 10 ? 10 : nas2.length)}...');
    print('Line 7 (Nas 4):      ${nas3.substring(0, nas3.length > 20 ? 20 : nas3.length)}...');
    print('Line 8 (Nas 5-6):    ${nas4.substring(0, nas4.length > 20 ? 20 : nas4.length)}...');
    
    print('\n=== BOUNDARY CHECKS ===');
    
    // Check that Ikhlas lines start with Ikhlas characters
    expect(ikhlas1.startsWith('ﱁ'), true, 
      reason: 'Line 0 must start with Al-Ikhlas (ﱁ), not Al-Falaq or An-Nas');
    expect(ikhlas2.startsWith('ﱉ'), true,
      reason: 'Line 1 must start with Al-Ikhlas (ﱉ), not Al-Falaq or An-Nas');
    
    // Check that Falaq lines start with Falaq characters
    expect(falaq1.startsWith('ﱎ'), true,
      reason: 'Line 2 must start with Al-Falaq (ﱎ), not Al-Ikhlas or An-Nas');
    expect(falaq2.startsWith('ﱙ'), true,
      reason: 'Line 3 must start with Al-Falaq (ﱙ), not Al-Ikhlas or An-Nas');
    expect(falaq3.startsWith('ﱞ'), true,
      reason: 'Line 4 must start with Al-Falaq (ﱞ), not Al-Ikhlas or An-Nas');
    
    // Check that Nas lines start with Nas characters
    expect(nas1.startsWith('ﱪ'), true,
      reason: 'Line 5 must start with An-Nas (ﱪ), not Al-Ikhlas or Al-Falaq');
    expect(nas2.startsWith('ﱵ'), true,
      reason: 'Line 6 must start with An-Nas (ﱵ), not Al-Ikhlas or Al-Falaq');
    expect(nas3.startsWith('ﱸ'), true,
      reason: 'Line 7 must start with An-Nas (ﱸ), not Al-Ikhlas or Al-Falaq');
    expect(nas4.startsWith('ﲀ'), true,
      reason: 'Line 8 must start with An-Nas (ﲀ), not Al-Ikhlas or Al-Falaq');
    
    // CRITICAL: Check that Ikhlas lines do NOT contain Falaq characters
    expect(ikhlas1.contains('ﱎ'), false,
      reason: 'Al-Ikhlas line must NOT contain Al-Falaq text (ﱎ)');
    expect(ikhlas2.contains('ﱎ'), false,
      reason: 'Al-Ikhlas line must NOT contain Al-Falaq text (ﱎ)');
    
    // CRITICAL: Check that Falaq lines do NOT contain Nas characters
    expect(falaq3.contains('ﱪ'), false,
      reason: 'Al-Falaq line must NOT contain An-Nas text (ﱪ)');
    
    print('✅ No cross-Surah contamination detected');
    print('✅ Each text line contains ONLY its own Surah content\n');
  });
}
