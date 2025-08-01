import 'package:flutter/material.dart';

// Modèle de données pour les cartes du carrousel
class CarouselItem {
  final Color backgroundColor;
  final String title;
  final String imageUrl;
  final String description;

  CarouselItem({
    required this.backgroundColor,
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

// Liste des données de ton carrousel
List<CarouselItem> carouselItems = [
  CarouselItem(
    backgroundColor: Color.fromARGB(252, 241, 225, 1),
    title: 'Parcours citoyen',
    description: 'C\’est quoi être citoyen aujourd\’hui ?',
    imageUrl: 'images/couple.png',
  ),
  CarouselItem(
    backgroundColor: Color.fromARGB(85, 121, 207, 01),
    title: 'Parcours citoyen',
    description: 'Comment organiser un petit défi citoyen avec tes amis ?',
    imageUrl: 'images/trio.png',
  ),
  CarouselItem(
     backgroundColor: Color.fromARGB(85, 121, 207, 01),
    title: 'Parcours citoyen',
    description: 'Comment organiser un petit défi citoyen avec tes amis ?',
    imageUrl: 'images/trio.png',
  ),
];
