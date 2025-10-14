import 'package:flutter/material.dart';

class CardProfiles extends StatelessWidget {
  final List<String> profileImages;
  final int totalParticipants;
  final double imageSize;
  final double overlapOffset;

  const CardProfiles({
    Key? key,
    required this.profileImages,
    required this.totalParticipants,
    this.imageSize = 18,
    this.overlapOffset = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si aucun participant, afficher juste le texte
    if (totalParticipants == 0) {
      return const Text(
        '0 Participant',
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF555257),
        ),
      );
    }

    // Nombre d'images à afficher (min entre participants et 5)
    final imagesToShow = totalParticipants < 5 ? totalParticipants : 5;

    // On répète les images disponibles pour atteindre le nombre voulu
    final displayImages = List.generate(
      imagesToShow,
          (index) => profileImages[index % profileImages.length],
    );

    final remainingCount = totalParticipants - 5;
    final shouldShowPlusCircle = totalParticipants > 5;

    // Calcul de la largeur totale
    final totalWidth = shouldShowPlusCircle
        ? (imagesToShow * overlapOffset) + imageSize + overlapOffset + imageSize
        : (imagesToShow * overlapOffset) + imageSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Images superposées
        SizedBox(
          width: totalWidth,
          height: imageSize,
          child: Stack(
            children: [
              // Affichage des avatars (max 5)
              for (int i = 0; i < displayImages.length; i++)
                Positioned(
                  left: i * overlapOffset,
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: imageSize / 2,
                      backgroundImage: displayImages[i].startsWith('http')
                          ? NetworkImage(displayImages[i])
                          : AssetImage(displayImages[i]) as ImageProvider,
                    ),
                  ),
                ),

              // Cercle jaune avec le + (uniquement si > 5 participants)
              if (shouldShowPlusCircle)
                Positioned(
                  left: imagesToShow * overlapOffset,
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC113),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Color(0xFF232125),
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 1),
        // Texte avec le nombre de participants
        Text(
          shouldShowPlusCircle
              ? '+$remainingCount Participants'
              : '$totalParticipants Participant${totalParticipants > 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF555257),
          ),
        ),
      ],
    );
  }
}