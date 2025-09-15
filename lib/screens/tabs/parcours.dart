import 'package:flutter/material.dart';
import '../../widgets/my_carousel.dart';
import '../../widgets/tabs/main_layout.dart';
import 'video.dart';
import 'podcast.dart';
import 'article.dart';


class Parcours extends StatefulWidget {
  const Parcours({super.key});

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> {
  int selectedFilter = 0;

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
        return _buildParcours();
      case 1:
        return _buildVideo();
      case 2:
        return _buildPodcast();
      case 3:
        return _buildArticle();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildParcours() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: const [
        // section 1
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Comprendre la citoyenneté',
            style: TextStyle(color: Color(0xFF1C1C1C)),
          ),
        ),
        SizedBox(height: 19),
        MyCarousel(),
        SizedBox(height: 16),
        // section 2
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Comprendre la citoyenneté',
            style: TextStyle(color: Color(0xFF1C1C1C)),
          ),
        ),
        SizedBox(height: 19),
        MyCarousel(),
        SizedBox(height: 16),
        // section 3
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Comprendre la citoyenneté',
            style: TextStyle(color: Color(0xFF1C1C1C)),
          ),
        ),
        SizedBox(height: 19),
        MyCarousel(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildVideo() => const Video();
  Widget _buildPodcast() => const Podcast();
  Widget _buildArticle() => const Article();
}
