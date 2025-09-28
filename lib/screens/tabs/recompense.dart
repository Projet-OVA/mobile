import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/certification_card.dart';
import '../../widgets/progess_widget.dart';

class Recompense extends StatelessWidget {
  const Recompense({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      CertificationCard(title: 'Ndorte', subtitle: 'Bronze Certified'),
      CertificationCard(title: 'Expert Flutter', subtitle: 'Silver Certified'),
      CertificationCard(title: 'Master Dev', subtitle: 'Gold Certified'),
      CertificationCard(title: 'Elite Coder', subtitle: 'Platinum Certified'),
      CertificationCard(title: 'Senior Developer', subtitle: 'Diamond Certified'),
    ];

    return Scaffold(
      body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Carrousel
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: CarouselSlider(
                items: cards.map((card) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.3),
                    child: SizedBox(
                      width: 90,
                      child: card,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.6,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: false,
                  padEnds: false,
                  pageSnapping: true,
                  disableCenter: true,
                  autoPlay: false,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Progress bar
            const ProgressWidget(
              title: "Ndorte",
              progress: 100,
              imagePath: 'assets/images/medaille.png',
            ),
            const ProgressWidget(
              title: "Djed",
              progress: 50,
              imagePath: 'assets/images/medaille.png',
            ),
            const ProgressWidget(
              title: "Ankh",
              progress: 05,
              imagePath: 'assets/images/medaille.png',
            ),
          ],
        ),
      ),
      ),
    );
  }
}
