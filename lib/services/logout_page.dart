import 'package:SIRA/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? "";

    print("=== DEBUT LOGOUT ===");
    print("Token: ${token.isEmpty ? 'VIDE' : 'PRESENT (${token.length} caractères)'}");

    try {
      print("Appel API logout...");
      final response = await ApiService.logout(token);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        print("Logout API réussi - Suppression des données locales...");

        // Vérifier ce qui est stocké avant suppression
        final keys = prefs.getKeys();
        print("Clés avant suppression: $keys");

        await prefs.clear();

        // Vérifier après suppression
        final keysAfter = prefs.getKeys();
        print("Clés après suppression: $keysAfter");

        if (mounted) {
          print("Navigation vers LoginPage...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        print("ERREUR API - Status: ${response.statusCode}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur API: ${response.statusCode} - ${response.body}"),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print("EXCEPTION CAPTURÉE: $e");
      print("Stack trace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur de connexion: $e"),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }

    print("=== FIN LOGOUT ===");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout_outlined,
        color: Colors.red,
      ),
      title: Text(
        "Déconnexion",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      onTap: () async {
        await logout();
      },
    );
  }
}