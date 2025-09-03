import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import 'objectif.dart';

class Presentation extends StatelessWidget {
  const Presentation({super.key});

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
                      MaterialPageRoute(builder: (context) => ObjectifPage()),
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

              // Input
              CustomInput(),
              const Spacer(),

              // Bouton Suivant
              CustomButton(
                text: 'Suivant',
                onPressed: () {
                  // action pour aller à la page suivante
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
