import 'package:flutter/material.dart';

// Modèle de données pour les cartes du carrousel
class CarouselItem {
  final String duration;
  final String imageUrl;
  final String description;

  CarouselItem({
    required this.duration,
    required this.imageUrl,
    required this.description,
  });
}

// Liste des données de ton carrousel
List<CarouselItem> carouselItems = [
  CarouselItem(
    duration: "11mn",
    description: 'C\’est quoi être citoyen aujourd\’hui ?',
    imageUrl: 'assets/images/couple.png',
  ),
  CarouselItem(
    duration: "11mn",
    description: 'Comment organiser un petit défi citoyen avec tes amis ?',
    imageUrl: 'assets/images/trio.png',
  ),
  CarouselItem(
    duration: "11mn",
    description: 'Comment organiser un petit défi citoyen avec tes amis ?',
    imageUrl: 'assets/images/trio.png',
  ),
];
