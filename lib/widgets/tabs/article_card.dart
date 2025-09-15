import 'package:flutter/material.dart';
import '../../screens/tabs/article_detail_page.dart';

class ArticleCard extends StatelessWidget {
  final String avatarUrl;
  final String author;
  final String role;
  final String title;
  final String description;
  final String date;
  final String duration;
  final String imageUrl;

  const ArticleCard({
    super.key,
    required this.avatarUrl,
    required this.author,
    required this.role,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigation vers la page de détails
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(),
          ),
        );
      },
      splashColor: Colors.transparent,   // enlève effet ripple
      highlightColor: Colors.transparent, // enlève effet gris
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Partie gauche : infos texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Avatar + Nom + Rôle
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(avatarUrl),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              role,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF979797),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    /// Titre
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF242327),
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// Description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF979797),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    /// Date + durée
                    Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF979797),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "• $duration",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF979797),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Partie droite : Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  width: 100,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}