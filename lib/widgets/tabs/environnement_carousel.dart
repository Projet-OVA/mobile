import 'package:SIRA/widgets/tabs/environnement_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../data/data_populaire.dart';

void callbackFunction(int index, CarouselPageChangedReason reason) {
  print('Page changée vers l\'index : $index');
}

class EnvironnementCarousel extends StatelessWidget {
  const EnvironnementCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carouselItems.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final item = carouselItems[itemIndex];
        return EnvironnementCard(
          imageAsset: item.imageAsset,
          title: item.title,
          date: item.date,
          location: item.location,
        );
      },
      options: CarouselOptions(
        height: 110,
        viewportFraction: 0.85,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: false,
        enlargeCenterPage: false,
        disableCenter: true,
        onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}