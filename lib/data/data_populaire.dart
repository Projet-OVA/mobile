import 'package:flutter/material.dart';

// Modèle de données pour les cartes du carrousel
class CarouselItem {
  final String imageAsset;
  final String title;
  final String date;
  final String location;
  final String participants;

  CarouselItem({
     required this.imageAsset,
    required this.title,
    required this.date,
    required this.location,
    required this.participants,
  });
}

// Liste des données de ton carrousel
List<CarouselItem> carouselItems = [
  CarouselItem(
    imageAsset: 'assets/images/reboisement.png', // ou .jpg selon votre format
    title: 'Journée de Reboisement sur la V...',
    date: '30 août 2025',
    location: 'VDN, Échangeur OMVS',
    participants: '+100 participants',
  ),
  CarouselItem(
    imageAsset: 'assets/images/reboisement.png', // ou .jpg selon votre format
    title: 'Journée de Reboisement sur la V...',
    date: '30 août 2025',
    location: 'VDN, Échangeur OMVS',
    participants: '+100 participants',
  ),
 CarouselItem(
   imageAsset: 'assets/images/reboisement.png', // ou .jpg selon votre format
   title: 'Journée de Reboisement sur la V...',
   date: '30 août 2025',
   location: 'VDN, Échangeur OMVS',
   participants: '+100 participants',
  ),
  CarouselItem(
    imageAsset: 'assets/images/reboisement.png', // ou .jpg selon votre format
    title: 'Journée de Reboisement sur la V...',
    date: '30 août 2025',
    location: 'VDN, Échangeur OMVS',
    participants: '+100 participants',
  ),
];
