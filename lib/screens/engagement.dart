import 'package:flutter/material.dart';
import 'login_page.dart';

class EngagementPage extends StatefulWidget {
  const EngagementPage({super.key});

  @override
  State<EngagementPage> createState() => _EngagementPageState();
}

class _EngagementPageState extends State<EngagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9E7),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centre verticalement
          children: [
            const Text(
              "J’utiliserai SIRA pour",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "apprendre mes droits, agir et être reconnu comme acteur du changement.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF88868A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24), // espace avant l'image
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(), // page cible
                  ),
                );
              },
              child: Image.asset(
                'assets/images/doigt.png',
                width: 250,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12), // espace petit entre image et texte
            const Text(
              "Appuyez longuement sur touche ID Sira pour s’engager",
              style: TextStyle(
                color: Color(0xFF90979B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
