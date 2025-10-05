import 'package:flutter/material.dart';
import '../../data/models/publication_model.dart';
import './card_podcast.dart';

class MyCarouselPodcast extends StatelessWidget {
  final List<Publication>? podcasts; // Rendre optionnel avec ?

  const MyCarouselPodcast({
    super.key,
    this.podcasts, // Enlever required
  });

  @override
  Widget build(BuildContext context) {
    // Si pas de podcasts fournis, afficher un message
    if (podcasts == null || podcasts!.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Aucun podcast dans l\'historique',
            style: TextStyle(
              color: Color(0xFF979797),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: podcasts!.length,
        itemBuilder: (context, index) {
          final podcast = podcasts![index];
          return CardPodcast(
            publication: podcast,
          );
        },
      ),
    );
  }
}