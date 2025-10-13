import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _tokenKey = 'accessToken';
  static const String _lastPathKey = 'lastPath';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _selectedTabKey = 'selectedTab';

  /// Sauvegarde le token après connexion
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Récupère le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Supprime le token (pour le logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Sauvegarde le dernier parcours visité
  static Future<void> saveLastPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPathKey, path);
  }

  /// Récupère le dernier parcours visité
  static Future<String?> getLastPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPathKey);
  }

  /// Supprime le dernier parcours (par exemple au logout)
  static Future<void> clearLastPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastPathKey);
  }

  /// Sauvegarde le statut de connexion
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  /// Récupère le statut de connexion
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Sauvegarde l'index du tab principal (bottom navigation)
  static Future<void> saveSelectedTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedTabKey, index);
  }

  /// Récupère l'index du tab principal
  static Future<int?> getSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedTabKey);
  }

  // ✅ SOLUTION GÉNÉRIQUE POUR TOUS LES TABS INTERNES

  /// Sauvegarde l'index d'un tab interne pour n'importe quelle page
  /// Exemple: savePageTab('profile', 2) pour sauvegarder l'onglet 2 de ProfilePage
  static Future<void> savePageTab(String pageName, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${pageName}_tab', index);
  }

  /// Récupère l'index d'un tab interne pour n'importe quelle page
  /// Exemple: getPageTab('profile') pour récupérer l'onglet de ProfilePage
  static Future<int?> getPageTab(String pageName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${pageName}_tab');
  }

  /// Supprime l'index d'un tab interne pour une page spécifique
  static Future<void> clearPageTab(String pageName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${pageName}_tab');
  }

  /// Supprime toutes les données d'authentification (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    // Supprimer les clés principales
    await prefs.remove(_tokenKey);
    await prefs.remove(_lastPathKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_selectedTabKey);

    // Supprimer tous les tabs de pages (pattern matching)
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.endsWith('_tab')) {
        await prefs.remove(key);
      }
    }
  }
}