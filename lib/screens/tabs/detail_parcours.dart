import 'package:SIRA/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/tabs/card_video.dart';
import '../../widgets/tabs/quiz/question.dart';

class DetailParcours extends StatelessWidget {
  const DetailParcours({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Partie image en haut
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.35,
                  // responsive en fonction de l'écran
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/card.png"), // ton image
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Dans ton Stack au-dessus de l’image
                Positioned(
                  top: 66,
                  left: 0,
                  right: 0, // ✅ pour occuper toute la largeur
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ✅ espace égal entre les éléments
                      children: [
                        // Flèche retour
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors
                              .white),
                        ),

                        // Texte Sauter
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Sauter",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // Icône Favoris
                        IconButton(
                          onPressed: () {
                            // TODO: action favoris
                          },
                          icon: const Icon(Icons.bookmark_border, color: Colors
                              .white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Partie contenu défilable
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Introduction à la citoyenneté active",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Auteur
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage('assets/images/cardProfile.png'),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Saliou Diop",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.black)),
                              Text("Éducateur Citoyen",
                                  style: TextStyle(color: Color(0x8888868A),
                                      fontSize: 9.55)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        "L'engagement des jeunes dans les projetsLa citoyenneté active, concept qui fait référence à la participation consciente et engagée des citoyens dans les affaires publiques",
                        style: TextStyle(color: Color(0xAAABAAAC),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Liste des modules
                      CardVideo(
                        title: "Initiatives écoresponsables au sein des communautés",
                        description: "Comment les jeunes mènent des actions pour un avenir durable...",
                        duration: "05",
                        thumbnail: "assets/images/enfants.png",
                        //videoUrl: "assets/videos/videoDemo.mp4", // peut être remplacé par une URL réseau
                      ),
                      CardVideo(
                        title: "Initiatives écoresponsables au sein des communautés",
                        description: "Comment les jeunes mènent des actions pour un avenir durable...",
                        duration: "05",
                        thumbnail: "assets/images/enfants.png",
                        //videoUrl: "assets/videos/videoDemo.mp4", // peut être remplacé par une URL réseau
                      ),
                      CardVideo(
                        title: "Initiatives écoresponsables au sein des communautés",
                        description: "Comment les jeunes mènent des actions pour un avenir durable...",
                        duration: "05",
                        thumbnail: "assets/images/enfants.png",
                       // videoUrl: "assets/videos/videoDemo.mp4", // peut être remplacé par une URL réseau
                      ),

                      const SizedBox(height: 24),

                      // Ton bouton custom
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Passez le Quizz",
                          onPressed: () async  {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Question()),
              );
            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}