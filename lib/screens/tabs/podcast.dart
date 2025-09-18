import 'package:flutter/material.dart';
import '../../widgets/tabs/my_carousel_podcast.dart';

class Podcast extends StatelessWidget {
  const Podcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          // section 1
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Pour toi',
              style: TextStyle(color: Color(0xFF1C1C1C)),
            ),
          ),
          SizedBox(height: 19),
          MyCarouselPodcast(),
          SizedBox(height: 16),

          // section 2
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Communauté',
              style: TextStyle(color: Color(0xFF1C1C1C)),
            ),
          ),
          SizedBox(height: 19),
          MyCarouselPodcast(),
          SizedBox(height: 16),

          // section 3
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Éducation',
              style: TextStyle(color: Color(0xFF1C1C1C)),
            ),
          ),
          SizedBox(height: 19),
          MyCarouselPodcast(),
          SizedBox(height: 16),

          // section 4
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Inclusion',
              style: TextStyle(color: Color(0xFF1C1C1C)),
            ),
          ),
          SizedBox(height: 19),
          MyCarouselPodcast(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
