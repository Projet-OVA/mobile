import 'package:flutter/material.dart';
import 'presentation.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9E7), // couleur de fond beige
      body: Stack(
        children: [
          // Ellipse en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                // Navigation vers Presentation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Presentation()),
                );
              },
              child: Image.asset(
                'assets/images/ellipse.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 275, // ajuste selon la taille de ton ellipse
              ),
            ),
          ),
          // Texte centré
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline, // <- important
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "#",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "1",
                    style: TextStyle(
                      fontSize: 90, // plus gros
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false, // réduit l’espace au-dessus et au-dessous
                      applyHeightToLastDescent: false,
                    ),
                  ),
                  Text(
                    " application",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "d’éducation citoyenne\nau Sénégal",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
    ]
      ),
    );
  }
}
