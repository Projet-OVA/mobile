import 'package:SIRA/widgets/card_statistique.dart';
import 'package:SIRA/widgets/tabs/main_layout_profile.dart';
import 'package:SIRA/widgets/tabs/my_carousel_podcast.dart';
import 'package:flutter/material.dart';
import '../widgets/my_carousel.dart';
import '../screens/tabs/recompense.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/services/auth_storage.dart';

class ProfilePage extends StatefulWidget {
  final int? initialTabIndex;

  const ProfilePage({super.key, this.initialTabIndex});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  // Nom unique pour cette page
  static const String pageName = 'profile';

  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ✅ Observer le cycle de vie de l'app
    _loadLastSelectedTab();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ Nettoyer l'observer
    super.dispose();
  }

  // ✅ Détecter quand l'app passe en arrière-plan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // ✅ L'app est mise en arrière-plan → SAUVEGARDER l'état
      AuthStorage.savePageTab(pageName, selectedFilter);

      if (selectedFilter == 1) {
        AuthStorage.saveLastPath('/recompense');
      } else {
        AuthStorage.saveLastPath('/profile');
      }
    }
  }

  Future<void> _loadLastSelectedTab() async {
    // ✅ Charger UNIQUEMENT si on vient du démarrage de l'app (initialTabIndex fourni)
    if (widget.initialTabIndex != null) {
      setState(() {
        selectedFilter = widget.initialTabIndex!;
      });
    }
    // Sinon, on reste sur 0 (Progression) par défaut
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutProfile(
      initialFilterIndex: selectedFilter, // ✅ AJOUTÉ : passer l'index actuel
      onFilterSelected: (index) async {
        setState(() {
          selectedFilter = index;
        });
        // ✅ Sauvegarder avec la méthode générique
        await AuthStorage.savePageTab(pageName, index);

        // ✅ Sauvegarder aussi le lastPath correspondant
        if (index == 1) {
          await AuthStorage.saveLastPath('/recompense');
        } else {
          await AuthStorage.saveLastPath('/profile');
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildProgression();
      case 1:
        return _buildRecompense();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildProgression() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CardStatistique(
                    number: "10",
                    label: "Quizz Réussis",
                    imagePath: "assets/images/quizze.png",
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: CardStatistique(
                    number: "09",
                    label: "Parcours",
                    imagePath: "assets/images/evolution.png",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          FutureBuilder<int>(
            future: ApiService.getMyEventsCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFC113)),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}"));
              }

              final eventsCount = snapshot.data ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CardStatistique(
                        number: "$eventsCount",
                        label: "Défis Créés",
                        imagePath: "assets/images/check.png",
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CardStatistique(
                        number: "18",
                        label: "Défis Relevés",
                        imagePath: "assets/images/releve.png",
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title(title: "Historique Parcours "),
                MyCarousel(),
                SizedBox(height: 16),
                Title(title: "Historique Quizz"),
                MyCarousel(),
                SizedBox(height: 16),
                Title(title: "Historique Podcast"),
                MyCarouselPodcast(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecompense() => const Recompense();
}

class Title extends StatelessWidget {
  final String title;

  const Title({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF88868A),
          ),
        ),
      ),
    );
  }
}