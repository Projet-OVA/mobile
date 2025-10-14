import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:SIRA/services/auth_storage.dart';

class HttpInterceptor {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ✅ Flag pour éviter les redirections multiples
  static bool _isRedirecting = false;

  /// Wrapper pour http.get avec gestion automatique du 401
  static Future<http.Response> get(
      Uri url, {
        Map<String, String>? headers,
      }) async {
    try {
      final response = await http.get(url, headers: headers);
      await _handleResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Wrapper pour http.post avec gestion automatique du 401
  static Future<http.Response> post(
      Uri url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    try {
      final response = await http.post(url, headers: headers, body: body);
      await _handleResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Wrapper pour http.delete avec gestion automatique du 401
  static Future<http.Response> delete(
      Uri url, {
        Map<String, String>? headers,
      }) async {
    try {
      final response = await http.delete(url, headers: headers);
      await _handleResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Wrapper pour http.put avec gestion automatique du 401
  static Future<http.Response> put(
      Uri url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    try {
      final response = await http.put(url, headers: headers, body: body);
      await _handleResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Vérifie le code de réponse et gère le 401
  static Future<void> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      print('⚠️ Erreur 401 détectée - Token invalide ou expiré');
      await _handleUnauthorized();

      // ✅ Lance une exception pour arrêter l'exécution
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    }
  }

  /// Gère la déconnexion et la redirection
  static Future<void> _handleUnauthorized() async {
    // ✅ Éviter les redirections multiples simultanées
    if (_isRedirecting) {
      print('⏸️ Redirection déjà en cours, skip...');
      return;
    }

    _isRedirecting = true;

    try {
      print('🧹 Nettoyage des données d\'authentification...');

      // Nettoyer toutes les données d'authentification
      await AuthStorage.clearAll();

      // Rediriger vers la page de login
      final context = navigatorKey.currentContext;

      if (context != null && context.mounted) {
        print('🔄 Redirection vers /login');

        // Supprimer toutes les routes et aller à login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
              (route) => false,
        );

        // Afficher un message à l'utilisateur
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Session expirée. Veuillez vous reconnecter.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 4),
              ),
            );
          }
        });
      } else {
        print('❌ Context non disponible pour la redirection');
      }
    } finally {
      // Réinitialiser le flag après un délai
      Future.delayed(const Duration(seconds: 2), () {
        _isRedirecting = false;
      });
    }
  }

  /// ✅ Méthode utilitaire pour vérifier si une réponse est une erreur d'authentification
  static bool isAuthError(http.Response response) {
    return response.statusCode == 401 || response.statusCode == 403;
  }

  /// ✅ Méthode pour forcer une déconnexion manuelle
  static Future<void> forceLogout({String? message}) async {
    await AuthStorage.clearAll();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
            (route) => false,
      );

      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}