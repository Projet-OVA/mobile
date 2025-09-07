import 'package:flutter/material.dart';
import '../../widgets/my_carousel.dart';
import 'main_layout.dart';
import 'parcours.dart';
import 'video.dart';
import 'podcast.dart';
import 'article.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedFilter = 0; // 0 = Parcours par défaut

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
        return const Parcours();
      case 1:
        return const Video();
      case 2:
        return const Podcast();
      case 3:
        return const Article();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }
}
