import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/models/surah_header_ligature.dart';

void main() {
  group('getSurahLigatureCode', () {
    test('returns correct ligature for Surah 1 (Al-Fatiha)', () {
      expect(getSurahLigatureCode(1), 'surah001');
    });

    test('returns correct ligature for Surah 109 (Al-Kafirun)', () {
      expect(getSurahLigatureCode(109), 'surah109');
    });

    test('returns correct ligature for Surah 114 (An-Nas)', () {
      expect(getSurahLigatureCode(114), 'surah114');
    });

    test('returns correct ligature for Surah 78 (An-Naba)', () {
      expect(getSurahLigatureCode(78), 'surah078');
    });

    test('pads single digit numbers correctly', () {
      expect(getSurahLigatureCode(5), 'surah005');
    });

    test('pads double digit numbers correctly', () {
      expect(getSurahLigatureCode(50), 'surah050');
    });

    test('throws ArgumentError for Surah ID 0', () {
      expect(() => getSurahLigatureCode(0), throwsArgumentError);
    });

    test('throws ArgumentError for Surah ID 115', () {
      expect(() => getSurahLigatureCode(115), throwsArgumentError);
    });

    test('throws ArgumentError for negative Surah ID', () {
      expect(() => getSurahLigatureCode(-1), throwsArgumentError);
    });
  });

  group('isValidSurahId', () {
    test('returns true for valid Surah ID 1', () {
      expect(isValidSurahId(1), true);
    });

    test('returns true for valid Surah ID 114', () {
      expect(isValidSurahId(114), true);
    });

    test('returns false for Surah ID 0', () {
      expect(isValidSurahId(0), false);
    });

    test('returns false for Surah ID 115', () {
      expect(isValidSurahId(115), false);
    });

    test('returns false for negative Surah ID', () {
      expect(isValidSurahId(-10), false);
    });
  });

  group('All Surahs (1-114)', () {
    test('generates correct ligature codes for all 114 Surahs', () {
      for (int i = 1; i <= 114; i++) {
        final paddedNumber = i.toString().padLeft(3, '0');
        final expected = 'surah$paddedNumber';
        expect(getSurahLigatureCode(i), expected,
            reason: 'Failed for Surah $i');
      }
    });
  });
}
