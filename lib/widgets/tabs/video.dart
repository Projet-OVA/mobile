import 'package:flutter/material.dart';
import 'video_card.dart'; // Assurez-vous que c'est le bon fichier

void main() {
  runApp(const Video());
}

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CenteredTextPage(),
    );
  }
}

class CenteredTextPage extends StatelessWidget {
  const CenteredTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          VideoCard(
            thumbnailUrl: 'assets/images/enfants.png',
            title: 'Rôle de l\'Éducation Populaire et la Citoyenneté',
            subtitle: 'Saliou Diop',
            profession: 'Educateur Citoyen',
            avatarUrl: 'assets/images/cardProfile.png',
            //videoUrl: 'assets/images/profiledetail.png',
          ),
          SizedBox(height: 16),
          VideoCard(
            thumbnailUrl: 'assets/images/card.png',
            title: 'Rôle de l\'Éducation Populaire et la Citoyenneté',
            subtitle: 'Saliou Diop',
            profession: 'Educateur Citoyen',
            avatarUrl: 'assets/images/cardProfile.png',
            //videoUrl: 'assets/images/profiledetail.png',
          ),
          SizedBox(height: 16),
          VideoCard(
            thumbnailUrl: 'assets/images/enfants.png',
            title: 'Rôle de l\'Éducation Populaire et la Citoyenneté',
            subtitle: 'Saliou Diop',
            profession: 'Educateur Citoyen',
            avatarUrl: 'assets/images/cardProfile.png',
            //videoUrl: 'assets/images/profiledetail.png',
          ),
        ],
      ),
    );
  }
}
