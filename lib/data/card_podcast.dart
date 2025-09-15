import 'package:flutter/material.dart';

// Modèle de données pour les cartes du carrousel
class CarouselItem {
  final String imageUrl;
  final String title;
  final String date;
  final String duration;
  final int likes;

  CarouselItem({
     required this.imageUrl,
    required this.title,
    required this.date,
    required this.duration,
    required this.likes,
  });
}

// Liste des données de ton carrousel
List<CarouselItem> carouselItems = [
  CarouselItem(
    imageUrl: "assets/images/enfants.png",
    title: 'Portraits de jeunes qui changent leur quartier',
    date: '6 Sep',
    duration: '30',
    likes: 27,
  ),
  CarouselItem(
    imageUrl: "assets/images/enfants.png",
    title: 'Portraits de jeunes qui changent leur quartier',
    date: '6 Sep',
    duration: '30',
    likes: 27,
  ),
 CarouselItem(
    imageUrl: "assets/images/enfants.png",
    title: 'Portraits de jeunes qui changent leur quartier',
    date: '6 Sep',
    duration: '30',
    likes: 27,
  ),
];
