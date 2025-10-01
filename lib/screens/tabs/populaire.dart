import 'package:SIRA/screens/tabs/education.dart';
import 'package:SIRA/screens/tabs/environnement.dart';
import 'package:SIRA/screens/tabs/mes_defis.dart';
import 'package:SIRA/widgets/tabs/environnement_card.dart';
import 'package:SIRA/widgets/tabs/populaire_carousel.dart';
import 'package:flutter/material.dart';
import '../../../widgets/tabs/main_layout_defi.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/utils/event_sort_utils.dart';
import 'package:SIRA/utils/date_format_utils.dart';

class Populaire extends StatefulWidget {
  const Populaire({super.key});

  @override
  State<Populaire> createState() => _PopulaireState();
}

class _PopulaireState extends State<Populaire> {
  int selectedFilter = 0;
  late Future<List<dynamic>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = ApiService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutDefi(
      onFilterSelected: (index) {
        setState(() {
          selectedFilter = index;
        });
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPopulaire();
      case 1:
        return _buildMesDefis();
      case 2:
        return _buildEnvironnement();
      case 3:
        return _buildEducation();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPopulaire() {
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

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final e = items[index];
            final formattedDate = DateFormatUtils.formatDateFull(e['eventDate']);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // section 1
                if (index == 0) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Défis Populaires',
                      style: TextStyle(
                        color: Color(0xFF1C1C1C),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  const PopulaireCarousel(),
                  const SizedBox(height: 16),
                  // section 2
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Environnement',
                      style: TextStyle(
                        color: Color(0xFF1C1C1C),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                EnvironnementCard(
                  eventId: e['id'].toString(),
                  imageAsset: e['image'] ?? 'assets/images/reboisement.png',
                  title: e['eventName'] ?? 'Sans titre',
                  date: formattedDate,
                  location: e['location'] ?? 'Localisation inconnue',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMesDefis() => const MesDefis();
  Widget _buildEnvironnement() => const Environnement();
  Widget _buildEducation() => const Education();
}