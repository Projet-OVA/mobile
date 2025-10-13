import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/register_storage.dart';
import 'objectif.dart';
import 'package:SIRA/services/auth_storage.dart';

class Presentation extends StatefulWidget {
  const Presentation({super.key});

  @override
  State<Presentation> createState() => _PresentationState();
}
class _PresentationState extends State<Presentation> {
  @override
  void initState() {
    super.initState();
    AuthStorage.saveLastPath('/presentation');
  }
  // Déclaration du controller
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar avec "Sauter"
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ObjectifPage()),
                    );
                  },
                  child: const Text(
                    'Sauter',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Texte d'introduction
              const Text(
                'Faisons connaissances',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Comment aimeriez-vous que\nSIRA vous appelle ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ✅ Input avec controller
              CustomInput(controller: usernameController),

              const Spacer(),

              // Bouton Suivant
              CustomButton(
                text: 'Suivant',
                onPressed: () async { // ✅ async ajouté
                  final username = usernameController.text.trim();
                  if (username.isNotEmpty) {
                    await RegisterStorage.setUsername(username); // ✅ sauvegarde
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ObjectifPage()),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
