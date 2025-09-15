import 'package:SIRA/screens/tabs/detail_podcast.dart';
import 'package:flutter/material.dart';

// --- Carte Podcast ---
class CardPodcast extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String duration;
  final int likes;

  const CardPodcast({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.duration,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigation vers la page détail
        Navigator.push(
         context,
          MaterialPageRoute(
           builder: (context) => const DetailPodcast(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[100], // fond gris clair
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image à gauche
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12),

            // Partie texte et détails
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF242327),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Infos : date, durée, likes
                  Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA7A6A5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${duration} mn",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA7A6A5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        likes.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA7A6A5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}