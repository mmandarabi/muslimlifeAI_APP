import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerLogService extends ChangeNotifier {
  static final PrayerLogService _instance = PrayerLogService._internal();
  factory PrayerLogService() => _instance;
  PrayerLogService._internal();

  static const String _storageKey = 'muslim_life_prayer_logs';
  late SharedPreferences _prefs;

  // Cache: Map<DateString, Map<PrayerName, IsDone>>
  // DateString format: YYYY-MM-DD
  Map<String, Map<String, bool>> _logs = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLogs();
  }

  void _loadLogs() {
    final String? encoded = _prefs.getString(_storageKey);
    if (encoded != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(encoded);
        _logs = decoded.map((key, value) {
          return MapEntry(key, Map<String, bool>.from(value));
        });
      } catch (e) {
        debugPrint('PrayerLogService: Error decoding logs: $e');
        _logs = {};
      }
    }
  }

  Future<void> _saveLogs() async {
    await _prefs.setString(_storageKey, json.encode(_logs));
    notifyListeners();
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool isPrayed(DateTime date, String prayerName) {
    final key = _getDateKey(date);
    return _logs[key]?[prayerName] ?? false;
  }

  Future<void> togglePrayer(DateTime date, String prayerName) async {
    final key = _getDateKey(date);
    if (!_logs.containsKey(key)) {
      _logs[key] = {};
    }
    
    final currentValue = _logs[key]![prayerName] ?? false;
    _logs[key]![prayerName] = !currentValue;
    
    await _saveLogs();
  }

  int getDailyCompletionCount(DateTime date) {
    final key = _getDateKey(date);
    final dayLogs = _logs[key];
    if (dayLogs == null) return 0;
    
    // Valid prayers to count (ignoring Sunrise which is usually not a 'prayer' to mark done in most apps)
    const validPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    return dayLogs.entries
        .where((e) => validPrayers.contains(e.key) && e.value)
        .length;
  }

  int getStreak() {
    int streak = 0;
    DateTime date = DateTime.now();
    
    // Check back from today
    while (true) {
      final key = _getDateKey(date);
      final dayLogs = _logs[key];
      
      // If none prayed today yet, check yesterday to keep streak alive if today just started
      if (dayLogs == null || dayLogs.values.every((v) => !v)) {
        if (streak == 0 && date.hour < 24) { // Allow starting today
             // Check yesterday
             date = date.subtract(const Duration(days: 1));
             continue;
        }
        break;
      }
      
      // If at least one prayer done, streak continues
      if (dayLogs.values.any((v) => v)) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
      
      // Safety break
      if (streak > 365) break;
    }
    
    return streak;
  }

  /// Returns maps of logs for the last [days] days
  List<double> getLastSevenDaysProgress() {
    final List<double> progress = [];
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final count = getDailyCompletionCount(date);
      progress.add(count / 5.0); // Factor of 0.0 to 1.0
    }
    
    return progress;
  }
}
