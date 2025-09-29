import 'package:SIRA/widgets/tabs/card_populaire.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

void callbackFunction(int index, CarouselPageChangedReason reason) {
  print('Page changée vers l\'index : $index');
}

class PopulaireCarousel extends StatefulWidget {
  const PopulaireCarousel({super.key});

  @override
  State<PopulaireCarousel> createState() => _PopulaireCarouselState();
}

class _PopulaireCarouselState extends State<PopulaireCarousel> {
  late Future<List<dynamic>> futureItems;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    futureItems = ApiService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loader pendant le chargement
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Message d'erreur
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Erreur: ${snapshot.error}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loadData(); // retry
                    });
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data;

        if (items == null || items.isEmpty) {
          // Aucun élément
          return const Center(child: Text('Aucun évènement trouvé'));
        }
        // Données disponibles
        return CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            final item = items[itemIndex];
            String formattedDate = '';
            if (item['eventDate'] != null) {
              try {
                DateTime dateTime = DateTime.parse(item['eventDate'].toString());
                List<String> mois = [
                  '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
                  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
                ];
                formattedDate = '${dateTime.day} ${mois[dateTime.month]} ${dateTime.year}';
              } catch (e) {
                formattedDate = item['eventDate']?.toString() ?? '';
              }
            }
            return CardPopulaire(
              initialParticipating:  item['isParticipating'] ?? false,
              eventId: item['id'],
              imageAsset: item['image'] ?? 'assets/images/reboisement.png',
              title: item['eventName'] ?? 'Sans titre',
              date: formattedDate ?.toString() ?? 'Date inconnue',
              location: item['location'] ?? 'Localisation inconnue',
              participants: item['participantsCount']?.toString() ?? '0',
            );
          },
          options: CarouselOptions(
            height: 370,
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
      },
    );
  }
}
