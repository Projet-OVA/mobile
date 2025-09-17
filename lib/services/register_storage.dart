import 'package:shared_preferences/shared_preferences.dart';

class RegisterStorage {
  static const _keyUsername = 'register_username';

  /// Sauvegarder le username
  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  /// Récupérer le username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Réinitialiser après inscription
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
}
