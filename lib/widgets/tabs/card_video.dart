import 'package:flutter/material.dart';

class CardVideo extends StatelessWidget {
  final String? title;
  final String? description;
  final String? duration;
  final String? thumbnail; // image d’accueil

  const CardVideo({
    super.key,
    this.title,
    this.description,
    this.duration,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vignette
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              thumbnail ?? "assets/images/videodemo.png",
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Texte à droite
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description!,
                      style: const TextStyle(
                        color: Color(0x8888868A),
                        fontSize: 10,
                      ),
                    ),
                  ),
                if (duration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$duration mn",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xBBBDBDBD),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
