import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAdapter {
  final _preferences = SharedPreferences.getInstance();

  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await _preferences;

    try {
      return prefs.getInt(key);
    } catch (e) {
      return null;
    }
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferences prefs = await _preferences;

    try {
      return prefs.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _preferences;

    try {
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.setDouble(key, value);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.setString(key, value);
  }

  Future<List<String>> getKeys() async {
    final SharedPreferences prefs = await _preferences;
    return prefs.getKeys().toList();
  }

  Future<bool> removeKey(String key) async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.remove(key);
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.clear();
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await _preferences;

    try {
      return prefs.getBool(key);
    } catch (e) {
      return null;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences prefs = await _preferences;
    return await prefs.setBool(key, value);
  }
}
