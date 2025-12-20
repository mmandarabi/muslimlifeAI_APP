import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _themeKey = 'is_light_mode';
  bool _isLightMode = false;

  bool get isLightMode => _isLightMode;
  ThemeMode get themeMode => _isLightMode ? ThemeMode.light : ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLightMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isLightMode = !_isLightMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isLightMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isLight) async {
    if (_isLightMode == isLight) return;
    _isLightMode = isLight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isLightMode);
    notifyListeners();
  }
}
