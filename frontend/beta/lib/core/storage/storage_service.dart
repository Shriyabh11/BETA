import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Onboarding
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool('onboarding_completed', completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  // User Data
  Future<void> saveUserData(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      if (entry.value is String) {
        await _prefs.setString(entry.key, entry.value as String);
      } else if (entry.value is bool) {
        await _prefs.setBool(entry.key, entry.value as bool);
      } else if (entry.value is int) {
        await _prefs.setInt(entry.key, entry.value as int);
      }
    }
  }

  // Clear data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
