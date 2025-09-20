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
    this.imageSize = 30,
    this.overlapOffset = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Images superposées
        SizedBox(
          width: (profileImages.length * overlapOffset) + imageSize,
          height: imageSize,
          child: Stack(
            children: [
              for (int i = 0; i < profileImages.length; i++)
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
                      backgroundImage: profileImages[i].startsWith('http')
                          ? NetworkImage(profileImages[i])
                          : AssetImage(profileImages[i]) as ImageProvider,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Texte avec le nombre de participants
        Text(
          '+$totalParticipants Participants',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF555257),
          ),
        ),
      ],
    );
  }
}