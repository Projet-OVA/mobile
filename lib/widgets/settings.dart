import 'package:SIRA/services/logout_page.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Paramètre"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Profile
          _buildSettingItem(
            leading: Icon(Icons.person_outline),
            title: "Profile",
            onTap: () {
              // Naviguer vers l'écran Profile
            },
          ),
          const SizedBox(height: 30),
          // Langue
          _buildSettingItem(
            leading: Image.asset(
              'assets/images/langue.png', // ton image
              width: 24,
              height: 24,
            ),
            title: "Langue",
            onTap: () {
              // Naviguer vers l'écran Langue
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            // padding horizontal
            child: Divider(
              color: Color(0xFFEBEAEB), // ta couleur personnalisée
              thickness: 1, // épaisseur du Divider
              height: 20, // hauteur verticale (espace autour)
            ),
          ),
          const SizedBox(height: 20),
          // Confidentialité et Sécurité
          _buildSettingItem(
            leading: Icon(Icons.shield_moon_outlined),
            title: "Confidentialité et Sécurité",
            onTap: () {},
          ),
          const SizedBox(height: 30),
          // Aide et Support
          _buildSettingItem(
            leading: Icon(Icons.headset_mic_outlined),
            title: "Aide et Support",
            onTap: () {},
          ),
          const SizedBox(height: 30),
          // Notification avec Switch
          _buildSettingItem(
            leading: Icon(Icons.notifications_outlined),
            title: "Notification",
            trailing: Switch(
              value: notificationsEnabled,
              activeColor: Color(0xFF53D258), // couleur quand true
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val; // met à jour l'état
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Déconnexion
          LogoutPage(),
        ],
      ),
    );
  }
  Widget _buildSettingItem({
    Widget? leading,
    required String title,
    Widget? trailing,
    Color titleColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // pour que tout l'espace cliquable soit pris en compte
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if (leading != null) leading,
            if (leading != null) const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: titleColor, fontSize: 16),
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
