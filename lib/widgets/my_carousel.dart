import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import './custom_card.dart';
import '../data/card_data.dart';

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
          duration: item.duration,
          description: item.description,
          imageUrl: item.imageUrl,
        );
      },
      options: CarouselOptions(
        height: 230,
        viewportFraction: 0.5,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: false,
        enlargeCenterPage: false,
        onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}