import 'package:flutter/material.dart';
import '../../widgets/tabs/article_card.dart'; // Assurez-vous que c'est le bon fichier

void main() {
  runApp(const Article());
}

class Article extends StatelessWidget {
  const Article({super.key});

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
          ArticleCard(
            avatarUrl: 'assets/images/cardProfile.png',
            author: "Saliou Diop",
            role: "Educateur Citoyen",
            title: "Rôle de l'Éducation Populaire et la Citoyenneté",
            description: "La citoyenneté active, concept qui fait...",
            date: "6 Sep",
            duration: "30 min",
            imageUrl: "assets/images/card.png",
          ),
          SizedBox(height: 16),
          ArticleCard(
            avatarUrl: 'assets/images/cardProfile.png',
            author: "Saliou Diop",
            role: "Educateur Citoyen",
            title: "Rôle de l'Éducation Populaire et la Citoyenneté",
            description: "La citoyenneté active, concept qui fait...",
            date: "6 Sep",
            duration: "30 min",
            imageUrl: "assets/images/card.png",
          ),
          SizedBox(height: 16),
          ArticleCard(
            avatarUrl: 'assets/images/cardProfile.png',
            author: "Saliou Diop",
            role: "Educateur Citoyen",
            title: "Rôle de l'Éducation Populaire et la Citoyenneté",
            description: "La citoyenneté active, concept qui fait...",
            date: "6 Sep",
            duration: "30 min",
            imageUrl: "assets/images/card.png",
          ),
          SizedBox(height: 16),
          ArticleCard(
            avatarUrl: 'assets/images/cardProfile.png',
            author: "Saliou Diop",
            role: "Educateur Citoyen",
            title: "Rôle de l'Éducation Populaire et la Citoyenneté",
            description: "La citoyenneté active, concept qui fait...",
            date: "6 Sep",
            duration: "30 min",
            imageUrl: "assets/images/card.png",
          ),
          SizedBox(height: 16),
          ArticleCard(
            avatarUrl: 'assets/images/cardProfile.png',
            author: "Saliou Diop",
            role: "Educateur Citoyen",
            title: "Rôle de l'Éducation Populaire et la Citoyenneté",
            description: "La citoyenneté active, concept qui fait...",
            date: "6 Sep",
            duration: "30 min",
            imageUrl: 'assets/images/card.png',
          ),
        ],
      ),
    );
  }
}
