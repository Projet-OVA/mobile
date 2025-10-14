import 'package:SIRA/screens/tabs/mes_defis_crees.dart';
import 'package:flutter/material.dart';
import '../../widgets/tabs/filter_bar_mesdefis.dart';
import '../../widgets/tabs/environnement_card.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/utils/event_sort_utils.dart';
import 'package:SIRA/utils/date_format_utils.dart';
import '../../widgets/custom_button.dart';
import '../tabs/ajout_defi.dart';

class MesDefis extends StatefulWidget {
  const MesDefis({super.key});

  @override
  State<MesDefis> createState() => _MesDefisState();
}

class _MesDefisState extends State<MesDefis> {
  int selectedFilter = 0;
  late Future<List<dynamic>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = ApiService.getEventsParticipateMe();
  }

  void onFilterSelected(int index) {
    setState(() {
      selectedFilter = index;
    });
  }

  void _refreshData() {
    setState(() {
      futureItems = ApiService.getEventsParticipateMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FilterBar toujours en haut
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            child: FilterBarMesdefis(onFilterSelected: onFilterSelected),
          ),
        ),
        // Contenu en dessous
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPresente();
      case 1:
        return _buildDefiCree();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPresente() {
    return FutureBuilder<List<dynamic>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFC113)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        final rawItems = snapshot.data ?? [];

        if (rawItems.isEmpty) {
          return const Center(child: Text('Aucun événement disponible'));
        }

        // Trier les événements futurs puis ceux qui sont passés
        final items = EventSortUtils.sortByUpcoming(rawItems);

        return Column(
          children: [
            // Liste des événements
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final e = items[index];
                  final formattedDate =
                  DateFormatUtils.formatDateFull(e['eventDate']);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 16),
                          child: Text(
                            'Environnement',
                            style: TextStyle(
                              color: Color(0xFF1C1C1C),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      EnvironnementCard(
                        eventId: e['id'].toString(),
                        imageAsset: e['image'] ?? 'assets/images/reboisement.png',
                        title: e['eventName'] ?? 'Sans titre',
                        date: formattedDate,
                        location: e['location'] ?? 'Localisation inconnue',
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            // Bouton Nouveau Défi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomButton(
                    text: 'Nouveau Défi',
                    borderRadius: 24,
                    icon: Icons.edit_note_outlined,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    boxShadow: [],
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AjoutDefi(),
                        ),
                      );

                      // Recharger les données si un nouveau défi a été créé
                      if (result == true && mounted) {
                        _refreshData();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefiCree() => const MesDefisCrees();
}
