import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/certification_card.dart';
import '../../widgets/progess_widget.dart';
import 'package:SIRA/services/api_service.dart';

class Recompense extends StatefulWidget {
  const Recompense({super.key});

  @override
  State<Recompense> createState() => _RecompenseState();
}

class _RecompenseState extends State<Recompense> {
  late Future<List<dynamic>> userBadges;
  late Future<int> futureProgression;

  @override
  void initState() {
    super.initState();
    userBadges = ApiService.getMyBadges();
    futureProgression = ApiService.getProgression();
  }

  String getBadgeTitle(int progress) {
    if (progress == 100) return "ANKH";
    if (progress >= 50) return "NDORTE";
    return "DJED";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Carrousel des badges
              FutureBuilder<List<dynamic>>(
                future: userBadges,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFFFFC113)),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 250,
                      child: Center(
                        child: Text('Erreur: ${snapshot.error}'),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: Text('Aucun badge disponible')),
                    );
                  }

                  final items = snapshot.data!;
                  final cards = items.map((e) {
                    return CertificationCard(
                      title: e['name'] ?? 'Badge',
                      subtitle: 'Bronze Certified',
                    );
                  }).toList();

                  return Container(
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
                        enableInfiniteScroll: false,
                        enlargeCenterPage: false,
                        padEnds: false,
                        pageSnapping: true,
                        disableCenter: true,
                        autoPlay: false,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Progression utilisateur
              FutureBuilder<int>(
                future: futureProgression,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Color(0xFFFFC113));
                  }

                  if (snapshot.hasError) {
                    return Text("Erreur: ${snapshot.error}");
                  }

                  if (!snapshot.hasData) {
                    return const Text("Pas de progression");
                  }

                  final progress = snapshot.data!;
                  final badgeTitle = getBadgeTitle(progress);

                  return ProgressWidget(
                    title: badgeTitle,
                    progress: progress.toDouble(),
                    imagePath: "assets/images/medaille.png",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
