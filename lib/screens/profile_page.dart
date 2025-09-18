import 'package:SIRA/widgets/card_statistique.dart';
import 'package:SIRA/widgets/tabs/main_layout_profile.dart';
import 'package:SIRA/widgets/tabs/my_carousel_podcast.dart';
import 'package:flutter/material.dart';
import '../widgets/my_carousel.dart';
import '../screens/tabs/recompense.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayoutProfile(
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
        return _buildProgression();
      case 1:
        return _buildRecompense();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildProgression() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20), // pour éviter que ça colle en bas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CardStatistique(
                    number: "12",
                    label: "Quizz Réussis",
                    imagePath: "assets/images/quizze.png",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardStatistique(
                    number: "09",
                    label: "Parcours",
                    imagePath: "assets/images/evolution.png",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CardStatistique(
                    number: "05",
                    label: "Défis Créés",
                    imagePath: "assets/images/check.png",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardStatistique(
                    number: "18",
                    label: "Défis Relevés",
                    imagePath: "assets/images/quizze.png",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
          style: const TextStyle(fontWeight: FontWeight.w500,
              fontSize: 14, color: Color(0xFF88868A)),
        ),
      ),
    );
  }
}
