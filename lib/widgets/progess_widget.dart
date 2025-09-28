import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final String title;
  final double progress;
  final String imagePath; // image à gauche

  const ProgressWidget({
    Key? key,
    required this.title,
    required this.progress,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double normalized = (progress / 100).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre en haut
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.86,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555257),
            ),
          ),
          const SizedBox(height: 8),

          // Ligne avec image + progress bar + % et statut
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image à gauche
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 12),

              // Progress bar au centre
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Fond
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE2DD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      // Barre de progression en gradient
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: normalized, // de 0.0 à 1.0
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFBF1A), // Jaune
                                Color(0xFFFF4080), // Rose
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(width: 12),

              Text(
                "${progress.toInt()}%",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(width: 09),
              Text(
                progress >= 100 ? "Complété" : "En cours",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA59E8E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
