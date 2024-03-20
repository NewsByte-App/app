import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  // call this method from initState() function of the main app.
  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  static String getString(String key, [String? defValue]) {
    // Ensure _prefsInstance is checked for null and provide a default value.
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static Future<bool> remove(String key) async {
    var prefs = _prefsInstance ?? await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  // Clears all keys from SharedPreferences
  static Future<bool> clear() async {
    var prefs = _prefsInstance ?? await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> setString(String key, String value) async {
    // Ensure _prefsInstance is checked for null.
    // This pattern ensures that the method can still execute even before init() completes.
    // It's useful for late initialization scenarios but requires careful handling to avoid null issues.
    var prefs = _prefsInstance ?? await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
