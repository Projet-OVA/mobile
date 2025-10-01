import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/services/event_provider.dart';
import 'card_populaire.dart';
import 'package:SIRA/utils/event_sort_utils.dart';
import 'package:SIRA/utils/date_format_utils.dart';

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
    futureItems = ApiService.getEvents();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 370,
            child: Center(child: CircularProgressIndicator(color: Color(0xFFFFC113))),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 370,
            child: Center(
              child: Text('Erreur: ${snapshot.error}'),
            ),
          );
        }

        final rawItems = snapshot.data ?? [];

        if (rawItems.isEmpty) {
          return const SizedBox(
            height: 370,
            child: Center(child: Text('Aucun événement disponible')),
          );
        }

        // Trier les événements futurs puis ceux qui sont sont passés
        final items = EventSortUtils.sortByUpcoming(rawItems);

        // Initialiser les événements dans le provider après le premier frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final eventProvider = Provider.of<EventProvider>(context, listen: false);
          for (var e in items) {
            eventProvider.setEvent(
              e['id'].toString(),
              e['isParticipating'] ?? false,
              e['participantsCount'] ?? 0,
            );
          }
        });

        return CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, pageIndex) {
            final e = items[index];

            // Formatter la date
            final formattedDate = DateFormatUtils.formatDateFull(e['eventDate']);

            return CardPopulaire(
              eventId: e['id'].toString(),
              imageAsset: e['image'] ?? 'assets/images/reboisement.png',
              title: e['eventName'] ?? 'Sans titre',
              date: formattedDate,
              location: e['location'] ?? 'Localisation inconnue',
            );
          },
          options: CarouselOptions(
            height: 370,
            viewportFraction: 0.85,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: false,
          ),
        );
      },
    );
  }
}