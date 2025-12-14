import 'package:ateliya/tools/constants/cache_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Cache {
  static Future<SharedPreferences> _getPrefs() =>
      SharedPreferences.getInstance();

  static Future<bool> setString(String key, String value) async {
    try {
      var pref = await _getPrefs();
      return pref.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getString(String key) async {
    try {
      var pref = await _getPrefs();
      return pref.getString(key);
    } catch (e) {
      return null;
    }
  }

  static Future<List<bool>> removeMany(List<String> keys) async {
    try {
      var pref = await _getPrefs();
      List<bool> res = [];
      for (var key in keys) {
        final resDelete = await pref.remove(key);
        res.add(resDelete);
      }
      return res;
    } catch (e) {
      // Handle error
      return keys.map((e) => false).toList();
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      var pref = await _getPrefs();
      return pref.setBool(key, value);
    } catch (e) {
      // Handle error
      return false;
    }
  }

  static Future<bool?> getBool(String key) async {
    try {
      var pref = await _getPrefs();
      return pref.getBool(key);
    } catch (e) {
      // Handle error
      return null;
    }
  }

  static Future<bool> setDateTime(String key, DateTime? value) async {
    try {
      var pref = await _getPrefs();
      if (value == null) {
        return pref.remove(key);
      }
      return pref.setString(key, value.toIso8601String());
    } catch (e) {
      // Handle error
      return false;
    }
  }

  static Future<DateTime?> getDateTime(String key) async {
    try {
      var pref = await _getPrefs();
      var dateString = pref.getString(key);
      if (dateString == null) return null;
      return DateTime.tryParse(dateString);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      var pref = await _getPrefs();
      return pref.remove(key);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clear() async {
    try {
      var pref = await _getPrefs();
      for (var e in CacheKey.values.where((e) => e.deletable)) {
        pref.remove(e.name);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
