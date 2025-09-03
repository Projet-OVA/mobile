import 'package:flutter/material.dart';

class EngagementPage extends StatefulWidget {
  const EngagementPage({super.key});

  @override
  State<EngagementPage> createState() => _EngagementPageState();
}

class _EngagementPageState extends State<EngagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E7), // fond de page
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9E7),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Sauter",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Texte centré avec l'image
            Expanded(
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
                  const SizedBox(height: 200),
                  Image.asset(
                    'assets/images/doigt.png',
                    width: 250,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            // Texte tout en bas
            const Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Text(
                "Appuyez longuement sur touche ID Sira pour s’engager",
                style: TextStyle(
                  color: Color(0xFF90979B),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
