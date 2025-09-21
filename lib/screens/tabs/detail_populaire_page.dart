import 'package:SIRA/widgets/card_profiles.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DetailPopulairePage extends StatelessWidget {
  const DetailPopulairePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack pour l'image et les boutons
            SizedBox(
              height: 350,
              child: Stack(
                children: [
                  // Image
                  Image.asset(
                    "assets/images/cardReboisement.png",
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.fill,
                  ),

                  // Boutons retour & favoris avec SafeArea
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF322F35)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border_outlined, color: Color(0xFF322F35)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal avec superposition
            Transform.translate(
              offset: const Offset(0, -15), // Superposition de 30px
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(34),
                    topRight: Radius.circular(34),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10), // Espace supplémentaire en haut

                    // Titre
                    const Text(
                      "Journée de reboisement sur la VDN",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF322F35)
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Participants
                    CardProfiles(
                      profileImages: [
                        'assets/images/profile4.png',
                        'assets/images/profile3.png',
                        'assets/images/profile2.png',
                        'assets/images/profile1.png',
                        'assets/images/profile4.png'
                      ],
                      totalParticipants: 900,
                    ),
                    const SizedBox(height: 16),

                    // Infos - Version responsive
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF9E7), // 👈 couleur du background
                        borderRadius: BorderRadius.circular(8), // arrondi facultatif
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: const [
                                Icon(Icons.calendar_today, color: Color(0xFFFFC113)),
                                SizedBox(height: 5),
                                Text(
                                  "30 août 2025",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  color: Color(0xFF555257)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Color(0xFFFFECB6),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                Icon(Icons.place, color: Color(0xFFFFC113)),
                                SizedBox(height: 5),
                                Text(
                                  "VDN, Échangeur OMVS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF555257)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Color(0xFFFFECB6),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                Icon(Icons.access_time, color: Color(0xFFFFC113)),
                                SizedBox(height: 5),
                                Text(
                                  "09h00",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF555257)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Container(
                      height: 1,
                      color: Color(0xFFF5F5F5),
                    ),
                    const SizedBox(height: 24),
                    // Organisateur
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/images/cardProfile.png"),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saliou Diop",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  color: Color(0xFF322F35)
                                ),
                              ),
                              Text(
                                  "Éducateur Citoyen",
                                  style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF88868A)
                              ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F8F7), // 👈 couleur du background
                            borderRadius: BorderRadius.circular(30), // arrondi facultatif
                          ),
                          child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.messenger_sharp, color: Color(0xFF322F35)),
                        ),),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F8F7), // 👈 couleur du background
                            borderRadius: BorderRadius.circular(30), // arrondi facultatif
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.phone, color: Color(0xFF322F35)),
                          ),),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      "L'engagement des jeunes dans les projets à citoyenneté active, "
                          "concept qui fait référence à la participation constante et "
                          "engagée des citoyens dans les affaires publiques.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: (14),
                        color: Color(0XFFABAAAC)
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bouton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icône favoris à gauche
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF9E7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // action favoris
                            },
                            icon: const Icon(Icons.bookmark_border_outlined, color: Color(0xFF322F35)),
                          ),
                        ),
                        // Bouton "Participer" à droite
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              text: "Participer",
                              onPressed: () async {
                                // Action asynchrone
                                await Future.delayed(const Duration(seconds: 2));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Espace supplémentaire pour le scroll
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}