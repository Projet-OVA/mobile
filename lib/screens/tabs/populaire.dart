import 'package:flutter/material.dart';
import 'package:SIRA/screens/tabs/education.dart';
import 'package:SIRA/screens/tabs/environnement.dart';
import 'package:SIRA/screens/tabs/mes_defis.dart';
import 'package:SIRA/widgets/tabs/environnement_card.dart';
import 'package:SIRA/widgets/tabs/populaire_carousel.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/utils/event_sort_utils.dart';
import 'package:SIRA/utils/date_format_utils.dart';
import 'package:SIRA/services/auth_storage.dart';
import '../../../widgets/tabs/main_layout_defi.dart';

class Populaire extends StatefulWidget {
  const Populaire({super.key});

  @override
  State<Populaire> createState() => _PopulaireState();
}

class _PopulaireState extends State<Populaire> with WidgetsBindingObserver {
  static const String pageName = 'defi_page'; // ✅ identifiant unique pour cette page
  int selectedFilter = 0;
  late Future<List<dynamic>> futureItems;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    futureItems = ApiService.getEvents();
    _loadLastSelectedTab(); // ✅ restauration du dernier onglet
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// ✅ Restaure le dernier filtre enregistré
  Future<void> _loadLastSelectedTab() async {
    final lastTab = await AuthStorage.getPageTab(pageName);
    if (lastTab != null) {
      setState(() {
        selectedFilter = lastTab;
      });
    }
  }
  /// Quand l’app passe en pause ou est fermée
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveCurrentTab();
    }
  }

  /// ✅ Sauvegarde du filtre et du chemin actuel
  Future<void> _saveCurrentTab() async {
    await AuthStorage.savePageTab(pageName, selectedFilter);
    switch (selectedFilter) {
      case 1:
        await AuthStorage.saveLastPath('/mesdefis');
        break;
      case 2:
        await AuthStorage.saveLastPath('/environnement');
        break;
      case 3:
        await AuthStorage.saveLastPath('/education');
        break;
      default:
        await AuthStorage.saveLastPath('/populaire');
    }
  }

  /// Sélection d’un filtre
  Future<void> _onFilterSelected(int index) async {
    setState(() {
      selectedFilter = index;
    });
    await AuthStorage.savePageTab(pageName, index);
    await _saveCurrentTab();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutDefi(
      selectedIndex: selectedFilter,
      onFilterSelected: _onFilterSelected,
      child: _buildContent(),
    );
  }

  /// ✅ Contenu dynamique selon le filtre
  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPopulaire();
      case 1:
        return const MesDefis();
      case 2:
        return const Environnement();
      case 3:
        return const Education();
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
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC113)),
            ),
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

        final items = EventSortUtils.sortByUpcoming(rawItems);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final e = items[index];
            final formattedDate =
            DateFormatUtils.formatDateFull(e['eventDate']);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
}
