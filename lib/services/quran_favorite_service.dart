import 'package:shared_preferences/shared_preferences.dart';

class QuranFavoriteService {
  static final QuranFavoriteService _instance = QuranFavoriteService._internal();
  factory QuranFavoriteService() => _instance;
  QuranFavoriteService._internal();

  static const String _key = 'favorite_surah_ids';

  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? [];
    return list.map((e) => int.parse(e)).toList();
  }

  Future<bool> isFavorite(int surahId) async {
    final favorites = await getFavorites();
    return favorites.contains(surahId);
  }

  Future<void> toggleFavorite(int surahId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? [];
    final String idStr = surahId.toString();

    if (list.contains(idStr)) {
      list.remove(idStr);
    } else {
      list.add(idStr);
    }

    await prefs.setStringList(_key, list);
  }
}
