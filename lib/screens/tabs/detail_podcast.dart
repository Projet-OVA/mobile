import 'package:flutter/material.dart';

class DetailPodcast extends StatefulWidget {
  const DetailPodcast({super.key});

  @override
  State<DetailPodcast> createState() => _DetailPodcastState();
}

class _DetailPodcastState extends State<DetailPodcast> {
  double progress = 0.35; // exemple de progression
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF585858),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {Navigator.pop(context);},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/livebetter.png',
                height: 450,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 24),
            // Titre et auteur
            Text(
              'Portraits de jeunes qui changent leur quartier',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF242327), // couleur ici
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Saliou Diop',
              style: TextStyle(fontSize: 12, color: Color(0xFF979797)),
            ),
            const SizedBox(height: 24),
            // Barre de progression
            Slider(
              value: progress,
              onChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
              min: 0,
              max: 100,
              activeColor: Color(0xFFE6AE11),    // couleur de la partie remplie
              inactiveColor: Color(0xFFF2EFED),  // couleur de la partie vide
              thumbColor: Color(0xFFE6AE11),      // couleur du "curseur"
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('35:17',
                  style: TextStyle(fontSize: 12, color: Color(0xFF979797)),),
                Text('1:05:00',
                  style: TextStyle(fontSize: 12, color: Color(0xFF979797)),),
              ],
            ),
            const SizedBox(height: 24),
            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('1x'),
                ),
                IconButton(
                  icon: const Icon(Icons.replay_5),
                  iconSize: 36,
                  onPressed: () {},
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  backgroundColor: Color(0xFF242327),      // couleur du bouton (optionnel)
                  foregroundColor: Colors.white,      // couleur de l'icône
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right_outlined ),
                  iconSize: 36,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
