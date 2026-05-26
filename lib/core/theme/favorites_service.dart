import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _regionKeyPrefix = 'fav_region_';
  static const String _titlesKeyPrefix = 'fav_service_titles_';

  static String _keySuffix(String userKey) {
    final normalized = userKey.trim().isEmpty ? 'guest' : userKey.trim();
    return normalized;
  }

  static Future<void> saveForUser({
    required String userKey,
    required String region,
    required List<String> titles,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final suffix = _keySuffix(userKey);
    await prefs.setString('$_regionKeyPrefix$suffix', region);
    await prefs.setString('$_titlesKeyPrefix$suffix', jsonEncode(titles));
  }

  static Future<({String region, List<String> titles})?> loadForUser({required String userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final suffix = _keySuffix(userKey);
    final region = prefs.getString('$_regionKeyPrefix$suffix');
    final titlesRaw = prefs.getString('$_titlesKeyPrefix$suffix');
    if (region == null || titlesRaw == null) return null;
    try {
      final decoded = jsonDecode(titlesRaw);
      if (decoded is! List) return null;
      final titles = decoded.map((e) => '$e').toList();
      return (region: region, titles: titles);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearForUser({required String userKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final suffix = _keySuffix(userKey);
    await prefs.remove('$_regionKeyPrefix$suffix');
    await prefs.remove('$_titlesKeyPrefix$suffix');
  }
}
