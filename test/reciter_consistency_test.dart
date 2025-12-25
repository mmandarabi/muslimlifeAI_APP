
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Reciter Selection Consistency', () {
    late UnifiedAudioService audioService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      audioService = UnifiedAudioService();
      // Reset internal state if needed (though it's a singleton, simple setters help)
      await audioService.setQuranReciter('sudais'); 
    });

    test('Default reciter should be Sudais', () {
      expect(audioService.currentQuranReciter, 'sudais');
    });

    test('Setting reciter to Saad updates state and preferences', () async {
      await audioService.setQuranReciter('saad');

      // Verify in-memory state
      expect(audioService.currentQuranReciter, 'saad');

      // Verify persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_quran_reciter_key'), 'saad');
    });

    test('Setting reciter to Mishary updates state and preferences', () async {
      await audioService.setQuranReciter('mishary');

      expect(audioService.currentQuranReciter, 'mishary');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_quran_reciter_key'), 'mishary');
    });

    test('Switching back and forth maintains consistency', () async {
      await audioService.setQuranReciter('saad');
      expect(audioService.currentQuranReciter, 'saad');

      await audioService.setQuranReciter('sudais');
      expect(audioService.currentQuranReciter, 'sudais');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_quran_reciter_key'), 'sudais');
    });
  });
}
