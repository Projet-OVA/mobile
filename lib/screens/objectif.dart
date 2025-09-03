import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'engagement.dart';

class ObjectifPage extends StatefulWidget {
  const ObjectifPage({super.key});

  @override
  State<ObjectifPage> createState() => _ObjectifPageState();
}

class _ObjectifPageState extends State<ObjectifPage> {
  // Liste des objectifs
  final List<String> objectifs = [
    "Accéder à des parcours éducatifs",
    "Créer des défis personnels",
    "Participer à des challenges collectifs"
  ];

  // L'indice des éléments sélectionnés
  List<int> selectedIndices = [];

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index); // désélectionne si déjà sélectionné
      } else {
        selectedIndices.add(index); // sélectionne
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Choisis tes objectifs",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EngagementPage()),
              );
            },
            child: const Text("Sauter"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Quels sont vos objectifs citoyens? Nous vous aiderons à les atteindre !",
              style: TextStyle(fontSize: 16,
                color: Color(0xFF88868A),),
            ),
            const SizedBox(height: 20),
            // Les checklists
            ...List.generate(objectifs.length, (index) {
              bool isSelected = selectedIndices.contains(index);
              return GestureDetector(
                onTap: () => toggleSelection(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFFFC113) : Color(0xFFF7F8F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Tu peux mettre ton icon ici selon l'objectif
                      if (index == 0) Image.asset(
                        'assets/images/main.png',
                        width: 24,
                        height: 24,
                      ),
                      if (index == 1) Image.asset(
                        'assets/images/badge1.png',
                        width: 24,
                        height: 24,
                      ),
                      if (index == 2) Image.asset(
                        'assets/images/mainArbre.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(objectifs[index])),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            // Ton bouton déjà existant
            CustomButton(text: 'Suivant', onPressed: () {
              // action pour aller à la page suivante
            },)
          ],
        ),
      ),
    );
  }
}
