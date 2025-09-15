import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import './card_podcast.dart';
import '../../data/card_podcast.dart';

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
        return CardPodcast(
          duration: item.duration,
          title: item.title,
          date: item.date,
          likes: item.likes,
          imageUrl: item.imageUrl,
        );
      },
      options: CarouselOptions(
        height: 100,
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