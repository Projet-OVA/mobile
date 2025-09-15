import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// --- Bouton fixé en bas
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: "Terminé",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- AppBar customisée
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text(
                  "Article",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),

            /// --- Titre
            const Text(
              "Introduction à la citoyenneté active",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            /// --- Auteur
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage("assets/images/cardProfile.png"),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Saliou Diop",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Educateur Citoyen",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF979797),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// --- Image principale
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/card.png",
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            /// --- Contenu de l’article
            const Text(
              """La citoyenneté active, concept qui fait référence à la participation consciente et engagée des citoyens dans les affaires publiques, est un élément crucial pour la gouvernance.

Contrairement à une citoyenneté passive où les individus se contentent de respecter les lois sans s’impliquer activement dans les processus décisionnels, la citoyenneté active exige une prise de responsabilité individuelle et collective pour influencer positivement la société.

En Afrique, ce concept revêt une importance particulière en raison des défis complexes auxquels le continent est confronté, tels que la gouvernance et la justice sociale.

Le continent africain, qui a connu de grandes civilisations, est aussi marqué par la colonisation, les luttes pour l’indépendance et les périodes de transition.""",
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF242327),
              ),
            ),
            const SizedBox(height: 80), // espace pour ne pas cacher le texte derrière le bouton
          ],
        ),
      ),
    );
  }
}
