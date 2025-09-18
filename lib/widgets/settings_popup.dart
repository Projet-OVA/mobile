import 'package:SIRA/services/logout_page.dart';
import 'package:flutter/material.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Paramètres"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton Déconnexion
          const LogoutPage(),
          const Divider(),
          // Choix de la langue
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: const Text("Langue"),
            trailing: DropdownButton<String>(
              value: "fr",
              items: const [
                DropdownMenuItem(value: "fr", child: Text("Français")),
                DropdownMenuItem(value: "en", child: Text("English")),
              ],
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Langue changée en $value")),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Fermer"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}