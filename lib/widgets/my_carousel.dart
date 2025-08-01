import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Assure-toi que les chemins d'importation sont corrects
import './custom_card.dart';
import '../data/card_data.dart'; // Importe ton nouveau fichier de données

void callbackFunction(int index, CarouselPageChangedReason reason) {
  print('Page changée vers l\'index : $index');
}

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carouselItems.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final item = carouselItems[itemIndex];
        return CustomCard(
          backgroundColor: item.backgroundColor,
          title: item.title,
          description: item.description,
          imageUrl: item.imageUrl,
        );
      },
      options: CarouselOptions(
        height: 230,
        aspectRatio: 16 / 9,
        viewportFraction: 0.5,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: false,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}