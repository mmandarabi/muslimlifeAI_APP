import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock SharedPreferences FIRST
    SharedPreferences.setMockInitialValues({
      'adhan_notification_enabled': true,
      'adhan_sound_enabled': true,
      'adhan_reminder_enabled': true,
      'adhan_short_mode_enabled': false,
      'selected_voice_key': 'makkah',
      'selected_quran_reciter_key': 'sudais',
      'voice_explicitly_set': false,
    });

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC')); 
    
    // Set platform to Android so AndroidAlarmManager.initialize() is called
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    // Mock Notifications
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('dexterous.com/flutter/local_notifications'), (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'initialize') return true;
      if (methodCall.method == 'zonedSchedule') return null;
      if (methodCall.method == 'resolvePlatformSpecificImplementation') return true;
      return null;
    });

    // Mock Alarm Manager - NEW Channel (v3+)
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('dev.fluttercommunity.plus/android_alarm_manager_plus'), (MethodCall methodCall) async {
      log.add(methodCall);
      return true;
    });
    
    // Mock Alarm Manager - LEGACY/ALT Channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('dev.fluttercommunity.plus/android_alarm_manager'), (MethodCall methodCall) async {
      log.add(methodCall);
      return true;
    });

    // Mock Timezone
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_timezone'), (MethodCall methodCall) async {
      return 'UTC';
    });

    // Mock AudioSession
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('com.ryanheise.audio_session'), (MethodCall methodCall) async {
      return null;
    });
  });

  tearDownAll(() {
    debugDefaultTargetPlatformOverride = null;
  });

  setUp(() {
    log.clear();
  });

  test('scheduleAdhanNotifications triggers both FLN and AlarmManager', () async {
    final service = UnifiedAudioService();
    try {
      await service.init();
    } catch (e, stack) {
      print("❌ UnifiedAudioService.init failed: $e");
      print(stack);
      // Fail the test immediately if init fails
      fail("UnifiedAudioService.init failed: $e");
    }

    final prayerTimes = {
      'Fajr': DateTime.now().add(const Duration(hours: 1)),
    };

    await service.scheduleAdhanNotifications(prayerTimes);

    // Verify FLN zonedSchedule was called
    final hasZonedSchedule = log.any((m) => m.method == 'zonedSchedule');
    expect(hasZonedSchedule, isTrue, reason: "FLN zonedSchedule should be called");

    // Verify AlarmManager oneShotAt was called
    // In android_alarm_manager_plus, the underlying method might be 'Alarm.oneShotAt'
    final hasAlarmManager = log.any((m) => m.method == 'Alarm.oneShotAt');
    expect(hasAlarmManager, isTrue, reason: "AndroidAlarmManager oneShotAt should be called");

    // Verify strings in zonedSchedule
    final zonedCall = log.firstWhere((m) => m.method == 'zonedSchedule');
    expect(zonedCall.arguments['title'], contains('Fajr Prayer'));
    expect(zonedCall.arguments['body'], contains("Hayya 'ala-s-Salah"));

    print("✅ Adhan Scheduling Test Passed: Notifications and Alarms correctly logged.");
  });
}
