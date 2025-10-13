import 'package:SIRA/screens/login_page.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart'; // ✅ Import AuthStorage

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Future<void> logout() async {
    print("=== DEBUT LOGOUT ===");

    try {
      // ✅ Récupérer le token via AuthStorage
      final token = await AuthStorage.getToken() ?? "";
      print("Token: ${token.isEmpty ? 'VIDE' : 'PRESENT (${token.length} caractères)'}");

      print("Appel API logout...");
      final response = await ApiService.logout(token);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Logout API réussi - Suppression des données locales...");

        // ✅ Utiliser AuthStorage.clearAll() pour tout nettoyer
        await AuthStorage.clearAll();
        print("✅ Toutes les données ont été supprimées (token, lastPath, selectedTab, pageTabs...)");

        if (mounted) {
          print("Navigation vers LoginPage...");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // ✅ Supprimer toute la pile de navigation
          );
        }
      } else {
        print("ERREUR API - Status: ${response.statusCode}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur API: ${response.statusCode} - ${response.body}"),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
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
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    print("=== FIN LOGOUT ===");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.logout_outlined,
        color: Colors.red,
      ),
      title: const Text(
        "Déconnexion",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      onTap: () async {
        // ✅ Optionnel : Afficher une confirmation avant de se déconnecter
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Déconnexion"),
            content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Déconnecter"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await logout();
        }
      },
    );
  }
}